import {
  createIdValidatorChain,
  finalizeValidator,
  validateDescription,
  validateIdObl,
  validateMultiDescription,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';

export const validateBuildingId = finalizeValidator(
  createIdValidatorChain('buildingId'),
);

export const validateBuildingPost = finalizeValidator(
  validateNameObl,
  validateDescription,
);

export const validateBuildingPut = finalizeValidator(
  validateBuildingPost,
  validateIdObl,
);

// This is a bit different as body can have multiple objects,
// => MultiPost!!!
export const validateBuildingMultiPost = finalizeValidator(
  validateMultiNameObl,
  validateMultiDescription,
);
