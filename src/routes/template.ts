import express, { Request, Response } from 'express';
import { allowRoles } from '../authorization/allowRoles.js';
import { authenticator } from '../authorization/userValidation.js';
import { validate } from '../validationHandler/index.js';

const template = express.Router();

template.get(
  '/building',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download(
        './templates/building_template.xlsx',
        'building_templaatti.xlsx',
      );
  },
);

template.get(
  '/subject',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download('./templates/subject_template.xlsx', 'subject_templaatti.xlsx');
  },
);

template.get(
  '/space',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download('./templates/space_template.xlsx', 'space_templaatti.xlsx');
  },
);

template.get(
  '/spacetype',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download(
        './templates/spacetype_template.xlsx',
        'spacetype_templaatti.xlsx',
      );
  },
);

template.get(
  '/user',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download('./templates/user_template.xlsx', 'user_templaatti.xlsx');
  },
);

template.get(
  '/equipment',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download(
        './templates/equipment_template.xlsx',
        'equipment_templaatti.xlsx',
      );
  },
);

template.get(
  '/department',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download(
        './templates/department_template.xlsx',
        'department_templaatti.xlsx',
      );
  },
);

template.get(
  '/program',
  [authenticator, allowRoles('admin', 'planner'), validate],
  (req: Request, res: Response) => {
    res
      .status(200)
      .header({
        'Content-Type':
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        'Content-Disposition': 'attachment; filename=templaatti.xlsx',
      })
      .download('./templates/program_template.xlsx', 'program_templaatti.xlsx');
  },
);

export default template;
