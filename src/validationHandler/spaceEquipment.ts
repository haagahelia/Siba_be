import { validateEquipmentId } from './equipment.js';
import { finalizeValidator } from './index.js';
import { validateSpaceId } from './space.js';

export const validateSpaceEquipmentPost = finalizeValidator(
  validateSpaceId,
  validateEquipmentId,
);

export const validateSpaceAndEquipmentId = finalizeValidator(
  validateSpaceId,
  validateEquipmentId,
);
