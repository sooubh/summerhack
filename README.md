# summerhack

Flutter + Firebase + Gemini Live starter for mobile and web.

## Current app status

- Flavor-aware entrypoints (`dev`, `staging`, `prod`)
- Adaptive shell for mobile + web (bottom navigation + navigation rail)
- Auth gate scaffold with sign-in and sign-out flow
- Home, Conversations, Live AI, Uploads, Notifications, and Profile screens
- Live AI text session state machine scaffold using the required model constant
- Riverpod-based shared app state

## Documentation

- [Flutter Firebase Gemini Live Blueprint](docs/flutter_firebase_gemini_live_blueprint.md)
- [Implementation Roadmap](docs/flutter_firebase_gemini_live_implementation_roadmap.md)

## Run locally

1. Install dependencies:
	- `flutter pub get`
2. Run mobile (dev flavor):
	- `flutter run -t lib/main_dev.dart`
3. Run web (dev flavor):
	- `flutter run -d chrome -t lib/main_dev.dart`

You can switch flavors with `main_staging.dart` and `main_prod.dart`.