/*
---- WINSTON LOGGER ----
Winston logger is a generic JavaScript logger. We can use it to log events and errors that
happen on the backend.
It's possible to edit the logging formats and the logging levels.
NPM: https://www.npmjs.com/package//winston
*/

import { createLogger, transports, format } from "winston";
const LEVEL = Symbol.for("level");

// Modifying the log for easier reading
const customFormat = format.combine(
  format.timestamp({ format: "YYMMDD HH:mm:ss" }),
  format.splat(),
  format.printf((info) => {
    return `${info.timestamp}-${info.level.toLocaleUpperCase()}-${
      info.message
    }`;
  })
);

// Which log levels we want to show / see
function filterOnly(level) {
  return format(function (info, http) {
    // @ts-ignore
    if (info[LEVEL] === level) {
      return info;
    }
    if (http[LEVEL] === level) {
      return http;
    }
  })();
}

const logger = createLogger({
  format: customFormat,
  transports: [
    new transports.Console({ level: "silly" }),
    // Where are which logs saved
    new transports.File({
      filename: "./utils/app.log",
      level: "info",
      format: filterOnly("info"),
    }),
    new transports.File({ filename: "./utils/error.log", level: "error" }),
    new transports.File({
      filename: "./utils/http.log",
      level: "http",
      format: filterOnly("http"),
    }),
  ],
});

export default logger;
