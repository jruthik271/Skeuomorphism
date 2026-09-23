import { Request, Response } from 'express';
import { Component } from '../models/Component';
import { AuthRequest } from '../middleware/auth';
import { Activity } from '../models/Activity';

export const getAllComponents = async (req: Request, res: Response): Promise<void> => {
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
        { technique: { $regex: search as string, $options: 'i' } },
      ];
    }

    const components = await Component.find(filter).sort({ isDefault: -1, createdAt: -1 });

    res.status(200).json({
      success: true,
      count: components.length,
      data: components,
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

export const getComponentById = async (req: Request, res: Response): Promise<void> => {
  try {
    const component = await Component.findById(req.params.id);
    if (!component) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Component not found on workbench.',
      });
      return;
    }

    // Increment view count asynchronously
    Component.findByIdAndUpdate(req.params.id, { $inc: { viewsCount: 1 } }).exec();

    res.status(200).json({
      success: true,
      data: component,
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_FETCH_COMPONENT',
      message: 'Failed to inspect component blueprint.',
    });
  }
};

export const createComponent = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const componentData = {
      ...req.body,
      createdBy: req.user?._id,
      isDefault: req.user?.role === 'ADMIN' ? (req.body.isDefault ?? false) : false,
    };

    const component = await Component.create(componentData);

    if (req.user) {
      await Activity.create({
        userId: req.user._id,
        action: 'COMPONENT_CREATE',
        category: 'interaction',
        metadata: { componentId: component._id, name: component.name },
      });
    }

    res.status(201).json({
      success: true,
      message: 'Physical component assembled and registered.',
      data: component,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_CREATE_COMPONENT',
      message: error.message || 'Component assembly blueprint invalid.',
    });
  }
};

export const updateComponent = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    let component = await Component.findById(req.params.id);
    if (!component) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Component blueprint not found.',
      });
      return;
    }

    if (component.isDefault && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'System stock components cannot be modified without administrator clearance.',
      });
      return;
    }

    if (component.createdBy && component.createdBy.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Clearance denied to modify this component.',
      });
      return;
    }

    component = await Component.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });

    res.status(200).json({
      success: true,
      message: 'Component specifications recalibrated.',
      data: component,
    });
  } catch (error: any) {
    res.status(400).json({
      success: false,
      error: 'ERR_UPDATE_COMPONENT',
      message: error.message || 'Failed to update component.',
    });
  }
};

export const deleteComponent = async (req: AuthRequest, res: Response): Promise<void> => {
  try {
    const component = await Component.findById(req.params.id);
    if (!component) {
      res.status(404).json({
        success: false,
        error: 'ERR_NOT_FOUND',
        message: 'Component not found.',
      });
      return;
    }

    if (component.isDefault && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Standard system parts cannot be decommissioned.',
      });
      return;
    }

    if (component.createdBy && component.createdBy.toString() !== req.user?._id.toString() && req.user?.role !== 'ADMIN') {
      res.status(403).json({
        success: false,
        error: 'ERR_FORBIDDEN',
        message: 'Clearance denied.',
      });
      return;
    }

    await Component.findByIdAndDelete(req.params.id);

    res.status(200).json({
      success: true,
      message: 'Component disassembled and removed.',
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      error: 'ERR_DELETE_COMPONENT',
      message: 'Failed to disassemble component.',
    });
  }
};

export const recordInteraction = async (req: Request, res: Response): Promise<void> => {
  try {
    await Component.findByIdAndUpdate(req.params.id, { $inc: { interactionsCount: 1 } });
    res.status(200).json({ success: true, message: 'Kinetic interaction logged.' });
  } catch (error: any) {
    res.status(500).json({ success: false, error: 'ERR_LOG_INTERACTION' });
  }
};
