import type { GenerationMode } from '../types';

export const PROMPT_VERSION = {
  amazon: 'amazon-v1',
  studio: 'studio-v1',
  lifestyle: 'lifestyle-v1',
} as const satisfies Record<GenerationMode, string>;

export const PROMPTS: Record<GenerationMode, string> = {
  amazon: `Create a professional marketplace main product photograph from the provided product image.
Preserve the product identity as closely as possible: shape, proportions, construction, visible details, branding, materials and colors.
Improve photographic quality: sharpness, exposure, clarity and color balance.
Place the product on a pure white #FFFFFF background.
No props. No added text. No new product elements. No redesign. No intentional geometry changes.`,

  studio: `Create a professional studio product photograph from the provided product image.
Preserve the product identity as closely as possible: same shape, proportions, colors, materials, visible details and branding.
Place the product on a soft light-gray studio background with professional lighting, crisp focus and a realistic contact shadow.
Commercial product-photography style. Do not add or remove product parts.`,

  lifestyle: `Place the provided product into a premium minimal Scandinavian interior.
Preserve the product identity as closely as possible: same shape, proportions, colors, materials, visible details and branding.
Use natural daylight, refined neutral decor, realistic contact shadows and commercial advertising photography.
Keep the product fully visible and the clear focal point. Do not redesign the product.`,
};
