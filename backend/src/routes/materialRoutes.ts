import { Router } from 'express';
import {
  getAllMaterials,
  getMaterialById,
  createMaterial,
  updateMaterial,
  deleteMaterial,
} from '../controllers/materialController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/', getAllMaterials);
router.get('/:id', getMaterialById);
router.post('/', authenticate, createMaterial);
router.put('/:id', authenticate, updateMaterial);
router.delete('/:id', authenticate, deleteMaterial);

export default router;
