import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { User, IUser } from '../models/User';

export interface AuthRequest extends Request {
  user?: IUser;
  token?: string;
}

export const authenticate = async (req: AuthRequest, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      res.status(401).json({
        success: false,
        error: 'ERR_UNAUTHORIZED',
        message: 'No authorization token provided. Physical access restricted.',
      });
      return;
    }

    const token = authHeader.split(' ')[1];
    const secret = process.env.JWT_SECRET || 'skeuolab_super_secret_jwt_key_2026_dev_prod';
    const decoded: any = jwt.verify(token, secret);

    const user = await User.findById(decoded.id).select('-password');
    if (!user) {
      res.status(401).json({
        success: false,
        error: 'ERR_USER_NOT_FOUND',
        message: 'User session invalid or operator key revoked.',
      });
      return;
    }

    if (!user.isActive) {
      res.status(403).json({
        success: false,
        error: 'ERR_ACCOUNT_DISABLED',
        message: 'This operator account has been deactivated.',
      });
      return;
    }

    req.user = user;
    req.token = token;
    next();
  } catch (error: any) {
    res.status(401).json({
      success: false,
      error: 'ERR_INVALID_TOKEN',
      message: 'Authentication token expired or signature invalid.',
    });
  }
};
