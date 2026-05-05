import { NextFunction, Request, Response } from 'express';
import {
  createIdValidatorChain,
  finalizeValidator,
  validateDescriptionObl,
  validateIdObl,
  validateNameObl,
} from './index.js';
import { validateUserId } from './user.js';

const validateIsReadOnly = (
  req: Request,
  res: Response,
  next: NextFunction,
) => {
  const { isReadOnly } = req.body;

  if (isReadOnly !== undefined && !(isReadOnly === 0 || isReadOnly === 1)) {
    return res
      .status(400)
      .json({ message: 'isReadOnly must be a boolean value.' });
  }
  next();
};

export const validateAllocRoundId = finalizeValidator(
  createIdValidatorChain('allocRoundId'),
);
export const validateCopiedAllocRoundId = finalizeValidator(
  createIdValidatorChain('copiedAllocRoundId'),
);

export const validateAllocRoundPost = finalizeValidator(
  validateNameObl,
  validateIsReadOnly,
  validateUserId,
  validateDescriptionObl,
);

export const validateAllocRoundCopyPost = finalizeValidator(
  validateAllocRoundPost,
  validateUserId,
  validateCopiedAllocRoundId,
);

export const validateAllocRoundPut = finalizeValidator(
  validateIdObl,
  validateAllocRoundPost,
);
