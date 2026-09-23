import 'package:flutter/foundation.dart';
import '../models/material_palette.dart';
import '../core/network/api_client.dart';
import '../utils/sound_helper.dart';

class MaterialsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  
  final List<MaterialPalette> _materials = MaterialPalettes.all;
  MaterialPalette _selectedMaterial = MaterialPalettes.all.first;
  MaterialCategory? _categoryFilter;
  String _searchQuery = '';
  final Set<String> _favoriteIds = {'aluminum', 'brass', 'bakelite'};

  List<MaterialPalette> get materials {
    return _materials.where((m) {
      final matchesCategory = _categoryFilter == null || m.category == _categoryFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          m.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.tag.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  MaterialPalette get selectedMaterial => _selectedMaterial;
  MaterialCategory? get categoryFilter => _categoryFilter;
  String get searchQuery => _searchQuery;
  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void selectMaterial(MaterialPalette material) {
    _selectedMaterial = material;
    SoundHelper.playMechanicalClick();
    _api.trackInteraction('MATERIAL_SELECT', 'theme', {'materialId': material.id, 'name': material.name});
    notifyListeners();
  }

  void setCategoryFilter(MaterialCategory? category) {
    _categoryFilter = category;
    SoundHelper.playMechanicalClick();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    SoundHelper.playToggleSwitch();
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
      _api.removeFavorite(id);
    } else {
      _favoriteIds.add(id);
      _api.addFavorite(id, 'material');
    }
    notifyListeners();
  }

  Future<void> fetchRemoteMaterials() async {
    try {
      final remoteList = await _api.getMaterials();
      if (remoteList.isNotEmpty) {
        // Successfully contacted backend
      }
    } catch (_) {}
  }
}
