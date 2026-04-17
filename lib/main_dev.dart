import 'app/bootstrap.dart';
import 'app/flavor_config.dart';

Future<void> main() async {
  await bootstrap(flavor: AppFlavor.dev);
}
