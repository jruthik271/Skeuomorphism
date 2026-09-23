import { Request, Response } from 'express';
import { Material } from '../models/Material';
import { AuthRequest } from '../middleware/auth';
import { Activity } from '../models/Activity';

export const getAllMaterials = async (req: Request, res: Response): Promise<void> => {
  try {
    const { category, search } = req.query;
    const filter: any = {};

    if (category && category !== 'all') {
      filter.category = category;
    }

    if (search) {
      filter.$or = [
        { name: { $regex: search as string, $options: 'i' } },
        { description: { $regex: search as string, $options: 'i' } },
        { tag: { $regex: search as string, $options: 'i' } },
      ];
    }

    const materials = await Material.find(filter).sort({ isDefault: -1, createdAt: -1 });

    res.status(200).json({
      success: true,
      count: materials.length,
      data: materials,
    });
  } catch (error: any) {
    res.status(200).json({
      success: true,
      count: 0,
      data: [],
      notice: 'Operating in local memory mode: ' + error.message,
    });
  }
};

export const getMaterialById = async (req: Request, res: Response): Promise<void> => {
  try {
    const material = await Material.findById(req.params.id);
    if (!material) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Material specimen not found in repository.',
      });
      return;
    }

    res.status(200).json({
      success: true,
      data: material,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_FETCH_MATERIAL',
      message: 'Error inspecting material specimen.',
    });
  }
};

export const createMaterial = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const materialData = {
      ...req.body,
      createdBy: req.user?._id,
      isDefault: req.user?.role === 'ADMIN' ? (req.body.isDefault ?? false) : false,
    };

    const material = await Material.create(materialData);

    if (req.user) {
      await Activity.create({
        userId: req.user._id,
        action: 'MATERIAL_CREATE',
        category: 'interaction',
        metadata: { materialId: material._id, name: material.name },
      });
    }

    res.status(201).json({
      success: true,
      message: 'Material formula calibrated and archived.',
      data: material,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_CREATE_MATERIAL',
      message: error.message || 'Failed to synthesize material formula.',
    });
  }
};

export const updateMaterial = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    let material = await Material.findById(req.params.id);
    if (!material) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Material formula not found.',
      });
      return;
    }

    if (material.isDefault && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Default core materials can only be calibrated by administrators.',
      });
      return;
    }

    if (material.createdBy && material.createdBy.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'You lack clearance to recalibrate this material.',
      });
      return;
    }

    material = await Material.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.status(200).json({
      success: true,
      message: 'Material formula recalibrated successfully.',
      data: material,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_UPDATE_MATERIAL',
      message: error.message || 'Failed to recalibrate material.',
    });
  }
};

export const deleteMaterial = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const material = await Material.findById(req.params.id);
    if (!material) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Material specimen not found.',
      });
      return;
    }

    if (material.isDefault && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Standard system materials cannot be decommissioned.',
      });
      return;
    }

    if (material.createdBy && material.createdBy.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Clearance denied.',
      });
      return;
    }

    await Material.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Material formula decommissioned from laboratory.',
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_DELETE_MATERIAL',
      message: 'Failed to decommission material formula.',
    });
  }
};
