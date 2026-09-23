import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  String _baseUrl = 'http://localhost:5000/api';
  String? _token;

  String get baseUrl => _baseUrl;
  String? get token => _token;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void setBaseUrl(String url) {
    _baseUrl = url.replaceAll(RegExp(r'/+$'), '');
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('skeuolab_auth_token');
    } catch (_) {}
  }

  Future<void> setToken(String? token) async {
    _token = token;
    try {
      final prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('skeuolab_auth_token', token);
      } else {
        await prefs.remove('skeuolab_auth_token');
      }
    } catch (_) {}
  }

  Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // --- Auth Endpoints ---

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/login'),
            headers: _headers,
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 4));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['data'] != null && data['data']['token'] != null) {
        await setToken(data['data']['token']);
      }
      return data;
    } catch (e) {
      // Local fallback mock login if backend is completely offline
      if (email.contains('admin')) {
        await setToken('mock_admin_token_2026');
        return {
          'success': true,
          'message': 'Local Mode: Offline Admin Session Activated',
          'data': {
            'user': {
              'id': 'offline_admin_1',
              'name': 'Chief Instrument Engineer',
              'email': email,
              'role': 'ADMIN',
              'stats': {'interactions': 84, 'savedMaterials': 14, 'savedComponents': 15, 'collectionsCount': 3},
            },
            'token': 'mock_admin_token_2026',
          }
        };
      } else {
        await setToken('mock_user_token_2026');
        return {
          'success': true,
          'message': 'Local Mode: Offline Operator Session Activated',
          'data': {
            'user': {
              'id': 'offline_user_1',
              'name': 'Apprentice Operator',
              'email': email,
              'role': 'USER',
              'stats': {'interactions': 24, 'savedMaterials': 5, 'savedComponents': 6, 'collectionsCount': 1},
            },
            'token': 'mock_user_token_2026',
          }
        };
      }
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/auth/register'),
            headers: _headers,
            body: jsonEncode({'name': name, 'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 4));

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 && data['data'] != null && data['data']['token'] != null) {
        await setToken(data['data']['token']);
      }
      return data;
    } catch (e) {
      await setToken('mock_registered_token_2026');
      return {
        'success': true,
        'message': 'Local Mode: Operator Account Commissioned',
        'data': {
          'user': {
            'id': 'offline_reg_1',
            'name': name,
            'email': email,
            'role': 'USER',
            'stats': {'interactions': 0, 'savedMaterials': 0, 'savedComponents': 0, 'collectionsCount': 0},
          },
          'token': 'mock_registered_token_2026',
        }
      };
    }
  }

  Future<Map<String, dynamic>> getMe() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/auth/me'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      return jsonDecode(response.body);
    } catch (_) {
      return {'success': false, 'error': 'OFFLINE'};
    }
  }

  Future<void> logout() async {
    try {
      await http
          .post(Uri.parse('$_baseUrl/auth/logout'), headers: _headers)
          .timeout(const Duration(seconds: 2));
    } catch (_) {}
    await setToken(null);
  }

  // --- Materials & Components Endpoints ---

  Future<List<dynamic>> getMaterials({String? category, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$_baseUrl/materials').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as List<dynamic>? ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<List<dynamic>> getComponents({String? category, String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (category != null && category != 'all') queryParams['category'] = category;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final uri = Uri.parse('$_baseUrl/components').replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as List<dynamic>? ?? [];
      }
    } catch (_) {}
    return [];
  }

  // --- Collections Endpoints ---

  Future<List<dynamic>> getCollections() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/collections'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as List<dynamic>? ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>> createCollection(String name, String description, {List<String>? components, List<String>? materials}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/collections'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'description': description,
              'components': components ?? [],
              'materials': materials ?? [],
            }),
          )
          .timeout(const Duration(seconds: 3));
      return jsonDecode(response.body);
    } catch (_) {
      return {'success': false, 'message': 'Failed to save parts drawer'};
    }
  }

  Future<bool> deleteCollection(String id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/collections/$id'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // --- Favorites Endpoints ---

  Future<List<dynamic>> getFavorites() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/favorites'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as List<dynamic>? ?? [];
      }
    } catch (_) {}
    return [];
  }

  Future<bool> addFavorite(String itemId, String itemType) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/favorites'),
            headers: _headers,
            body: jsonEncode({'itemId': itemId, 'itemType': itemType}),
          )
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFavorite(String itemId) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/favorites/$itemId'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // --- Analytics & Tracking Endpoints ---

  Future<void> trackInteraction(String action, String category, [Map<String, dynamic>? metadata]) async {
    try {
      await http
          .post(
            Uri.parse('$_baseUrl/analytics/track'),
            headers: _headers,
            body: jsonEncode({
              'action': action,
              'category': category,
              'metadata': metadata ?? {},
            }),
          )
          .timeout(const Duration(seconds: 2));
    } catch (_) {}
  }

  Future<Map<String, dynamic>?> getUserAnalytics() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/analytics/me'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as Map<String, dynamic>?;
      }
    } catch (_) {}
    return null;
  }

  // --- Admin Endpoints ---

  Future<Map<String, dynamic>?> getAdminStats() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/admin/stats'), headers: _headers)
          .timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body['data'] as Map<String, dynamic>?;
      }
    } catch (_) {}
    return null;
  }

  Future<bool> reseedDatabase() async {
    try {
      final response = await http
          .post(Uri.parse('$_baseUrl/admin/reseed'), headers: _headers)
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
