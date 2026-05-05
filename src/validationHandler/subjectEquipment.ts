import { validateEquipmentId } from './equipment.js';
import {
  createBoolValidatorChain,
  createNumberValidatorChain,
  finalizeValidator,
} from './index.js';
import { validateSubjectId } from './subject.js';

export const validateSubjectEquipmentPost = finalizeValidator(
  validateSubjectId,
  validateEquipmentId,
  createNumberValidatorChain('priority'),
  createBoolValidatorChain('obligatory'),
);

export const validateSubjectAndEquipmentId = finalizeValidator(
  validateSubjectId,
  validateEquipmentId,
);
