import '../ezviz_client.dart';
// import '../models/models.dart'; // For response parsing

class CloudStorageService {
  final EzvizClient _client;

  CloudStorageService(this._client);

  Future<Map<String, dynamic>> enableCloudStorage(
    String deviceSerial,
    String cardPassword, {
    String? phone,
    int? channelNo, // Defaults to 1 if not specified by API behavior
    int? isImmediately, // 0-No (Default), 1-Yes
  }) async {
    final body = <String, dynamic>{
      'deviceSerial': deviceSerial,
      'cardPassword': cardPassword,
    };
    if (phone != null) body['phone'] = phone;
    if (channelNo != null) body['channelNo'] = channelNo;
    if (isImmediately != null) body['isImmediately'] = isImmediately;

    return _client.post('/api/lapp/cloud/storage/open', body);
  }

  Future<Map<String, dynamic>> getCloudStorageInfo(
    String deviceSerial, {
    String? phone,
    int? channelNo, // Defaults to 1 if not specified by API behavior
  }) async {
    final body = <String, dynamic>{'deviceSerial': deviceSerial};
    if (phone != null) body['phone'] = phone;
    if (channelNo != null) body['channelNo'] = channelNo;

    return _client.post('/api/lapp/cloud/storage/device/info', body);
  }
}
