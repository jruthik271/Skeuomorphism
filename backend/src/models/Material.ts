import mongoose, { Document, Schema } from 'mongoose';

export interface IColorSwatch {
  name: string;
  hex: string;
  role: string;
  description: string;
}

export interface IMaterial extends Document {
  id?: string;
  name: string;
  description: string;
  category: 'metals' | 'organics' | 'displays' | 'papers' | 'glass';
  tag: string;
  reflectivity: string;
  textureType: string;
  keyLightAngle: string;
  roughness: number;
  metallic: number;
  swatches: IColorSwatch[];
  gradientCSS: string;
  flutterSnippet: string;
  cssSnippet: string;
  jsonSnippet?: string;
  createdBy?: mongoose.Types.ObjectId;
  isDefault: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const ColorSwatchSchema = new Schema<IColorSwatch>({
  name: { type: String, required: true },
  hex: { type: String, required: true },
  role: { type: String, required: true },
  description: { type: String, required: true },
});

const MaterialSchema = new Schema<IMaterial>(
  {
    name: { type: String, required: true, trim: true },
    description: { type: String, required: true },
    category: {
      type: String,
      enum: ['metals', 'organics', 'displays', 'papers', 'glass'],
      required: true,
    },
    tag: { type: String, default: 'PHYSICAL' },
    reflectivity: { type: String, default: '50% Specular' },
    textureType: { type: String, default: 'Machined Surface' },
    keyLightAngle: { type: String, default: '315° Key Light' },
    roughness: { type: Number, default: 0.35 },
    metallic: { type: Number, default: 0.8 },
    swatches: [ColorSwatchSchema],
    gradientCSS: { type: String, required: true },
    flutterSnippet: { type: String, required: true },
    cssSnippet: { type: String, required: true },
    jsonSnippet: { type: String },
    createdBy: { type: Schema.Types.ObjectId, ref: 'User' },
    isDefault: { type: Boolean, default: false },
  },
  { timestamps: true }
);

export const Material = mongoose.model<IMaterial>('Material', MaterialSchema);
