class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.defaultThinkingLevel,
  });

  final String uid;
  final String email;
  final String displayName;
  final String defaultThinkingLevel;
}
