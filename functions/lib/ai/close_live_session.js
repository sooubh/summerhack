"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.closeLiveSession = closeLiveSession;
function closeLiveSession(request) {
    return { sessionId: request.sessionId, state: 'ended' };
}
