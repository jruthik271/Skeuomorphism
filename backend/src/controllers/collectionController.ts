import { Response } from 'express';
import { Collection } from '../models/Collection';
import { AuthRequest } from '../middleware/auth';
import { User } from '../models/User';

export const getUserCollections = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const collections = await Collection.find({ userId: req.user?._id }).sort({ updatedAt: -1 });
    res.status(200).json({
      success: true,
      count: collections.length,
      data: collections,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_FETCH_COLLECTIONS',
      message: 'Failed to access operator parts drawer.',
    });
  }
};

export const createCollection = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { name, description, components, materials, isPublic } = req.body;

    const collection = await Collection.create({
      userId: req.user?._id,
      name,
      description,
      components: components || [],
      materials: materials || [],
      isPublic: isPublic ?? false,
    });

    await User.findByIdAndUpdate(req.user?._id, { $inc: { 'stats.collectionsCount': 1 } });

    res.status(201).json({
      success: true,
      message: 'Parts drawer created and filed.',
      data: collection,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_CREATE_COLLECTION',
      message: error.message || 'Failed to assemble collection drawer.',
    });
  }
};

export const updateCollection = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    let collection = await Collection.findById(req.params.id);
    if (!collection) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Parts drawer not found.',
      });
      return;
    }

    if (collection.userId.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Clearance denied to edit this collection.',
      });
      return;
    }

    collection = await Collection.findByIdAndUpdate(req.params.id, req.body, { new: true });

    res.status(200).json({
      success: true,
      message: 'Parts drawer updated.',
      data: collection,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_UPDATE_COLLECTION',
      message: error.message || 'Failed to update parts drawer.',
    });
  }
};

export const deleteCollection = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const collection = await Collection.findById(req.params.id);
    if (!collection) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Collection not found.',
      });
      return;
    }

    if (collection.userId.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Clearance denied.',
      });
      return;
    }

    await Collection.findByIdAndDelete(req.params.id);
    await User.findByIdAndUpdate(req.user?._id, { $inc: { 'stats.collectionsCount': -1 } });

    res.status(200).json({
      success: true,
      message: 'Parts drawer decommissioned.',
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_DELETE_COLLECTION',
      message: 'Failed to delete collection.',
    });
  }
};

export const addItemToCollection = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const { itemId, itemType } = req.body;
    const field = itemType === 'material' ? 'materials' : 'components';

    const collection = await Collection.findOneAndUpdate(
      { _id: req.params.id, userId: req.user?._id },
      { $addToSet: { [field]: itemId } },
      { new: true }
    );

    if (!collection) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Collection not found or inaccessible.',
      });
      return;
    }

    res.status(200).json({
      success: true,
      message: 'Item filed in collection drawer.',
      data: collection,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_ADD_ITEM',
      message: 'Failed to file item.',
    });
  }
};
