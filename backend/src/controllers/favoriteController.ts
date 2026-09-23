import { Response } from 'express';
import { Favorite } from '../models/Favorite';
import { AuthRequest } from '../middleware/auth';
import { User } from '../models/User';

export const getFavorites = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const favorites = await Favorite.find({ userId: req.user?._id }).sort({ createdAt: -1 });
    res.status(200).json({
      success: true,
      count: favorites.length,
      data: favorites,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_FETCH_FAVORITES',
      message: 'Failed to access quick-access tool belt.',
    });
  }
};

export const addFavorite = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { itemId, itemType, metadata } = req.body;

    const existing = await Favorite.findOne({ userId: req.user?._id, itemId });
    if (existing) {
      res.status(200).json({
        success: true,
        message: 'Item already pinned to tool belt.',
        data: existing,
      });
      return;
    }

    const favorite = await Favorite.create({
      userId: req.user?._id,
      itemId,
      itemType,
      metadata: metadata || {},
    });

    const statField = itemType === 'material' ? 'stats.savedMaterials' : 'stats.savedComponents';
    await User.findByIdAndUpdate(req.user?._id, { $inc: { [statField]: 1 } });

    res.status(201).json({
      success: true,
      message: 'Item pinned to quick-access bench.',
      data: favorite,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_ADD_FAVORITE',
      message: error.message || 'Failed to pin item.',
    });
  }
};

export const removeFavorite = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const id = String(req.params.id);
    const favorite = await Favorite.findOneAndDelete({
      userId: req.user?._id,
      $or: [{ _id: /^[0-9a-fA-F]{24}$/.test(id) ? id : null }, { itemId: id }],
    });

    if (favorite) {
      const statField = favorite.itemType === 'material' ? 'stats.savedMaterials' : 'stats.savedComponents';
      await User.findByIdAndUpdate(req.user?._id, { $inc: { [statField]: -1 } });
    }

    res.status(200).json({
      success: true,
      message: 'Item unpinned from quick-access bench.',
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_REMOVE_FAVORITE',
      message: 'Failed to unpin item.',
    });
  }
};
