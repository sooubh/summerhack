import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'flavor_config.dart';
import '../firebase_options.dart';

Future<void> bootstrap({required AppFlavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final flavorConfig = FlavorConfig.fromFlavor(flavor);
  runApp(
    ProviderScope(
      child: SummerhackApp(flavorConfig: flavorConfig),
    ),
  );
}
