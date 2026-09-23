import { Router } from 'express';
import {
  getAdminStats,
  getUsers,
  updateUserRole,
  toggleUserStatus,
  getAuditLogs,
  triggerReseed,
} from '../controllers/adminController';
import { authenticate } from '../middleware/auth';
import { requireAdmin } from '../middleware/roles';

const router = Router();

router.use(authenticate, requireAdmin);

router.get('/stats', getAdminStats);
router.get('/users', getUsers);
router.put('/users/:userId/role', updateUserRole);
router.put('/users/:userId/status', toggleUserStatus);
router.get('/audit-logs', getAuditLogs);
router.post('/reseed', triggerReseed);

export default router;
