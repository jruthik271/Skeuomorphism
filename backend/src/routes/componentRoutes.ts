import { Router } from 'express';
import {
  getAllComponents,
  getComponentById,
  createComponent,
  updateComponent,
  deleteComponent,
  recordInteraction,
} from '../controllers/componentController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/', getAllComponents);
router.get('/:id', getComponentById);
router.post('/', authenticate, createComponent);
router.put('/:id', authenticate, updateComponent);
router.delete('/:id', authenticate, deleteComponent);
router.post('/:id/interact', recordInteraction);

export default router;
