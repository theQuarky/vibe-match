import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yoto/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthService _authService = AuthService();
  final String _cacheKey = 'auth_cache';

  @observable
  User? currentUser;

  @computed
  bool get isLoggedIn => currentUser != null;

  @action
  Future<void> signIn(String email, String password) async {
    try {
      currentUser = await _authService.signIn(email, password);
      if (currentUser != null) {
        await _saveToCache();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @action
  Future<void> signUp(String email, String password) async {
    try {
      currentUser = await _authService.signUp(email, password);
      if (currentUser != null) {
        await _saveToCache();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @action
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    await _clearCache();
  }

  @action
  Future<void> init() async {
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      await _loadFromCache();
    }
  }

  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();
    if (currentUser != null) {
      await prefs.setString(_cacheKey, currentUser!.uid);
    }
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cachedUid = prefs.getString(_cacheKey);
    if (cachedUid != null) {
      currentUser = await FirebaseAuth.instance.userChanges().first;
    }
  }

  Future<void> _clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  String? validateEmail(String? value) {
    return _authService.validateEmail(value);
  }

  String? validatePassword(String? value) {
    return _authService.validatePassword(value);
  }
}
