const express = require("express");
const subject = express.Router();
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
const { validateAddUpdateSubject } = require("../validationHandler/index");

// Opetuksen, pääaineen sekä huonetyypin tiedot
subject.get("/getAll", (req, res) => {
  const sqlSelectSubjectProgram =
    "  SELECT s.id, s.name AS subjectName, s.groupSize, s.groupCount, s.sessionLength, s.sessionCount, s.area, s.programId, p.name AS programName, s.spaceTypeId, st.name AS spaceTypeName FROM Subject s JOIN Program p ON s.programId = p.id LEFT JOIN spacetype st ON s.spaceTypeId = st.id;";
  db.query(sqlSelectSubjectProgram, (err, result) => {
    if (err) {
      dbErrorHandler(res, err, "Oops! Nothing came through - Subject");
    } else {
      successHandler(res, result, "getAll successful - Subject");
    }
  });
});

// Opetuksien nimet ja id
subject.get("/getNames", (req, res) => {
  const sqlSelectSubjectNames = "SELECT id, name FROM Subject;";
  db.query(sqlSelectSubjectNames, (err, result) => {
    if (err) {
      dbErrorHandler(res, err, "Oops! Nothing came through - Subject");
    } else {
      successHandler(res, result, "getNames successful - Subject");
    }
  });
});

// Opetuksen lisäys
subject.post("/post", validateAddUpdateSubject, (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    logger.error("Validation error:  %O", errors);
  }
  if (!errors.isEmpty()) {
    return validationErrorHandler(res, "Formatting problem");
  }
  const name = req.body.name;
  const groupSize = req.body.groupSize;
  const groupCount = req.body.groupCount;
  const sessionLength = req.body.sessionLength;
  const sessionCount = req.body.sessionCount;
  const area = req.body.area;
  const programId = req.body.programId;
  const spaceTypeId = req.body.spaceTypeId;
  const sqlInsert =
    "INSERT INTO Subject (name, groupSize, groupCount, sessionLength, sessionCount, area, programId, spaceTypeId) VALUES (?,?,?,?,?,?,?,?)";
  db.query(
    sqlInsert,
    [
      name,
      groupSize,
      groupCount,
      sessionLength,
      sessionCount,
      area,
      programId,
      spaceTypeId,
    ],
    (err, result) => {
      if (!result) {
        requestErrorHandler(res, err, "Nothing to insert");
      } else if (err) {
        dbErrorHandler(res, err, "Oops! Create failed - Subject");
      } else {
        successHandler(
          res,
          { insertId: result.insertId },
          "Create successful - Subject"
        );
        logger.info("Subject " + req.body.name + " created");
      }
    }
  );
});

// Opetuksen poisto
subject.delete("/delete/:id", (req, res) => {
  const id = req.params.id;
  const sqlDelete = "DELETE FROM Subject WHERE id = ?;";
  db.query(sqlDelete, id, (err, result) => {
    if (err) {
      dbErrorHandler(res, err, "Oops! Delete failed - Subject");
    } else {
      successHandler(res, result, "Delete successful - Subject");
      logger.info("Subject deleted");
    }
  });
});

// Opetuksen muokkaus
subject.put("/update", validateAddUpdateSubject, (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    logger.error("Validation error:  %O", errors);
  }
  if (!errors.isEmpty()) {
    return validationErrorHandler(res, "Formatting problem");
  }
  const id = req.body.id;
  const name = req.body.name;
  const groupSize = req.body.groupSize;
  const groupCount = req.body.groupCount;
  const sessionLength = req.body.sessionLength;
  const sessionCount = req.body.sessionCount;
  const area = req.body.area;
  const programId = req.body.programId;
  const spaceTypeId = req.body.spaceTypeId;
  const sqlUpdate =
    "UPDATE Subject SET name = ?, groupSize = ?, groupCount = ?, sessionLength = ?, sessionCount = ?, area = ?,  programId = ?, spaceTypeId = ? WHERE id = ?";
  db.query(
    sqlUpdate,
    [
      name,
      groupSize,
      groupCount,
      sessionLength,
      sessionCount,
      area,
      programId,
      spaceTypeId,
      id,
    ],

    (err, result) => {
      if (!result) {
        requestErrorHandler(res, err, "Nothing to update");
      } else if (err) {
        dbErrorHandler(res, err, "Oops! Update failed - Subject");
      } else {
        successHandler(res, result, "Update successful - Subject");
        logger.info("Subject " + req.body.name + " updated");
      }
    }
  );
});

module.exports = subject;
