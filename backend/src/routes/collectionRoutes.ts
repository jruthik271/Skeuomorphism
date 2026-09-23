import { Router } from 'express';
import {
  getUserCollections,
  createCollection,
  updateCollection,
  deleteCollection,
  addItemToCollection,
} from '../controllers/collectionController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/', getUserCollections);
router.post('/', createCollection);
router.put('/:id', updateCollection);
router.delete('/:id', deleteCollection);
router.post('/:id/items', addItemToCollection);

export default router;
