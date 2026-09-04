import OpenAI, { toFile } from 'openai';

import type { ImageProvider } from './image-provider';
import type {
  ImageGenerationRequest,
  ImageGenerationResult,
} from '../types';

export class OpenAIImageProvider implements ImageProvider {
  private readonly client: OpenAI;
  private readonly model: string;

  constructor(options?: { apiKey?: string; model?: string }) {
    this.client = new OpenAI({ apiKey: options?.apiKey ?? process.env.OPENAI_API_KEY });
    this.model = options?.model ?? process.env.OPENAI_IMAGE_MODEL ?? 'gpt-image-2';
  }

  async edit(request: ImageGenerationRequest): Promise<ImageGenerationResult> {
    const started = Date.now();

    const image = await toFile(
      Buffer.from(request.sourceBytes),
      request.sourceFilename,
      { type: request.sourceMimeType },
    );

    const response = await this.client.images.edit({
      model: this.model,
      image,
      prompt: request.prompt,
      size: request.size ?? '1024x1024',
    });

    const first = response.data?.[0];
    if (!first?.b64_json) {
      throw new Error('OPENAI_IMAGE_EMPTY_RESULT');
    }

    return {
      bytes: Uint8Array.from(Buffer.from(first.b64_json, 'base64')),
      mimeType: 'image/png',
      provider: 'openai',
      model: this.model,
      latencyMs: Date.now() - started,
    };
  }
}
