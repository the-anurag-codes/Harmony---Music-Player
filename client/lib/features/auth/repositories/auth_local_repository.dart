import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(AuthLocalRepositoryRef ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setToken(String? token) {
    if (token != null) {
      _preferences.setString('token', token);
    }
  }

  String? getToken() {
    return _preferences.getString('token');
  }
}
