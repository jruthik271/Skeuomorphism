import { Response, NextFunction } from 'express';
import { AuthRequest } from './auth';

export const requireRole = (role: 'ADMIN' | 'USER') => {
  return (req: AuthRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({
        success: false,
        error: 'ERR_UNAUTHORIZED',
        message: 'Authentication required for privileged instrumentation.',
      });
      return;
    }

    if (req.user.role !== role && req.user.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: `Clearance level [${role}] required. Operator clearance is [${req.user.role}].`,
      });
      return;
    }

    next();
  };
};

export const requireAdmin = requireRole('ADMIN');
