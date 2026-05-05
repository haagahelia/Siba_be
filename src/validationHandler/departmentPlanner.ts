import { validateDepartmentId } from './department.js';
import { finalizeValidator } from './index.js';
import { validateUserId } from './user.js';

// or:  validateDepartmentPlannerPost
export const validateUserIdAndDepartmentId = finalizeValidator(
  validateUserId,
  validateDepartmentId,
);
