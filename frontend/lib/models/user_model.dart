class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final int interactions;
  final int savedMaterials;
  final int savedComponents;
  final int collectionsCount;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.interactions = 0,
    this.savedMaterials = 0,
    this.savedComponents = 0,
    this.collectionsCount = 0,
    this.createdAt,
  });

  bool get isAdmin => role.toUpperCase() == 'ADMIN';

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final stats = json['stats'] as Map<String, dynamic>? ?? {};
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? 'Unknown Operator',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      avatar: json['avatar'],
      interactions: (stats['interactions'] as num?)?.toInt() ?? (json['interactions'] as num?)?.toInt() ?? 0,
      savedMaterials: (stats['savedMaterials'] as num?)?.toInt() ?? 0,
      savedComponents: (stats['savedComponents'] as num?)?.toInt() ?? 0,
      collectionsCount: (stats['collectionsCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role,
    'avatar': avatar,
    'stats': {
      'interactions': interactions,
      'savedMaterials': savedMaterials,
      'savedComponents': savedComponents,
      'collectionsCount': collectionsCount,
    },
  };
}
