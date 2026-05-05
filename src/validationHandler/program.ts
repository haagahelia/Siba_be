import {
  createBodyArrayValidatorChain,
  createIdValidatorChain,
  createMultiNameValidatorChain,
  finalizeValidator,
  validateIdObl,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';

export const validateProgramId = finalizeValidator(
  createIdValidatorChain('programId'),
);

// this needs to continue
export const validateProgramPost = finalizeValidator(
  validateNameObl,
  createIdValidatorChain('departmentId'),
);

export const validateProgramPut = finalizeValidator(
  validateProgramPost,
  validateIdObl,
);

export const validateProgramMultiPost = finalizeValidator(
  createBodyArrayValidatorChain(),
  validateMultiNameObl,
  createMultiNameValidatorChain('department'),
);
