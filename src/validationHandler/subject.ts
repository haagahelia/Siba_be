import { validateAllocRoundId } from './allocRound.js';
import {
  createBodyArrayValidatorChain,
  createBoolValidatorChain,
  createFloatValidatorChain,
  createIdValidatorChain,
  createMultiBoolValidatorChain,
  createMultiFloatValidatorChain,
  createMultiNumberValidatorChain,
  createMultiTimeValidatorChain,
  createNonZeroPositiveIntegerValidatorChain,
  createNumberValidatorChain,
  createTimeLengthValidatorChainHoursAndMinutes,
  createTimeValidatorChain,
  finalizeValidator,
  validateIdObl,
  validateMultiNameObl,
  validateNameObl,
} from './index.js';
import { validateProgramId } from './program.js';
import { validateSpaceTypeId } from './spaceType.js';

// This is a validator used by other routes which need subjectId as a foreign key
export const validateSubjectId = finalizeValidator(
  createIdValidatorChain('subjectId'),
);

export const validateAllocRoundIdAndSubjectId = finalizeValidator(
  validateAllocRoundId,
  validateSubjectId,
);

export const validateSubjectPost = finalizeValidator(
  validateNameObl,
  createNonZeroPositiveIntegerValidatorChain('groupSize'),
  createNonZeroPositiveIntegerValidatorChain('groupCount'),
  createTimeLengthValidatorChainHoursAndMinutes('sessionLength'),
  createNonZeroPositiveIntegerValidatorChain('sessionCount'),
  createFloatValidatorChain('area'),
  createBoolValidatorChain('isNoisy'),
  validateProgramId,
  validateSpaceTypeId,
);

// See how the PUT is usually just POST + id that exists for PUT already
export const validateSubjectPut = finalizeValidator(
  validateIdObl,
  validateSubjectPost,
);

// This is an example of rare need: When posting several Subject objects in request
// body as JSON array
export const validateSubjectMultiPost = finalizeValidator(
  createBodyArrayValidatorChain(),
  validateMultiNameObl,
  createMultiNumberValidatorChain('groupCount'),
  createMultiNumberValidatorChain('groupSize'),
  createMultiTimeValidatorChain('sessionLength'),
  createMultiFloatValidatorChain('area'),
  createMultiBoolValidatorChain('isNoisy'),
);
