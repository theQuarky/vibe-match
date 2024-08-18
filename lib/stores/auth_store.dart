import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yoto/services/auth_service.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  final AuthService _authService = AuthService();

  @observable
  User? currentUser;

  @computed
  bool get isLoggedIn => currentUser != null;

  @action
  Future<void> signIn(String email, String password) async {
    try {
      currentUser = await _authService.signIn(email, password);
    } catch (e) {
      // Handle or rethrow the exception
      throw e.toString();
    }
  }

  @action
  Future<void> signUp(String email, String password) async {
    try {
      currentUser = await _authService.signUp(email, password);
    } catch (e) {
      // Handle or rethrow the exception
      throw e.toString();
    }
  }

  @action
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
  }

  @action
  Future<void> init() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }

  String? validateEmail(String? value) {
    return _authService.validateEmail(value);
  }

  String? validatePassword(String? value) {
    return _authService.validatePassword(value);
  }
}
