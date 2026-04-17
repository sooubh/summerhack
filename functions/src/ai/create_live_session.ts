import { ENV } from '../config/env';
import { assertAllowedModel, assertAllowedThinkingLevel } from '../middleware/model_guard';

export type CreateLiveSessionRequest = {
  ownerUid: string;
  conversationId: string;
  model: string;
  thinkingLevel: string;
};

export type CreateLiveSessionResponse = {
  sessionId: string;
  model: string;
  thinkingLevel: string;
  state: 'creating';
};

export function createLiveSession(request: CreateLiveSessionRequest): CreateLiveSessionResponse {
  assertAllowedModel(request.model);
  assertAllowedThinkingLevel(request.thinkingLevel);

  return {
    sessionId: `${request.ownerUid}_${Date.now()}`,
    model: ENV.allowedModel,
    thinkingLevel: request.thinkingLevel,
    state: 'creating',
  };
}
