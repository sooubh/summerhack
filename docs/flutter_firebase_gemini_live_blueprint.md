# Cross-Platform Mobile App Technical Blueprint

## 1) Scope and Non-Negotiable Constraints

### Product Scope
- Build a cross-platform mobile app using Flutter (Dart) for iOS and Android.
- Keep business logic platform-agnostic so architecture is web-convertible with minimal change.

### AI Layer (Strict)
- The only allowed model is: models/gemini-3.1-flash-live-preview
- All AI capabilities (voice, text, multimodal live interactions) must use Gemini Live API with bidirectional streaming.
- Flutter client uses Google GenAI Dart SDK via package:google_generative_ai and its Live session interface.
- Server-side secure orchestration is only through Firebase Cloud Functions (Node.js) using @google/genai and Gemini Live API.
- No fallback models, no alternate providers.
- thinkingLevel must be used with values: minimal, low, medium, high.
- thinkingBudget is not used anywhere.

### Backend and Infrastructure (Firebase Only)
- Firebase Auth: email/password + Google Sign-In
- Firestore: primary NoSQL database + real-time listeners
- Firebase Storage: file/media uploads
- Firebase Cloud Functions: all server-side logic and AI orchestration
- Firebase App Check: request hardening
- Firebase Cloud Messaging (FCM): push notifications

---

## 2) Architecture Style

### Architectural Pattern
- Modular Clean Architecture with feature-first folders.
- Three layers per feature:
  - Presentation
  - Application
  - Data + Domain interfaces/entities
- Platform-specific integrations are isolated behind adapters/ports.

### Why This Works for Real-Time AI
- Real-time streams are handled as event pipelines in Application layer.
- Persistence and side-effects remain in Data layer.
- UI can evolve independently of session orchestration.
- Core logic remains reusable for web target.

---

## 3) Recommended State Management

## Pick: Riverpod

### Justification
- Excellent for async and stream-heavy state (Firestore listeners + Gemini Live events).
- Fine-grained rebuild control for low-latency live transcript and voice state updates.
- Provider scoping keeps feature modules decoupled and testable.
- Easier composition of state machines for live session lifecycle.

### State Strategy
- Global providers:
  - authStateProvider
  - appFlavorProvider
  - appCheckStateProvider
  - connectivityProvider
- Feature providers:
  - conversationListProvider
  - messageStreamProvider
  - uploadQueueProvider
  - notificationCenterProvider
- Live providers:
  - liveSessionControllerProvider
  - liveTranscriptProvider
  - liveAudioStatsProvider
  - liveThinkingLevelProvider

---

## 4) Full Project Structure

summerhack/
- README.md
- pubspec.yaml
- analysis_options.yaml
- firebase.json
- .firebaserc
- firestore.rules
- firestore.indexes.json
- storage.rules
- assets/
  - icons/
  - images/
  - audio/
- lib/
  - main_dev.dart
  - main_staging.dart
  - main_prod.dart
  - app/
    - app.dart
    - bootstrap.dart
    - flavor_config.dart
    - router/
      - app_router.dart
      - route_names.dart
      - route_guards.dart
      - transitions.dart
    - theme/
      - app_theme.dart
      - color_tokens.dart
      - typography.dart
    - di/
      - providers.dart
  - core/
    - constants/
      - ai_constants.dart
      - firestore_paths.dart
      - storage_paths.dart
      - env_keys.dart
    - errors/
    - logging/
    - network/
    - utils/
    - ports/
      - audio_input_port.dart
      - permission_port.dart
      - notifications_port.dart
  - shared/
    - models/
    - widgets/
    - services/
  - features/
    - auth/
      - domain/
      - application/
      - data/
      - presentation/
    - home/
      - domain/
      - application/
      - data/
      - presentation/
    - live_ai/
      - domain/
        - entities/
        - repositories/
      - application/
        - controllers/
        - use_cases/
      - data/
        - datasources/
        - repositories/
        - mappers/
      - presentation/
        - screens/
        - widgets/
    - profile/
      - domain/
      - application/
      - data/
      - presentation/
    - file_upload/
      - domain/
      - application/
      - data/
      - presentation/
    - notifications/
      - domain/
      - application/
      - data/
      - presentation/
