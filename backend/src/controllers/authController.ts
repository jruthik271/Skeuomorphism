import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { User } from '../models/User';
import { Activity } from '../models/Activity';
import { AuthRequest } from '../middleware/auth';

const generateTokens = (id: string, role: string) => {
  const secret = process.env.JWT_SECRET || 'skeuolab_super_secret_jwt_key_2026_dev_prod';
  const refreshSecret = process.env.JWT_REFRESH_SECRET || 'skeuolab_refresh_secret_key_2026_dev_prod';

  const token = jwt.sign({ id, role }, secret, { expiresIn: '7d' });
  const refreshToken = jwt.sign({ id, role }, refreshSecret, { expiresIn: '30d' });

  return { token, refreshToken };
};

export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email: email.toLowerCase() });
    if (existingUser) {
      res.status(409).json({
        success: false,
        error: 'ERR_EMAIL_IN_USE',
        message: 'An operator with this callsign/email is already registered.',
      });
      return;
    }

    const user = await User.create({
      name,
      email: email.toLowerCase(),
      password,
      role: 'USER',
    });

    const { token, refreshToken } = generateTokens(user._id.toString(), user.role);

    await Activity.create({
      userId: user._id,
      action: 'USER_REGISTER',
      category: 'auth',
      metadata: { email: user.email },
    });

    res.status(201).json({
      success: true,
      message: 'Operator account commissioned successfully.',
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          role: user.role,
          avatar: user.avatar,
          stats: user.stats,
          createdAt: user.createdAt,
        },
        token,
        refreshToken,
      },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_REGISTRATION_FAILED',
      message: error.message || 'Operator registration failed.',
    });
  }
};

export const login = async (req: Request, res: Response): Promise<void> => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email: email.toLowerCase() }).select('+password');
    if (!user) {
      res.status(401).json({
        success: false,
        error: 'ERR_INVALID_CREDENTIALS',
        message: 'Invalid operator email or passkey.',
      });
      return;
    }

    const isMatch = await user.comparePassword(password);
    if (!isMatch) {
      res.status(401).json({
        success: false,
        error: 'ERR_INVALID_CREDENTIALS',
        message: 'Invalid operator email or passkey.',
      });
      return;
    }

    if (!user.isActive) {
      res.status(403).json({
        success: false,
        error: 'ERR_ACCOUNT_DISABLED',
        message: 'Operator access credentials have been suspended.',
      });
      return;
    }

    const { token, refreshToken } = generateTokens(user._id.toString(), user.role);

    await Activity.create({
      userId: user._id,
      action: 'USER_LOGIN',
      category: 'auth',
      metadata: { timestamp: new Date() },
    });

    res.status(200).json({
      success: true,
      message: 'Authentication successful. Control console unlocked.',
      data: {
        user: {
          id: user._id,
          name: user.name,
          email: user.email,
          role: user.role,
          avatar: user.avatar,
          stats: user.stats,
          createdAt: user.createdAt,
        },
        token,
        refreshToken,
      },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_LOGIN_FAILED',
      message: error.message || 'Authentication sequence failed.',
    });
  }
};

export const getMe = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const user = req.user;
    res.status(200).json({
      success: true,
      data: {
        user: {
          id: user?._id,
          name: user?.name,
          email: user?.email,
          role: user?.role,
          avatar: user?.avatar,
          stats: user?.stats,
          createdAt: user?.createdAt,
        },
      },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_FETCH_USER',
      message: 'Failed to retrieve operator profile telemetry.',
    });
  }
};

export const logout = async (req: AuthRequest, res: Response): Promise<void> => {
  if (req.user) {
    await Activity.create({
      userId: req.user._id,
      action: 'USER_LOGOUT',
      category: 'auth',
      metadata: { timestamp: new Date() },
    });
  }
  res.status(200).json({
    success: true,
    message: 'Operator session terminated. Instrumentation locked.',
  });
};
