import 'package:flutter/foundation.dart';
import '../models/collection_model.dart';
import '../core/network/api_client.dart';
import '../utils/sound_helper.dart';

class CollectionsProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<CollectionModel> _collections = [
    const CollectionModel(
      id: 'coll_audio_master',
      userId: 'user_1',
      name: 'Vacuum Tube Audio Rack',
      description: 'Master analog console with ballistic VU meters, rotary gain pots, and tube preamps.',
      components: ['rotary_knob', 'vu_meter', 'vintage_player'],
      materials: ['aluminum', 'brass', 'bakelite'],
      isPublic: true,
    ),
    const CollectionModel(
      id: 'coll_optics_lab',
      userId: 'user_1',
      name: 'Rangefinder Optics Bay',
      description: 'Precision optical instrumentation, shutter escapements, and machined brass lens mounts.',
      components: ['rangefinder_camera', 'laboratory_notebook'],
      materials: ['aluminum', 'dark_bakelite', 'american_walnut'],
      isPublic: true,
    ),
  ];

  bool _isLoading = false;

  List<CollectionModel> get collections => _collections;
  bool get isLoading => _isLoading;

  Future<void> fetchCollections() async {
    _isLoading = true;
    notifyListeners();
    try {
      final remote = await _api.getCollections();
      if (remote.isNotEmpty) {
        _collections = remote.map((c) => CollectionModel.fromJson(c as Map<String, dynamic>)).toList();
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCollection(String name, String description) async {
    SoundHelper.playMechanicalClick();
    final newDrawer = CollectionModel(
      id: 'local_coll_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'current_user',
      name: name,
      description: description,
      components: [],
      materials: [],
      isPublic: true,
    );
    _collections.insert(0, newDrawer);
    notifyListeners();

    try {
      await _api.createCollection(name, description);
    } catch (_) {}
  }

  Future<void> deleteCollection(String id) async {
    SoundHelper.playToggleSwitch();
    _collections.removeWhere((c) => c.id == id);
    notifyListeners();
    try {
      await _api.deleteCollection(id);
    } catch (_) {}
  }

  void addItemToCollection(String collectionId, String itemId, bool isMaterial) {
    SoundHelper.playMechanicalClick();
    final index = _collections.indexWhere((c) => c.id == collectionId);
    if (index != -1) {
      final existing = _collections[index];
      final components = List<String>.from(existing.components);
      final materials = List<String>.from(existing.materials);

      if (isMaterial) {
        if (!materials.contains(itemId)) materials.add(itemId);
      } else {
        if (!components.contains(itemId)) components.add(itemId);
      }

      _collections[index] = CollectionModel(
        id: existing.id,
        userId: existing.userId,
        name: existing.name,
        description: existing.description,
        components: components,
        materials: materials,
        isPublic: existing.isPublic,
      );
      notifyListeners();
    }
  }
}
