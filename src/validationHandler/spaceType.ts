import {
  createBodyArrayValidatorChain,
  createIdValidatorChain,
  finalizeValidator,
  validateAcronymObl,
  validateDescription,
  validateIdObl,
  validateMultiAcronymObl,
  validateMultiDescription,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';

export const validateSpaceTypeId = finalizeValidator(
  createIdValidatorChain('spaceTypeId'),
);

export const validateSpaceTypePost = finalizeValidator(
  validateNameObl,
  validateAcronymObl,
  validateDescription,
);

export const validateSpaceTypePut = finalizeValidator(
  validateSpaceTypePost,
  validateIdObl,
);

//I got the below code from building.ts and it had the following comments on it, so I'm copying them over -Vivienne

// This is a bit different as body can have multiple objects,
// => MultiPost!!!
export const validateSpaceTypeMultiPost = finalizeValidator(
  createBodyArrayValidatorChain(),
  validateMultiNameObl,
  validateMultiAcronymObl,
  validateMultiDescription,
);
