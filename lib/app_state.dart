import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class AppState extends ChangeNotifier {
  final StorageService _storage = StorageService();

  bool _isAuthenticated = false;
  String? _username;

  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;

  Future<void> initialize() async {
    final token = await _storage.getToken();

    if (token != null && token.isNotEmpty) {
      _isAuthenticated = true;
      _username = 'Sebastián';
    }

    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    if (username == 'admin' && password == '123456') {
      const token = 'token-demo-seguro-2026';

      await _storage.saveToken(token);

      _isAuthenticated = true;
      _username = username;

      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await _storage.deleteToken();

    _isAuthenticated = false;
    _username = null;

    notifyListeners();
  }
}