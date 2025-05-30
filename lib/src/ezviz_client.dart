import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants/ezviz_constants.dart';
import 'exceptions/ezviz_exceptions.dart';

class EzvizClient {
  final String appKey;
  final String appSecret;
  String? _accessToken;
  String? _areaDomain;
  DateTime? _tokenExpireTime;

  EzvizClient({required this.appKey, required this.appSecret});

  Future<void> _ensureAuthenticated() async {
    if (_accessToken == null ||
        (_tokenExpireTime != null &&
            DateTime.now().isAfter(_tokenExpireTime!))) {
      await _authenticate();
    }
  }

  Future<void> _authenticate() async {
    final response = await http.post(
      Uri.parse('${EzvizConstants.baseUrl}/api/lapp/token/get'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'appKey': appKey, 'appSecret': appSecret},
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
