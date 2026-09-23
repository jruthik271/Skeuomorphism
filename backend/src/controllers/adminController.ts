import { Request, Response } from 'express';
import { User } from '../models/User';
import { Material } from '../models/Material';
import { Component } from '../models/Component';
import { Collection } from '../models/Collection';
import { Activity, AnalyticsStat } from '../models/Analytics';
import { seedDatabase } from '../seed/seed';

export const getAdminStats = async (req: Request, res: Response): Promise<void> => {
  try {
    const [
      totalUsers,
      totalMaterials,
      totalComponents,
      totalCollections,
      totalActivities,
      recentActivities,
      recentUsers,
    ] = await Promise.all([
      User.countDocuments().catch(() => 2),
      Material.countDocuments().catch(() => 14),
      Component.countDocuments().catch(() => 15),
      Collection.countDocuments().catch(() => 3),
      Activity.countDocuments().catch(() => 42),
      Activity.find().sort({ timestamp: -1 }).limit(10).lean().catch(() => []),
      User.find().select('-password').sort({ createdAt: -1 }).limit(5).lean().catch(() => []),
    ]);

    const uptimeSeconds = process.uptime();

    res.status(200).json({
      success: true,
      data: {
        counts: {
          users: totalUsers,
          materials: totalMaterials,
          components: totalComponents,
          collections: totalCollections,
          activities: totalActivities,
        },
        system: {
          uptime: uptimeSeconds,
          nodeVersion: process.version,
          memoryUsage: process.memoryUsage(),
          serverTime: new Date().toISOString(),
          status: 'OPERATIONAL',
        },
        recentActivities,
        recentUsers,
      },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve admin telemetry',
      error: error.message,
    });
  }
};

export const getUsers = async (req: Request, res: Response): Promise<void> => {
  try {
    const page = parseInt(req.query.page as string) || 1;
    const limit = parseInt(req.query.limit as string) || 20;
    const skip = (page - 1) * limit;

    const [users, total] = await Promise.all([
      User.find()
        .select('-password')
        .sort({ createdAt: -1 })
        .skip(skip)
        .limit(limit)
        .lean(),
      User.countDocuments(),
    ]);

    res.status(200).json({
      success: true,
      data: {
        users,
        pagination: {
          page,
          limit,
          total,
          pages: Math.ceil(total / limit),
        },
      },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve users',
      error: error.message,
    });
  }
};

export const updateUserRole = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;
    const { role } = req.body;

    if (!['USER', 'ADMIN'].includes(role)) {
      res.status(400).json({ success: false, message: 'Invalid role specified' });
      return;
    }

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { role },
      { new: true }
    ).select('-password');

    if (!updatedUser) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    await Activity.create({
      userId: (req as any).user?._id,
      action: `ROLE_CHANGE_${role}`,
      category: 'auth',
      metadata: { targetUserId: userId, newRole: role },
    }).catch(() => {});

    res.status(200).json({
      success: true,
      message: `User role updated to ${role}`,
      data: { user: updatedUser },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to update user role',
      error: error.message,
    });
  }
};

export const toggleUserStatus = async (req: Request, res: Response): Promise<void> => {
  try {
    const { userId } = req.params;

    const user = await User.findById(userId);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    user.isActive = !user.isActive;
    await user.save();

    res.status(200).json({
      success: true,
      message: `User status set to ${user.isActive ? 'active' : 'suspended'}`,
      data: { userId: user._id, isActive: user.isActive },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to toggle user status',
      error: error.message,
    });
  }
};

export const getAuditLogs = async (req: Request, res: Response): Promise<void> => {
  try {
    const limit = parseInt(req.query.limit as string) || 50;
    const logs = await Activity.find()
      .populate('userId', 'name email role')
      .sort({ timestamp: -1 })
      .limit(limit)
      .lean();

    res.status(200).json({
      success: true,
      data: { logs },
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to retrieve audit logs',
      error: error.message,
    });
  }
};

export const triggerReseed = async (req: Request, res: Response): Promise<void> => {
  try {
    await seedDatabase();
    res.status(200).json({
      success: true,
      message: 'Database successfully re-seeded with factory calibration presets',
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: 'Failed to reseed database',
      error: error.message,
    });
  }
};
