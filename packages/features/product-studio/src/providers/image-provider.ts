import type {
  ImageGenerationRequest,
  ImageGenerationResult,
} from '../types';

export interface ImageProvider {
  edit(request: ImageGenerationRequest): Promise<ImageGenerationResult>;
}
