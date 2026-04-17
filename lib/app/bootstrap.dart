import 'package:flutter/material.dart';

import 'app.dart';

Future<void> bootstrap({required String title}) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SummerhackApp(title: title));
}
