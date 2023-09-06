import express from 'express';
import { Request, Response } from 'express';
import { Result, ValidationError, validationResult } from 'express-validator'; // import { body,} ??

import db from '../db/index.js';
import logger from '../utils/logger.js';
import {
  dbErrorHandler,
  successHandler,
  requestErrorHandler,
  validationErrorHandler,
} from '../responseHandler/index.js';
import { validateSubjectEquipmentPostAndPut } from '../validationHandler/subjectEquipment.js';

const subjectequipment = express.Router();

// Getting all equipment requirement rows for a subject based on the subject id
subjectequipment.get('/getEquipment/:subjectId', (req, res) => {
  const subjectId = req.params.subjectId;
  const sqlGetEquipmentBySubjectId =
    'SELECT se.subjectId , e.name,e.description, se.equipmentId, se.priority, se.obligatory FROM SubjectEquipment se JOIN Equipment e ON se.equipmentId = e.id WHERE se.subjectid = ?;';
  db.query(sqlGetEquipmentBySubjectId, subjectId, (err, result) => {
    if (err) {
      dbErrorHandler(
        req,
        res,
        err,
        'Oops! Nothing came through - SubjectEquipment',
      );
    } else {
      successHandler(
        req,
        res,
        result,
        'getEquipment successful - SubjectEquipment',
      );
    }
  });
});

// Adding a equipment requirement to teaching/subject
subjectequipment.post(
  '/post',
  validateSubjectEquipmentPostAndPut,
  (req: Request, res: Response) => {
    const validationResults: Result<ValidationError> = validationResult(req);
    // if (!validationResults.isEmpty()) {
    //   logger.error('Validation error:  %O', errors);
    // }
    if (!validationResults.isEmpty()) {
      return validationErrorHandler(
        req,
        res,
        'Formatting problem',
        validationResults,
      );
    }
    const subjectId = req.body.subjectId;
    const equipmentId = req.body.equipmentId;
    const priority = req.body.priority;
    const obligatory = req.body.obligatory;
    const sqlInsert =
      'INSERT INTO SubjectEquipment (subjectId, equipmentId, priority, obligatory) VALUES (?,?,?,?)';
    db.query(
      sqlInsert,
      [subjectId, equipmentId, priority, obligatory],
      (err, result) => {
        if (!result) {
          requestErrorHandler(req, res, `${err}: Nothing to insert`);
        } else if (err) {
          dbErrorHandler(
            req,
            res,
            err,
            'Oops! Create failed - SubjectEquipment',
          );
        } else {
          successHandler(
            req,
            res,
            { insertId: result.insertId },
            'Create successful - SubjectEquipment',
          );
          logger.info(
            `SubjectEquipment created subjectId ${req.body.subjectId} &
              ${req.body.equipmentId}`,
          );
        }
      },
    );
  },
);

// Removing an equipment requirement from a subject
subjectequipment.delete('/delete/:subjectId/:equipmentId', (req, res) => {
  const subjectId = req.params.subjectId;
  const equipmentId = req.params.equipmentId;
  const sqlDelete =
    'DELETE FROM SubjectEquipment WHERE subjectId = ? AND equipmentId = ?;';
  db.query(sqlDelete, [subjectId, equipmentId], (err, result) => {
    if (err) {
      dbErrorHandler(req, res, err, 'Oops! Delete failed - SubjectEquipment');
    } else {
      successHandler(req, res, result, 'Delete successful - SubjectEquipment');
      logger.info('SubjectEquipment deleted');
    }
  });
});

// Modifying the equipment required by the subject/teaching
subjectequipment.put(
  '/update',
  validateSubjectEquipmentPostAndPut,
  (req: Request, res: Response) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      logger.error('Validation error: %0', errors);
    }
    if (!errors.isEmpty()) {
      return validationErrorHandler(req, res, 'Formatting problem');
    }
    const priority = req.body.priority;
    const obligatory = req.body.obligatory;
    const subjectId = req.body.subjectId;
    const equipmentId = req.body.equipmentId;
    const sqlUpdate =
      ' UPDATE SubjectEquipment SET priority = ?, obligatory = ? WHERE subjectId = ? AND equipmentId = ?;';
    db.query(
      sqlUpdate,
      [priority, obligatory, subjectId, equipmentId],
      (err, result) => {
        if (!result) {
          requestErrorHandler(req, res, `${err}: Nothing to update`);
        } else if (err) {
          dbErrorHandler(
            req,
            res,
            err,
            'Oops! Update failed - SubjectEquipment',
          );
        } else {
          successHandler(
            req,
            res,
            result,
            'Update successful - SubjectEquipment',
          );
          logger.info('SubjectEquipment ', req.body.subjectId, ' updated');
        }
      },
    );
  },
);

export default subjectequipment;
