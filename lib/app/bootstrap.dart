import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'flavor_config.dart';

Future<void> bootstrap({required AppFlavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final flavorConfig = FlavorConfig.fromFlavor(flavor);
  runApp(
    ProviderScope(
      child: SummerhackApp(flavorConfig: flavorConfig),
    ),
  );
}
