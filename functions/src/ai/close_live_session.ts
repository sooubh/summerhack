export type CloseLiveSessionRequest = { sessionId: string };
export type CloseLiveSessionResponse = { sessionId: string; state: 'ended' };

export function closeLiveSession(request: CloseLiveSessionRequest): CloseLiveSessionResponse {
  return { sessionId: request.sessionId, state: 'ended' };
}
