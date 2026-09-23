import { Router } from 'express';
import { z } from 'zod';
import { register, login, getMe, logout } from '../controllers/authController';
import { authenticate } from '../middleware/auth';
import { validate } from '../middleware/validate';

const router = Router();

const registerSchema = z.object({
  name: z.string().min(2, 'Name must have at least 2 characters').max(80),
  email: z.string().email('Invalid email address format'),
  password: z.string().min(6, 'Passkey must be at least 6 characters'),
});

const loginSchema = z.object({
  email: z.string().email('Invalid email address format'),
  password: z.string().min(1, 'Password required'),
});

router.post('/register', validate(registerSchema), register);
router.post('/login', validate(loginSchema), login);
router.get('/me', authenticate, getMe);
router.post('/logout', authenticate, logout);

export default router;
