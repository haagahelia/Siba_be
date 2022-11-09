const express = require("express");
const subjectequipment = express.Router();
//import db from ("../db/index");
const db = require("../db/index");
const logger = require("../utils/logger");
const {
  dbErrorHandler,
  successHandler,
  requestErrorHandler,
  validationErrorHandler,
} = require("../responseHandler/index");
const { body, validationResult } = require("express-validator");
const {
  validateAddUpdateSubjectEquipment,
} = require("../validationHandler/index");

subjectequipment.post(
  "/post",
  validateAddUpdateSubjectEquipment,
  (req, res) => {
    console.log("body:", req.body);
    // Tähän vielä validation
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      logger.error("Validation error:  %O", errors);
    }
    if (!errors.isEmpty()) {
      return validationErrorHandler(res, "Formatting problem");
    }
    const subjectId = req.body.subjectId;
    const equipmentId = req.body.equipmentId;
    const priority = req.body.priority;
    const obligatory = req.body.obligatory;
    const sqlInsert =
      "INSERT INTO subjectequipment (subjectId, equipmentId, priority, obligatory) VALUES (?,?,?,?)";
    db.query(
      sqlInsert,[subjectId, equipmentId, priority, obligatory],
      (err, result) => {
        if (!result) {
          requestErrorHandler(res, err, "Nothing to insert");
        } else if (err) {
          dbErrorHandler(res, err, "Oops! Create failed - SubjectEquipment");
        } else {
          //console.log(result.insertId);
          successHandler(
            res,
            { insertId: result.insertId },
            "Create successful - Subject"
          );
          logger.info(
            "SubjectEquipment created for subjectId " + req.body.subjectId
          );
        }
      }
    );
  }
);

module.exports = subjectequipment;
