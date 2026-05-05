import {
  createIdValidatorChain,
  finalizeValidator,
  validateDescription,
  validateIdObl,
  validateMultiDescription,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';

export const validateDepartmentId = finalizeValidator(
  createIdValidatorChain('departmentId'),
);

export const validateDepartmentPost = finalizeValidator(
  validateNameObl,
  validateDescription,
);

export const validateDepartmentMultiPost = finalizeValidator(
  validateMultiNameObl,
  validateMultiDescription,
);

export const validateDepartmentPut = finalizeValidator(
  validateDepartmentPost,
  validateIdObl,
);
