export type GenerationMode = 'amazon' | 'studio' | 'lifestyle';

export type GenerationStatus =
  | 'queued'
  | 'processing'
  | 'completed'
  | 'failed'
  | 'cancelled';

export interface ImageGenerationRequest {
  sourceBytes: Uint8Array;
  sourceFilename: string;
  sourceMimeType: string;
  mode: GenerationMode;
  prompt: string;
  size?: '1024x1024' | '1024x1536' | '1536x1024';
}

export interface ImageGenerationResult {
  bytes: Uint8Array;
  mimeType: 'image/png' | 'image/jpeg' | 'image/webp';
  provider: string;
  model: string;
  providerRequestId?: string;
  latencyMs: number;
  estimatedCostUsd?: number;
}
