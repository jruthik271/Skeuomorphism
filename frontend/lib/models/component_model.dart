class ComponentModel {
  final String id;
  final String name;
  final String category;
  final String description;
  final String technique;
  final Map<String, dynamic> configuration;
  final String material;
  final String animationCurve;
  final String flutterCode;
  final int viewsCount;
  final int interactionsCount;

  const ComponentModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.technique,
    required this.configuration,
    required this.material,
    required this.animationCurve,
    required this.flutterCode,
    this.viewsCount = 0,
    this.interactionsCount = 0,
  });

  factory ComponentModel.fromJson(Map<String, dynamic> json) {
    return ComponentModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? 'controls',
      description: json['description'] ?? '',
      technique: json['technique'] ?? 'Physical Modeling',
      configuration: (json['configuration'] as Map<String, dynamic>?) ?? {},
      material: json['material'] ?? 'aluminum',
      animationCurve: json['animationCurve'] ?? 'easeOutBack',
      flutterCode: json['flutterCode'] ?? '',
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      interactionsCount: (json['interactionsCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'description': description,
    'technique': technique,
    'configuration': configuration,
    'material': material,
    'animationCurve': animationCurve,
    'flutterCode': flutterCode,
    'viewsCount': viewsCount,
    'interactionsCount': interactionsCount,
  };
}
