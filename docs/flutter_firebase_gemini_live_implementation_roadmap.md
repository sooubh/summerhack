# Flutter Firebase Gemini Live Implementation Roadmap

## 1) Purpose

This roadmap translates the architecture blueprint into an execution plan from MVP to production hardening.

The same hard constraints apply in every phase:
- AI model is only models/gemini-3.1-flash-live-preview.
- All AI interactions use Gemini Live API bidirectional streaming.
- Client uses package:google_generative_ai Live session interface.
- Server-side AI logic runs only in Firebase Cloud Functions using @google/genai.
- thinkingLevel is allowed with values: minimal, low, medium, high.
- thinkingBudget is not used.
- Backend services are Firebase only.

---

## 2) Delivery Strategy

## Method
- Vertical slices per feature, not horizontal layers first.
- Each phase has entry criteria, build scope, exit criteria, and measurable quality gates.
- Keep a releasable app state at the end of each phase.

## Environments
- dev: rapid iteration
- staging: release candidate validation
- prod: controlled rollout

## Branching and Release Rhythm
- Trunk-based with short-lived feature branches.
- Weekly internal release candidate to staging.
- Production deploy only after hardening gates pass.

---

## 3) Phase Plan

## Phase 0: Foundations and Guardrails

### Goals
- Establish project skeleton, modules, CI checks, and security baselines.

### Scope
- Create Flutter app structure with flavor entrypoints.
- Add Firebase project mapping for dev, staging, prod.
- Add Firestore and Storage rules scaffolding with default deny approach.
- Create Cloud Functions TypeScript project and base middleware.
- Add model guard policy to reject any model other than models/gemini-3.1-flash-live-preview.
- Define Firestore indexes and naming conventions.

### Exit Criteria
- App boots on iOS and Android with flavor selection.
- Cloud Functions deploy to dev environment.
- Static checks include model string compliance.

### Quality Gates
- Linting and formatting clean.
- App Check enabled in dev for integration testing.
- Rule simulator tests for basic allow and deny paths.

---

## Phase 1: Authentication and App Shell

### Goals
- Enable secure user onboarding and stable navigation shell.

### Scope
- Implement email/password and Google Sign-In with Firebase Auth.
- Persist user profile under users collection.
- Register FCM device tokens under users devices subcollection.
- Build initial route flow: splash, auth, home, profile.
- Set up Riverpod providers for auth and app session state.

### Exit Criteria
- User can sign up, sign in, sign out, and return with persisted auth session.
- Route guards block unauthenticated access to protected screens.

### Quality Gates
- Integration tests for auth flow and guarded routes.
- Firestore and Storage rules block cross-user access.

---

## Phase 2: Conversation Core and Realtime Data

### Goals
- Deliver conversation list and message timeline with Firestore listeners.

### Scope
- Implement conversations and messages collections.
- Add real-time list and detail listeners.
- Build home and conversation detail screens.
- Add metadata updates on message creation via Firestore trigger.
- Add pagination and basic offline behavior strategy.

### Exit Criteria
- User can create conversation and see messages update in real time.
- Home list reflects latest message preview and updated timestamp.

### Quality Gates
- Read and write latency metrics recorded in dev.
- Index coverage verified for all shipped queries.

---

## Phase 3: Gemini Live Session MVP (Text First)

### Goals
- Introduce first end-to-end live AI interaction path.

### Scope
- Build create_live_session callable and close_live_session callable.
- Enforce model to models/gemini-3.1-flash-live-preview in function middleware and request handlers.
- Store live session metadata in live_sessions collection.
- Implement client live session controller using package:google_generative_ai.
- Stream text events bidirectionally and display partial plus final responses.
- Persist transcript chunks and finalized messages.
- Support thinkingLevel selection and persistence.

### Exit Criteria
- User starts a live text session and receives low-latency partial responses.
- Session history is persisted and visible in conversation timeline.

### Quality Gates
- Contract tests for callable request and response payloads.
- Negative tests verify model override and rejection paths.
- End-to-end test validates thinkingLevel values and persistence.

---

## Phase 4: Live Voice and Multimodal Streaming

### Goals
- Expand live sessions to audio input and multimodal interactions.

### Scope
- Add microphone capture pipeline and stream chunking.
- Add optional ws_proxy mode via HTTP WebSocket function for mediated sessions.
- Relay model events and transcript timing markers.
- Track session metrics: audio in and out duration, token and event counts.
- Implement reconnect and resume logic for transient network drops.

### Exit Criteria
- User can conduct voice session with partial and final transcript updates.
- Session closes gracefully and persists final message set.

### Quality Gates
- Latency SLO defined and validated on representative devices.
- Network interruption test passes with recovery behavior.

---

## Phase 5: File Upload and Context Injection

### Goals
- Enable user media and document uploads tied to conversations.

