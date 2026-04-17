"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.assertAllowedModel = assertAllowedModel;
exports.assertAllowedThinkingLevel = assertAllowedThinkingLevel;
const env_1 = require("../config/env");
function assertAllowedModel(model) {
    if (model !== env_1.ENV.allowedModel) {
        throw new Error(`Model not allowed: ${model}`);
    }
}
function assertAllowedThinkingLevel(value) {
    if (!env_1.ENV.allowedThinkingLevels.includes(value)) {
        throw new Error(`Invalid thinkingLevel: ${value}`);
    }
}
