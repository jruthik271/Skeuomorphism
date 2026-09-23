class CollectionModel {
  final String id;
  final String userId;
  final String name;
  final String description;
  final List<String> components;
  final List<String> materials;
  final bool isPublic;
  final DateTime? createdAt;

  const CollectionModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    this.components = const [],
    this.materials = const [],
    this.isPublic = false,
    this.createdAt,
  });

  factory CollectionModel.fromJson(Map<String, dynamic> json) {
    return CollectionModel(
      id: json['id'] ?? json['_id'] ?? '',
      userId: json['userId'] is Map ? (json['userId']['_id'] ?? '') : (json['userId'] ?? ''),
      name: json['name'] ?? 'Untitled Drawer',
      description: json['description'] ?? '',
      components: (json['components'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      materials: (json['materials'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      isPublic: json['isPublic'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'name': name,
    'description': description,
    'components': components,
    'materials': materials,
    'isPublic': isPublic,
  };
}
