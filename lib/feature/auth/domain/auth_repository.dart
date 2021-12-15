import 'package:case_study/feature/auth/domain/auth_models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IAuthRepository {
  Future<UserCredential> registerUser({required email, password});
  Future<UserCredential> signIn({required email, required password});
  Future<dynamic> logout();
  Future<UserMap> userInfo();
  Future<void> cacheUserToken(UserCredential userCredential);
  Future<String?> getUserToken();
}

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  SharedPreferences? _sharedPref;
  final String _tokenKey = "TOKEN";
  final String _nameKey = "NAME";
  final String _emailKey = "EMAIL";
  final String _uidKey = "UID";

  @override
  Future<void> cacheUserToken(UserCredential userCredential) async {
    final pref = await _getPref();
    final token = await userCredential.user!.getIdToken();
    pref.setString(_tokenKey, token);
    pref.setString(_nameKey, "");
    pref.setString(_emailKey, userCredential.user!.email!);
    pref.setString(_uidKey, userCredential.user!.uid);
  }

  @override
  Future<String?> getUserToken() async {
    final pref = await _getPref();
    return pref.getString(_tokenKey);
  }

  @override
  Future<UserCredential> registerUser({required email, password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<UserCredential> signIn({required email, required password}) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      await cacheUserToken(result);
      return result;
    } on FirebaseException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future logout() async {
    final pref = await _getPref();
    pref.setString(_tokenKey, "");
    pref.setString(_nameKey, "");
    pref.setString(_emailKey, "");
    pref.setString(_uidKey, "");
  }

  Future<SharedPreferences> _getPref() async {
    if (_sharedPref == null)
      _sharedPref = await SharedPreferences.getInstance();

    return _sharedPref!;
  }

  @override
  Future<UserMap> userInfo() async {
    final pref = await _getPref();
    return UserMap(
        email: pref.getString(_emailKey)!,
        name: pref.getString(_nameKey)!,
        token: pref.getString(_tokenKey)!,
        uid: pref.getString(_uidKey)!);
  }
}