- test/
  - unit/
  - widget/
  - feature/
- integration_test/
- functions/
  - package.json
  - tsconfig.json
  - eslint.config.js
  - src/
    - index.ts
    - config/
      - env.ts
      - firebase.ts
      - app_check.ts
    - middleware/
      - auth_guard.ts
      - app_check_guard.ts
      - model_guard.ts
    - ai/
      - create_live_session.ts
      - live_ws_proxy.ts
      - close_live_session.ts
      - finalize_live_session.ts
    - auth/
      - on_user_created.ts
      - on_user_deleted.ts
    - conversations/
      - on_message_created.ts
      - on_conversation_updated.ts
    - uploads/
      - on_storage_finalize.ts
    - notifications/
      - register_device.ts
      - send_push.ts
- docs/
  - flutter_firebase_gemini_live_blueprint.md

---

## 5) Feature Module Blueprint

## Auth
- Sign-up/sign-in via email/password and Google.
- Session management and sign-out.
- Creates/updates user profile and device records.
- Enforces App Check readiness before sensitive operations.

## Home
- Conversation list, recent activity, and quick launch actions.
- Real-time summaries via Firestore listeners.

## Live AI Voice/Chat
- Handles text + audio bidirectional live streams.
- Owns session state machine and reconnect behavior.
- Applies thinkingLevel per session.
- Persists transcript chunks and final outputs.

## Profile
- User profile and preferences.
- Default thinkingLevel preference.
- Notification opt-in controls.

## File Upload
- Upload images/documents/audio to Storage.
- Links uploads to conversation/message metadata.

## Notifications
- FCM token registration and update.
- In-app notification center synced from Firestore.
- Deep links into target screens.

---

## 6) Firestore Data Model

### users/{uid}
- email: string
- displayName: string
- photoUrl: string|null
- createdAt: timestamp
- updatedAt: timestamp
- defaultThinkingLevel: string (minimal|low|medium|high)
- notificationOptIn: boolean

### users/{uid}/devices/{deviceId}
- fcmToken: string
- platform: string (ios|android)
- appVersion: string
- locale: string
- appCheckValidatedAt: timestamp
- lastSeenAt: timestamp

### conversations/{conversationId}
- ownerUid: string
- title: string
- mode: string (voice|chat|multimodal)
- activeSessionId: string|null
- lastMessagePreview: string
- createdAt: timestamp
- updatedAt: timestamp
- archived: boolean

### conversations/{conversationId}/messages/{messageId}
- role: string (user|assistant|system)
- modality: string (text|audio|image|document)
- text: string|null
- storagePath: string|null
- mimeType: string|null
- durationMs: number|null
- sequenceNo: number
- liveSessionId: string|null
- model: string (must equal models/gemini-3.1-flash-live-preview)
- thinkingLevel: string (minimal|low|medium|high)
- status: string (partial|final|error)
- createdAt: timestamp

### live_sessions/{sessionId}
- ownerUid: string
- conversationId: string
- model: string (must equal models/gemini-3.1-flash-live-preview)
- thinkingLevel: string (minimal|low|medium|high)
- transportMode: string (sdk_direct|ws_proxy)
- state: string (creating|active|paused|closing|ended|failed)
- serverSessionRef: string|null
- ephemeralTokenId: string|null
- appCheckHash: string
- createdAt: timestamp
- startedAt: timestamp|null
- endedAt: timestamp|null
- expiresAt: timestamp
- lastClientSeq: number
- audioInMs: number
- audioOutMs: number
- textInChars: number
- textOutChars: number
- errorCode: string|null
- errorMessage: string|null

### live_sessions/{sessionId}/events/{eventId}
- seqNo: number
- direction: string (client_to_model|model_to_client|server)
- eventType: string (audio_chunk|text_chunk|control|transcript_final|error)
- payloadRef: string|null
- isFinal: boolean
- latencyMs: number|null
- createdAt: timestamp

### live_sessions/{sessionId}/transcripts/{chunkId}
- speaker: string (user|assistant)
- text: string
- startMs: number
- endMs: number
- finalized: boolean
- createdAt: timestamp

