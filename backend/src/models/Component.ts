import mongoose, { Document, Schema } from 'mongoose';

export interface IComponent extends Document {
  name: string;
  category: 'controls' | 'displays' | 'containers' | 'artifacts';
  description: string;
  technique: string;
  configuration: Record<string, any>;
  material: string;
  animationCurve: string;
  flutterCode: string;
  createdBy?: mongoose.Types.ObjectId;
  isDefault: boolean;
  viewsCount: number;
  interactionsCount: number;
  createdAt: Date;
  updatedAt: Date;
}

const ComponentSchema = new Schema<IComponent>(
  {
    name: { type: String, required: true, trim: true },
    category: {
      type: String,
      enum: ['controls', 'displays', 'containers', 'artifacts'],
      required: true,
    },
    description: { type: String, required: true },
    technique: { type: String, default: 'Mechanical Modeling' },
    configuration: { type: Schema.Types.Mixed, default: {} },
    material: { type: String, default: 'aluminum' },
    animationCurve: { type: String, default: 'easeOutBack' },
    flutterCode: { type: String, required: true },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User' },
    isDefault: { type: Boolean, default: false },
    viewsCount: { type: Number, default: 0 },
    interactionsCount: { type: Number, default: 0 },
  },
  { timestamps: true }
);

export const Component = mongoose.model<IComponent>('Component', ComponentSchema);
