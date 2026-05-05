import {
  createBoolValidatorChain,
  createIdValidatorChain,
  createMultiBoolValidatorChain,
  createMultiNumberValidatorChain,
  createNumberValidatorChain,
  finalizeValidator,
  validateDescription,
  validateIdObl,
  validateMultiDescription,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';

export const validateEquipmentId = finalizeValidator(
  createIdValidatorChain('equipmentId'),
);

export const validateEquipmentPost = finalizeValidator(
  validateNameObl,
  validateDescription,
  createNumberValidatorChain('priority'),
  createBoolValidatorChain('isMovable'),
);

export const validateEquipmentPut = finalizeValidator(
  validateEquipmentPost,
  validateIdObl,
);

export const validateEquipmentMultiPost = finalizeValidator(
  validateMultiNameObl,
  createMultiBoolValidatorChain('isMovable'),
  createMultiNumberValidatorChain('priority'),
  validateMultiDescription,
);
