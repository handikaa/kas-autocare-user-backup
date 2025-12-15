import 'local_storage_service.dart';

class AuthLocalDataSource {
  final _local = LocalStorageService();

  static const _tokenKey = "auth_token";
  static const _userIdKey = "user_id";
  static const _customerIdKey = "customer_id";
  static const _introKey = "intro_completed";

  Future<void> saveToken(String token) async {
    await _local.saveEncrypted(_tokenKey, token);
  }

  Future<String?> getToken() async {
    return await _local.readDecrypted(_tokenKey);
  }

  Future<void> saveUserId(int userId) async {
    await _local.saveEncrypted(_userIdKey, userId.toString());
  }

  Future<int?> getUserId() async {
    final result = await _local.readDecrypted(_userIdKey);
    return result != null ? int.tryParse(result) : null;
  }

  Future<void> saveCustomerId(int csId) async {
    await _local.saveEncrypted(_customerIdKey, csId.toString());
  }

  Future<int?> getCustomerId() async {
    final result = await _local.readDecrypted(_customerIdKey);
    return result != null ? int.tryParse(result) : null;
  }

  Future<void> setIntroCompleted() async {
    await _local.saveEncrypted(_introKey, "true");
  }

  Future<bool> isIntroCompleted() async {
    final result = await _local.readDecrypted(_introKey);
    return result == "true";
  }

  Future<void> clearAuth() async {
    await _local.delete(_tokenKey);
    await _local.delete(_userIdKey);
  }
}