### uploads/{uploadId}
- ownerUid: string
- conversationId: string|null
- storagePath: string
- fileName: string
- mimeType: string
- sizeBytes: number
- checksumSha256: string
- status: string (uploading|processed|failed|ready)
- createdAt: timestamp
- processedAt: timestamp|null

### notifications/{uid}/items/{notificationId}
- type: string
- title: string
- body: string
- data: map
- sentAt: timestamp
- readAt: timestamp|null

### ephemeral_live_tokens/{tokenId}
- ownerUid: string
- liveSessionId: string
- model: string (must equal models/gemini-3.1-flash-live-preview)
- thinkingLevel: string (minimal|low|medium|high)
- tokenHash: string
- appCheckHash: string
- issuedAt: timestamp
- expiresAt: timestamp
- status: string (issued|consumed|expired|revoked)

### Recommended Indexes
- conversations: ownerUid + updatedAt desc
- messages: liveSessionId + sequenceNo asc
- live_sessions: ownerUid + state + createdAt desc
- uploads: ownerUid + createdAt desc

---

## 7) Firebase Storage Structure

- users/{uid}/avatars/{fileName}
- users/{uid}/uploads/images/{yyyy}/{mm}/{uploadId}_{fileName}
- users/{uid}/uploads/documents/{yyyy}/{mm}/{uploadId}_{fileName}
- users/{uid}/uploads/audio/{yyyy}/{mm}/{uploadId}_{fileName}
- conversations/{conversationId}/attachments/{messageId}_{fileName}
- live_sessions/{sessionId}/artifacts/{artifactType}_{timestamp}

### Object Metadata Standard
- ownerUid
- conversationId (optional)
- sourceFeature (profile|upload|live_session)
- mimeType
- checksumSha256
- createdAt

---

## 8) Cloud Functions Responsibility Map

## Callable Functions
- create_live_session
  - Validates Auth + App Check.
  - Validates thinkingLevel.
  - Enforces model to models/gemini-3.1-flash-live-preview.
  - Creates live session doc + ephemeral token record.
  - Uses @google/genai Live API for session bootstrap.
- close_live_session
  - Graceful termination and finalization trigger.
- register_device
  - Registers/refreshes FCM token metadata.
- request_upload_slot
  - Pre-validates upload intent and metadata.

## HTTP Functions
- live_ws_proxy
  - Bidirectional WebSocket proxy to Gemini Live API.
  - Auth + App Check required.
  - Frame relay both directions and event logging.
  - Only model allowed: models/gemini-3.1-flash-live-preview.
- live_health
  - Internal health diagnostics endpoint.

## Event-Triggered Functions
- on_message_created (Firestore trigger)
  - Updates conversation preview/timestamps.
- on_live_session_write (Firestore trigger)
  - Handles lifecycle transitions and transcript consolidation.
- on_storage_finalize (Storage trigger)
  - Validates file metadata and updates upload state.
- on_notification_item_created (Firestore trigger)
  - Sends FCM payload and persists delivery status.
- on_user_deleted (Auth trigger)
  - Cleans user-related data and storage artifacts.

---

## 9) Navigation and Routing Flow

### Core Screens
- Splash
- Sign In
- Sign Up
- Home
- Conversation Detail
- Live Lobby
- Live Session
- Upload Center
- Profile
- Notification Center
- Settings

### Named Routes
- /splash
- /auth/sign_in
- /auth/sign_up
- /home
- /home/conversation/:conversationId
- /home/live_lobby
- /home/live_session/:sessionId
- /home/upload
- /home/profile
- /home/notification_center
- /settings

### Transition Rules
- Splash to Auth/Home: fade
- Home to detail pages: horizontal slide
- Live Lobby to Live Session: fast fade + subtle scale
- Notification deep links: direct route with data hydration

---

## 10) Gemini Live API Integration Pattern

### Session Opening Sequence
1. Client selects conversation and thinkingLevel.
2. Client calls create_live_session callable.
3. Function validates user and App Check.
4. Function sets model explicitly to models/gemini-3.1-flash-live-preview.
5. Function returns session bootstrap data + short-lived token info.
6. Client opens Live session using package:google_generative_ai.

### Streaming Modes
- sdk_direct mode
  - Client connects directly with ephemeral session credentials.
  - Lowest latency path.
