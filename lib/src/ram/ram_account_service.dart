import '../ezviz_client.dart';
// import '../models/models.dart'; // For response parsing

class RamAccountService {
  final EzvizClient _client;

  RamAccountService(this._client);

  Future<Map<String, dynamic>> createRamAccount(
    String accountName,
    String password, // LowerCase(MD5(AppKey#Passwords plaintext))
  ) async {
    return _client.post('/api/lapp/ram/account/create', {
      'accountName': accountName,
      'password': password,
    });
  }

  Future<Map<String, dynamic>> getRamAccountInfo({
    String? accountId,
    String? accountName,
  }) async {
    // If not using sub-account's accessToken, one of accountId or accountName must be provided.
    // If both provided, accountId is used.
    final body = <String, dynamic>{};
    if (accountId != null) body['accountId'] = accountId;
    if (accountName != null) body['accountName'] = accountName;
    return _client.post('/api/lapp/ram/account/get', body);
  }

  Future<Map<String, dynamic>> getRamAccountList({
    int pageStart = 0,
    int pageSize = 10, // Max 50
  }) async {
    return _client.post('/api/lapp/ram/account/list', {
      'pageStart': pageStart,
      'pageSize': pageSize,
    });
  }

  Future<Map<String, dynamic>> updateRamAccountPassword(
    String accountId,
    String oldPassword, // LowerCase(MD5(AppKey#plaintext))
    String newPassword, // LowerCase(MD5(AppKey#plaintext))
  ) async {
    return _client.post('/api/lapp/ram/account/updatePassword', {
      'accountId': accountId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
  }

  Future<Map<String, dynamic>> setRamAccountPolicy(
    String accountId,
    String policy, // JSON string of RamAccountPolicy
  ) async {
    return _client.post('/api/lapp/ram/policy/set', {
      'accountId': accountId,
      'policy': policy,
    });
  }

  Future<Map<String, dynamic>> addRamAccountStatement(
    String accountId,
    String statement, // JSON string of RamAccountPolicyStatement
  ) async {
    return _client.post('/api/lapp/ram/statement/add', {
      'accountId': accountId,
      'statement': statement,
    });
  }

  Future<Map<String, dynamic>> deleteRamAccountStatement(
    String accountId,
    String deviceSerial,
  ) async {
    return _client.post('/api/lapp/ram/statement/delete', {
      'accountId': accountId,
      'deviceSerial': deviceSerial,
    });
  }

  Future<Map<String, dynamic>> getRamAccountToken(String accountId) async {
    // Response is similar to the main token get, includes accessToken, expireTime, areaDomain
    return _client.post('/api/lapp/ram/token/get', {'accountId': accountId});
  }

  Future<Map<String, dynamic>> deleteRamAccount(String accountId) async {
    return _client.post('/api/lapp/ram/account/delete', {
      'accountId': accountId,
    });
  }

  // Other RAM account methods will be added here.
}
