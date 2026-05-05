import { validateBuildingId } from './building.js';
import {
  createBodyArrayValidatorChain,
  createBoolValidatorChain,
  createDescriptionValidatorChain,
  createFloatValidatorChain,
  createIdValidatorChain,
  createMultiBoolValidatorChain,
  createMultiDescriptionValidatorChain,
  createMultiFloatValidatorChain,
  createMultiNameValidatorChain,
  createMultiNumberValidatorChain,
  createMultiTimeValidatorChain,
  createNonZeroPositiveIntegerValidatorChain,
  //createTimeLengthValidatorChainHoursAndMinutes,
  createTimeValidatorChain,
  finalizeValidator,
  validateIdObl,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';
import { validateSpaceTypeId } from './spaceType.js';

export const validateSpaceId = finalizeValidator(
  createIdValidatorChain('spaceId'),
);

export const validateMultiSpaceInfo = finalizeValidator(
  createMultiDescriptionValidatorChain('info'),
);

export const validateSpacePost = finalizeValidator(
  validateNameObl,
  createFloatValidatorChain('area'),
  createDescriptionValidatorChain('info'),
  createNonZeroPositiveIntegerValidatorChain('personLimit'),
  createTimeValidatorChain('availableFrom'),
  createTimeValidatorChain('availableTo'),
  createTimeValidatorChain('classesFrom'),
  createTimeValidatorChain('classesTo'),
  validateBuildingId,
  validateSpaceTypeId,
  createBoolValidatorChain('inUse'),
  createBoolValidatorChain('isLowNoise'),
);

export const validateSpacePut = finalizeValidator(
  validateIdObl,
  validateSpacePost,
);

export const validateMultiSpacePost = finalizeValidator(
  createBodyArrayValidatorChain(),
  validateMultiNameObl,
  createMultiFloatValidatorChain('area'),
  validateMultiSpaceInfo,
  createMultiNumberValidatorChain('personLimit'),
  createMultiNameValidatorChain('buildingName'),
  createMultiTimeValidatorChain('availableFrom'),
  createMultiTimeValidatorChain('availableTo'),
  createMultiTimeValidatorChain('classesFrom'),
  createMultiTimeValidatorChain('classesTo'),
  createMultiBoolValidatorChain('inUse'),
  createMultiBoolValidatorChain('isLowNoise'),
  createMultiNameValidatorChain('spaceType'),
);
