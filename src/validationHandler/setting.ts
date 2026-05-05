import {
  finalizeValidator,
  validateDescription,
  validateIdObl,
  validateVariableObl,
} from './index.js';

export const validateSettingPost = finalizeValidator(
  validateVariableObl,
  validateDescription,
);

export const validateSettingPut = finalizeValidator(
  validateSettingPost,
  validateIdObl,
);
