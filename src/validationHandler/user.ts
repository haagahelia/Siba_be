import { body, check } from 'express-validator';
import {
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

export const validateUserPost = finalizeValidator(
  check('email').notEmpty().withMessage('Email cannot be empty').bail(),
  createBoolValidatorChain('isAdmin'),
  createBoolValidatorChain('isPlanner'),
  createBoolValidatorChain('isStatist'),
);

export const validateMultiUserPost = finalizeValidator(
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
