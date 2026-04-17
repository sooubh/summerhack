enum AppFlavor { dev, staging, prod }

class FlavorConfig {
  const FlavorConfig({required this.flavor, required this.name});

  final AppFlavor flavor;
  final String name;
}
