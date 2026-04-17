enum AppFlavor { dev, staging, prod }

class FlavorConfig {
  const FlavorConfig({
    required this.flavor,
    required this.name,
    required this.bundleSuffix,
    required this.baseApiPath,
  });

  final AppFlavor flavor;
  final String name;
  final String bundleSuffix;
  final String baseApiPath;

  static FlavorConfig fromFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return const FlavorConfig(
          flavor: AppFlavor.dev,
          name: 'Summerhack Dev',
          bundleSuffix: 'dev',
          baseApiPath: 'dev',
        );
      case AppFlavor.staging:
        return const FlavorConfig(
          flavor: AppFlavor.staging,
          name: 'Summerhack Staging',
          bundleSuffix: 'staging',
          baseApiPath: 'staging',
        );
      case AppFlavor.prod:
        return const FlavorConfig(
          flavor: AppFlavor.prod,
          name: 'Summerhack',
          bundleSuffix: 'prod',
          baseApiPath: 'prod',
        );
    }
  }
}
