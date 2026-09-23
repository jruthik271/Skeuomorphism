import 'package:flutter/foundation.dart';
import '../core/network/api_client.dart';
import '../models/user_model.dart';
import '../utils/sound_helper.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    await _api.init();
    if (_api.isAuthenticated) {
      await checkSession();
    }
  }

  Future<void> checkSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _api.getMe();
      if (res['success'] == true && res['data'] != null && res['data']['user'] != null) {
        _user = UserModel.fromJson(res['data']['user']);
      }
    } catch (_) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    SoundHelper.playMechanicalClick();

    try {
      final res = await _api.login(email, password);
      if (res['success'] == true && res['data'] != null) {
        _user = UserModel.fromJson(res['data']['user']);
        _isLoading = false;
        notifyListeners();
        SoundHelper.playToggleSwitch();
        return true;
      } else {
        _errorMessage = res['message'] ?? 'Authentication failed.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Connection failure with central mainframe.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    SoundHelper.playMechanicalClick();

    try {
      final res = await _api.register(name, email, password);
      if (res['success'] == true && res['data'] != null) {
        _user = UserModel.fromJson(res['data']['user']);
        _isLoading = false;
        notifyListeners();
        SoundHelper.playToggleSwitch();
        return true;
      } else {
        _errorMessage = res['message'] ?? 'Registration failed.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Operator commissioning sequence failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    SoundHelper.playToggleSwitch();
    await _api.logout();
    _user = null;
    notifyListeners();
  }
}