### Scope
- Implement request_upload_slot callable and upload tracker documents.
- Add Storage uploads for image, document, and audio categories.
- Add storage finalize trigger for validation and metadata enrichment.
- Link uploads to conversation messages.
- Define moderation and file type policy boundaries if required.

### Exit Criteria
- User can upload supported files and see attachments in conversation.
- Upload status transitions complete: uploading to ready or failed.

### Quality Gates
- Storage rules tests for size, mime type, and path ownership.
- Retry flow tested for interrupted uploads.

---

## Phase 6: Notifications and Engagement

### Goals
- Provide reliable push notifications and in-app center.

### Scope
- Register and refresh FCM tokens.
- Add notification documents and send trigger pipeline.
- Support deep links to conversation and session screens.
- Add read and unread tracking.

### Exit Criteria
- Push notifications deliver for key events in staging.
- Notification tap routes to intended destination with hydrated state.

### Quality Gates
- Delivery and open metrics dashboard in place.
- Dead-letter and retry handling documented.

---

## Phase 7: Security and Abuse Hardening

### Goals
- Tighten security posture before production rollout.

### Scope
- Enforce App Check on callable and HTTP stream endpoints.
- Add per-user and per-device rate limiting.
- Add audit logs for session create, bind, close, and failures.
- Validate Firestore field-level write restrictions.
- Lock down service account IAM roles.

### Exit Criteria
- Pen-test style checklist passes internal review.
- Threat model and mitigation matrix completed.

### Quality Gates
- No critical or high findings unresolved.
- Rule simulator and automated security tests green.

---

## Phase 8: Performance, Reliability, and Observability

### Goals
- Ensure app is stable under load and observable in production.

### Scope
- Add end-to-end tracing IDs across client and functions.
- Build dashboards for latency, error rates, session drop rates, and push delivery.
- Add alerting thresholds and incident runbooks.
- Tune Firestore listener patterns and write batching.
- Finalize retention policy for events and transcripts.

### Exit Criteria
- Service level objectives are met in staging load tests.
- On-call runbook and escalation paths documented.

### Quality Gates
- Live session success rate and crash-free session thresholds met.
- Rollback procedure tested.

---

## Phase 9: Production Rollout

### Goals
- Release safely and iterate with controlled risk.

### Scope
- Internal dogfood rollout.
- Limited external rollout with feature flags.
- Gradual percentage ramp and cohort monitoring.
- Post-launch analysis and backlog reprioritization.

### Exit Criteria
- Stable metrics over agreed observation window.
- No unresolved blocker incidents.

### Quality Gates
- Rollout stop conditions pre-defined and automated where possible.
- Postmortem template and process active.

---

## 4) Cross-Phase Backlog Themes

- Accessibility and localization baseline from Phase 1 onward.
- Analytics taxonomy and event naming governance.
- Cost monitoring for Firestore reads, Storage egress, Functions execution.
- Data lifecycle management for large event streams.
- Regression automation growth per phase.

---

## 5) Team Topology and Ownership

- Mobile squad: Flutter presentation and application layers.
- Platform squad: Cloud Functions, Firebase rules, CI, observability.
- Shared ownership: live session contracts, schema evolution, release gates.

RACI recommendation:
- Product acceptance: Product owner + Engineering manager
- Security sign-off: Platform lead
- Performance sign-off: Mobile lead + Platform lead

---

## 6) Milestone Checklist

## MVP Milestone
- Phase 0 through Phase 3 completed.
- Users can authenticate and run text-based live sessions.
- Conversations and transcripts persist correctly.

## Beta Milestone
- Phase 4 through Phase 6 completed.
- Voice streaming, uploads, and notifications are production-like in staging.

## GA Milestone
- Phase 7 through Phase 9 completed.
- Security, reliability, and rollout standards are satisfied.

---

## 7) Risks and Mitigations

Risk: live stream instability on poor networks.
- Mitigation: reconnect strategy, buffered event replay, circuit breaker fallback to session restart.

Risk: schema drift between client and functions.
- Mitigation: contract versioning and compatibility checks in CI.

Risk: accidental model policy violations.
- Mitigation: central model guard middleware, CI policy scanner, runtime assertions.

Risk: high Firestore costs from verbose event logging.
- Mitigation: tiered retention, compact event payloads, analytics export strategy.

---

## 8) Definition of Done for Each Phase

- Functional acceptance criteria passed.
- Automated tests added and passing.
- Security and rule checks passing.
- Observability hooks added for new workflows.
- Documentation updated in docs directory.
- No unresolved high-severity defects.

---

## 9) Final Compliance Statement

All roadmap phases are constrained to one AI model and one provider path only:
- models/gemini-3.1-flash-live-preview
- Gemini Live API bidirectional streaming
- package:google_generative_ai on Flutter client
- @google/genai in Firebase Cloud Functions
