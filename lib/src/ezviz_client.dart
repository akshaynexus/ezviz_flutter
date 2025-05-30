import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/ezviz_constants.dart';
import 'exceptions/ezviz_exceptions.dart';

class EzvizClient {
  final String? appKey;
  final String? appSecret;
  String? _accessToken;
  String? _areaDomain;
  DateTime? _tokenExpireTime;
  final bool _hasProvidedAccessToken;

  /// Creates an EzvizClient with flexible authentication options.
  ///
  /// Either provide:
  /// - [accessToken] for direct authentication, or
  /// - [appKey] and [appSecret] to authenticate via API
  ///
  /// If [accessToken] is provided, it will be used directly.
  /// If [appKey] and [appSecret] are provided, they will be used to obtain an access token.
  EzvizClient({
    this.appKey,
    this.appSecret,
    String? accessToken,
    String? areaDomain,
  }) : _hasProvidedAccessToken = accessToken != null {
    // Validate that we have either accessToken or both appKey+appSecret
    if (accessToken == null && (appKey == null || appSecret == null)) {
      throw ArgumentError(
        'Either provide accessToken directly, or both appKey and appSecret for API authentication',
      );
    }

    // If accessToken is provided, use it directly
    if (accessToken != null) {
      _accessToken = accessToken;
      _areaDomain = areaDomain;
      // For provided tokens, we don't know the expiry time, so we'll handle auth errors when they occur
    }
  }

  Future<void> _ensureAuthenticated() async {
    // If we have a provided access token, assume it's valid until we get an auth error
    if (_hasProvidedAccessToken && _accessToken != null) {
      return;
    }

    // For API-obtained tokens, check expiry and refresh if needed
    if (_accessToken == null ||
        (_tokenExpireTime != null &&
            DateTime.now().isAfter(_tokenExpireTime!))) {
      await _authenticate();
    }
  }

  Future<void> _authenticate() async {
    // Can only authenticate via API if we have appKey and appSecret
    if (appKey == null || appSecret == null) {
      throw EzvizAuthException(
        'Cannot authenticate: no appKey/appSecret provided and access token is invalid/expired',
      );
    }

    final response = await http.post(
      Uri.parse('${EzvizConstants.baseUrl}/api/lapp/token/get'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'appKey': appKey!, 'appSecret': appSecret!},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == '200') {
        _accessToken = data['data']['accessToken'];
        _areaDomain = data['data']['areaDomain'];
        // Convert expireTime from milliseconds to DateTime
        _tokenExpireTime = DateTime.fromMillisecondsSinceEpoch(
          data['data']['expireTime'],
        );
      } else {
        throw EzvizAuthException(
          'Authentication failed: ${data['msg']}',
          code: data['code'],
        );
      }
    } else {
      throw EzvizAuthException(
        'Authentication request failed with status: ${response.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body,
  ) async {
    await _ensureAuthenticated();

    final url = (_areaDomain ?? EzvizConstants.baseUrl) + path;

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'accessToken': _accessToken!, ...body},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['code'] == '200') {
        return data; // Or data['data'] depending on API structure
      } else {
        // Handle authentication errors for provided tokens
        if (data['code'] == '10001' || data['code'] == '10002') {
          if (_hasProvidedAccessToken) {
            throw EzvizAuthException(
              'Provided access token is invalid or expired: ${data['msg']}',
              code: data['code'],
            );
          } else {
            // Try to re-authenticate for API-obtained tokens
            await _authenticate();
            return post(path, body); // Retry the request
          }
        }
        throw EzvizApiException(
          'API Error: ${data['msg']}',
          code: data['code'],
        );
      }
    } else {
      throw EzvizApiException(
        'API request failed with status: ${response.statusCode}',
      );
    }
  }
}
