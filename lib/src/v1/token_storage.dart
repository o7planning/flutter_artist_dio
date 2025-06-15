interface class TokenStorage {
  Future<String?> readAccessToken() async {
    return "";
  }

  Future<void> saveAccessToken(String newAccessToken) async {
    return;
  }

  Future<void> clearTokens() async {
    //
  }
}
