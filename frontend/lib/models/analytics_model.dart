class UserAnalyticsModel {
  final int totalInteractions;
  final int savedMaterials;
  final int savedComponents;
  final int collectionsCount;
  final int themeChanges;
  final int codeExports;
  final List<Map<String, dynamic>> recentActivities;

  const UserAnalyticsModel({
    this.totalInteractions = 0,
    this.savedMaterials = 0,
    this.savedComponents = 0,
    this.collectionsCount = 0,
    this.themeChanges = 0,
    this.codeExports = 0,
    this.recentActivities = const [],
  });

  factory UserAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return UserAnalyticsModel(
      totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
      savedMaterials: (json['savedMaterials'] as num?)?.toInt() ?? 0,
      savedComponents: (json['savedComponents'] as num?)?.toInt() ?? 0,
      collectionsCount: (json['collectionsCount'] as num?)?.toInt() ?? 0,
      themeChanges: (json['themeChanges'] as num?)?.toInt() ?? 0,
      codeExports: (json['codeExports'] as num?)?.toInt() ?? 0,
      recentActivities: (json['recentActivities'] as List<dynamic>?)
              ?.map((e) => Map<String, dynamic>.from(e as Map))
              .toList() ??
          [],
    );
  }
}

class AdminSystemMetrics {
  final int totalUsers;
  final int activeUsers;
  final int totalMaterials;
  final int totalComponents;
  final int totalInteractions;
  final String cpuLoad;
  final String ramUsage;
  final double uptimeHours;

  const AdminSystemMetrics({
    this.totalUsers = 0,
    this.activeUsers = 0,
    this.totalMaterials = 0,
    this.totalComponents = 0,
    this.totalInteractions = 0,
    this.cpuLoad = '0%',
    this.ramUsage = '0 MB',
    this.uptimeHours = 0.0,
  });

  factory AdminSystemMetrics.fromJson(Map<String, dynamic> json) {
    return AdminSystemMetrics(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
      totalMaterials: (json['totalMaterials'] as num?)?.toInt() ?? 0,
      totalComponents: (json['totalComponents'] as num?)?.toInt() ?? 0,
      totalInteractions: (json['totalInteractions'] as num?)?.toInt() ?? 0,
      cpuLoad: json['cpuLoad']?.toString() ?? '14.2%',
      ramUsage: json['ramUsage']?.toString() ?? '168 MB',
      uptimeHours: (json['uptimeHours'] as num?)?.toDouble() ?? 120.4,
    );
  }
}
