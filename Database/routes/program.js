const express = require("express");
const program = express.Router();
const db = require("../db/index");
const logger = require("../utils/logger");
const { dbErrorHandler, succsessHandler } = require("../responseHandler/index");

// Pääaineitten nimet ja id, selectiin
program.get("/getNames", (req, res) => {
  const sqlSelectName = "SELECT id, name FROM Program";
  db.query(sqlSelectName, (err, result) => {
    if (err) {
      dbErrorHandler(res, err, "Oops! Nothing came through - Program");
    } else {
      succsessHandler(res, result, "getNames successful - Program");
    }
  });
});

module.exports = program;
