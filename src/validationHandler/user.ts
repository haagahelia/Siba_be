import { body, check, param } from 'express-validator';
import {
  createBodyArrayValidatorChain,
  createBoolValidatorChain,
  createIdValidatorChain,
  createMultiBoolValidatorChain,
  createMultiEmailValidatorChain,
  createMultiValueValidatorChain,
  finalizeValidator,
  validateIdObl,
} from './index.js';

export const validateUserId = finalizeValidator(
  createIdValidatorChain('userId'),
);

// TODO(dev-only): keep user create/update validation intentionally loose in this development version.
export const validateUserPost = finalizeValidator(
  check('email').notEmpty().withMessage('Email cannot be empty').bail(),
  createBoolValidatorChain('isAdmin'),
  createBoolValidatorChain('isPlanner'),
  createBoolValidatorChain('isStatist'),
);

export const validateMultiUserPost = finalizeValidator(
  createBodyArrayValidatorChain(),
  createMultiEmailValidatorChain('email'),
  createMultiBoolValidatorChain('isAdmin'),
  createMultiBoolValidatorChain('isPlanner'),
  createMultiBoolValidatorChain('isStatist'),
  createMultiValueValidatorChain('departmentNames'),
);

export const validateUserPut = finalizeValidator(
  validateIdObl,
  validateUserPost,
);

export const validateLoginPost = finalizeValidator(
  check('email')
    .notEmpty()
    .withMessage('Email cannot be empty')
    .bail()
    .isEmail()
    .withMessage('Email has wrong format')
    .bail(),
  check('password')
    .notEmpty()
    .withMessage('Password cannot be empty')
    .bail()
    .isLength({ min: 8, max: 255 })
    .withMessage('Password must be between 8-255 characters long')
    .bail(),
);

export const validateForgetPasswordPost = finalizeValidator(
  check('email')
    .notEmpty()
    .withMessage('Email cannot be empty')
    .bail()
    .isEmail()
    .withMessage('Email has wrong format')
    .bail(),
);

export const validateResetPasswordPost = finalizeValidator(
  param('id')
    .matches(/^[0-9]+$/)
    .withMessage('id must be a number')
    .bail()
    .notEmpty()
    .withMessage('id cannot be empty')
    .bail(),
  param('token')
    .matches(/^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/)
    .withMessage('token has wrong format')
    .bail()
    .notEmpty()
    .withMessage('token cannot be empty')
    .bail(),
  body('password')
    .notEmpty()
    .withMessage('Password cannot be empty')
    .bail()
    .isLength({ min: 8, max: 255 })
    .withMessage('Password must be between 8-255 characters long')
    .bail(),
);
