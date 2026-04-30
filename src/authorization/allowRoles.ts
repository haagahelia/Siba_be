import { NextFunction, Request, Response } from 'express';
import { authorizationErrorHandler } from '../responseHandler/index.js';
import { RoleName, RolePropertyName } from '../types/custom.js';

const roleToPropertyName = (roleName: RoleName): RolePropertyName => {
  return `is${roleName.substring(0, 1).toUpperCase()}${roleName.substring(
    1,
  )}` as RolePropertyName;
};

export const allowRoles =
  (...roles: RoleName[]) =>
  (req: Request, res: Response, next: NextFunction) => {
    const hasAllowedRole = roles.some((roleName) => {
      return req.user[roleToPropertyName(roleName)] === 1;
    });

    if (!hasAllowedRole) {
      authorizationErrorHandler(
        req,
        res,
        `Roles missing, allowed roles: ${roles.join(', ')}`,
      );
      return;
    }

    next();
  };
