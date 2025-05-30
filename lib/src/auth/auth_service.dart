import '../ezviz_client.dart';

class AuthService {
  final EzvizClient _client;

  AuthService(this._client);

  Future<void> login() async {
    // The login is handled implicitly by the EzvizClient when the first request is made.
    // This method can be used to explicitly trigger authentication if needed.
    await _client.post(
      '/api/lapp/token/get',
      {},
    ); // Make a dummy request to trigger auth
  }

  // Add other authentication related methods if any, like logout, refresh token etc.
}
