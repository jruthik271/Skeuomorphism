import { Router, Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { trackInteraction, getUserAnalytics, getAdminAnalytics } from '../controllers/analyticsController';
import { authenticate, AuthRequest } from '../middleware/auth';
import { requireAdmin } from '../middleware/roles';
import { User } from '../models/User';

const router = Router();

// Optional authentication for trackInteraction
const optionalAuth = async (req: AuthRequest, res: Response, next: NextFunction): Promise<void> => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      const secret = process.env.JWT_SECRET || 'skeuolab_super_secret_jwt_key_2026_dev_prod';
      const decoded: any = jwt.verify(token, secret);
      const user = await User.findById(decoded.id).select('-password');
      if (user) req.user = user;
    }
  } catch (err) {
    // Ignore invalid token in optional auth
  }
  next();
};

router.post('/track', optionalAuth, trackInteraction);
router.get('/me', authenticate, getUserAnalytics);
router.get('/admin', authenticate, requireAdmin, getAdminAnalytics);

export default router;