- ws_proxy mode
  - Client connects to function-hosted WebSocket proxy.
  - Server mediates stream and enforces policy centrally.

### Bidirectional Data Stream
- Client to model:
  - Audio chunks
  - Text chunks
  - Control events
- Model to client:
  - Partial transcript and response chunks
  - Finalized transcript/output events
  - State and error events

### thinkingLevel Handling
- Stored in live_sessions.thinkingLevel.
- Applied during Live session config.
- Allowed values only: minimal, low, medium, high.
- thinkingBudget not present in schema or APIs.

### Session History and Token Lifecycle
- Operational stream records stored in live_sessions/events.
- Transcript chunks stored in live_sessions/transcripts.
- Final canonical assistant/user messages stored in conversations/messages.
- Ephemeral token record state transitions:
  - issued -> consumed -> expired/revoked

---

## 11) Data Flow by Feature

### Auth Flow
1. User signs in/up.
2. Auth provider updates app state.
3. Device token registration occurs.
4. User profile listeners initialize.

### Live Voice/Chat Flow
1. User opens Live Lobby and starts session.
2. Session bootstrap function returns configuration.
3. Live stream opens.
4. Partial events render in UI in real time.
5. Final messages persist to conversations/messages.
6. Session closes and analytics/finalization run.

### File Upload Flow
1. User selects file and requests upload slot.
2. Client uploads to Storage path.
3. Storage trigger validates and marks status.
4. Attachment linked into conversation metadata.

### Notification Flow
1. Event writes notification document.
2. Trigger sends FCM.
3. Tap opens deep-linked screen.

---

## 12) Security Model Outline

### Firestore Rules Principles
- Default deny-all.
- Read/write only for authenticated owner (or explicit participants model if introduced later).
- Prevent client writes to server-only fields.
- Validate enum fields (thinkingLevel, state, role, modality).
- Enforce model field equality to models/gemini-3.1-flash-live-preview where relevant.
- Deny any direct access to ephemeral_live_tokens contents except server.

### Storage Rules Principles
- Restrict object access to owner-scoped paths.
- Enforce content type allowlist.
- Enforce file size limits.
- Require metadata ownerUid and sourceFeature.
- Prevent cross-user overwrite and read.

### Function Security
- Require Firebase Auth for all user actions.
- Require App Check for callable and HTTP stream endpoints.
- Add per-user and per-device rate limits.
- Log all AI session create/open/close events with request correlation IDs.

---

## 13) Environment and Configuration Strategy

### Flavors
- dev
- staging
- prod

### Flutter Entrypoints
- main_dev.dart
- main_staging.dart
- main_prod.dart

### Firebase Projects
- One Firebase project per flavor.
- Separate Auth, Firestore, Storage, Functions, and FCM resources by environment.

### Secret Management
- Gemini API credentials stored only in Cloud Functions secret manager.
- No AI key on client.
- Environment-specific secrets and IAM policies.

### Config Boundaries
- Client holds non-secret runtime flags only:
  - flavor
  - region
  - feature gates
- Server holds all privileged credentials.

---

## 14) Naming and Governance Standards

### Naming
- Dart files: snake_case
- Firestore collections/documents: lower_snake_case IDs where possible
- Provider names: suffix with _provider
- Controller names: suffix with _controller

### Governance Rules
- Every AI request path must include explicit model assertion.
- Every persisted AI output includes model and thinkingLevel metadata.
- CI checks should fail if model string differs from models/gemini-3.1-flash-live-preview.

---

## 15) Operational Readiness Checklist

- Auth and App Check enforced for all sensitive calls.
- Firestore indexes provisioned for real-time list/query paths.
- Retry/reconnect policy defined for live streaming disruptions.
- Structured logging and trace IDs across client and functions.
- Push notification delivery receipts recorded.
- Data retention policy for events/transcripts/artifacts documented.

---

## 16) Summary

This blueprint defines a Flutter-first, Firebase-only architecture with strict AI compliance: all AI interactions exclusively use models/gemini-3.1-flash-live-preview through Gemini Live API, with secure orchestration via Cloud Functions and real-time data coordination through Firestore listeners. The design is modular, scalable, and web-convertible by isolating platform concerns from business logic.
