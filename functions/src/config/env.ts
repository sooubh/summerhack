export const ENV = {
  allowedModel: 'models/gemini-3.1-flash-live-preview',
  allowedThinkingLevels: ['minimal', 'low', 'medium', 'high'] as const,
};

export type ThinkingLevel = (typeof ENV.allowedThinkingLevels)[number];
