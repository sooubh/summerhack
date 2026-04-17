class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.defaultThinkingLevel,
    this.photoUrl,
    this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final String defaultThinkingLevel;
  final String? photoUrl;
  final DateTime? createdAt;

  AppUser copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? defaultThinkingLevel,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      defaultThinkingLevel: defaultThinkingLevel ?? this.defaultThinkingLevel,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'defaultThinkingLevel': defaultThinkingLevel,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Unknown',
      defaultThinkingLevel: map['defaultThinkingLevel'] as String? ?? 'low',
      photoUrl: map['photoUrl'] as String?,
      createdAt: map['createdAt'] is String
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
    );
  }
}
