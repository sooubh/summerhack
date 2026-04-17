import { ENV, type ThinkingLevel } from '../config/env';

export function assertAllowedModel(model: string): void {
  if (model !== ENV.allowedModel) {
    throw new Error(`Model not allowed: ${model}`);
  }
}

export function assertAllowedThinkingLevel(value: string): asserts value is ThinkingLevel {
  if (!ENV.allowedThinkingLevels.includes(value as ThinkingLevel)) {
    throw new Error(`Invalid thinkingLevel: ${value}`);
  }
}
