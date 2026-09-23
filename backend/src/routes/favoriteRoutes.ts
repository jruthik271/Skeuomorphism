import { Router } from 'express';
import { getFavorites, addFavorite, removeFavorite } from '../controllers/favoriteController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/', getFavorites);
router.post('/', addFavorite);
router.delete('/:id', removeFavorite);

export default router;
