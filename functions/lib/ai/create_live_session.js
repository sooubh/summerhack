"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createLiveSession = createLiveSession;
const env_1 = require("../config/env");
const model_guard_1 = require("../middleware/model_guard");
function createLiveSession(request) {
    (0, model_guard_1.assertAllowedModel)(request.model);
    (0, model_guard_1.assertAllowedThinkingLevel)(request.thinkingLevel);
    return {
        sessionId: `${request.ownerUid}_${Date.now()}`,
        model: env_1.ENV.allowedModel,
        thinkingLevel: request.thinkingLevel,
        state: 'creating',
    };
}
