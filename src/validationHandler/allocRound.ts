import {
  createIdValidatorChain,
  createOptionalBoolValidatorChain,
  finalizeValidator,
  validateDescriptionObl,
  validateIdObl,
  validateNameObl,
} from './index.js';
import { validateUserId } from './user.js';

export const validateAllocRoundId = finalizeValidator(
  createIdValidatorChain('allocRoundId'),
);
export const validateCopiedAllocRoundId = finalizeValidator(
  createIdValidatorChain('copiedAllocRoundId'),
);

export const validateAllocRoundPost = finalizeValidator(
  validateNameObl,
  createOptionalBoolValidatorChain('isReadOnly'),
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
