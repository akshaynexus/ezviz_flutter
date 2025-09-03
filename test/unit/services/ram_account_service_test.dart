import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/src/ram/ram_account_service.dart';
import '../../../test/test_utils.dart';

void main() {
  group('RamAccountService', () {
    late MockEzvizClient mockClient;
    late RamAccountService service;

    setUp(() {
      mockClient = MockEzvizClient();
      service = RamAccountService(mockClient);
    });

    test('createRamAccount builds request', () async {
      await service.createRamAccount('user', 'md5pwd');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/account/create');
      expect(mockClient.lastBody, {'accountName': 'user', 'password': 'md5pwd'});
    });

    test('getRamAccountInfo prioritizes accountId over accountName', () async {
      await service.getRamAccountInfo(accountId: '1', accountName: 'user');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/account/get');
      expect(mockClient.lastBody, containsPair('accountId', '1'));
      // When only name provided
      await service.getRamAccountInfo(accountName: 'user');
      expect(mockClient.lastBody, {'accountName': 'user'});
    });

    test('getRamAccountList uses pagination', () async {
      await service.getRamAccountList(pageStart: 10, pageSize: 50);
      expect(mockClient.lastEndpoint, '/api/lapp/ram/account/list');
      expect(mockClient.lastBody, {'pageStart': 10, 'pageSize': 50});
    });

    test('updateRamAccountPassword builds body', () async {
      await service.updateRamAccountPassword('id', 'old', 'new');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/account/updatePassword');
      expect(
        mockClient.lastBody,
        {'accountId': 'id', 'oldPassword': 'old', 'newPassword': 'new'},
      );
    });

    test('policy and statement calls', () async {
      await service.setRamAccountPolicy('id', '{"p":1}');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/policy/set');
      expect(mockClient.lastBody, {'accountId': 'id', 'policy': '{"p":1}'});

      await service.addRamAccountStatement('id', '{"s":1}');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/statement/add');
      expect(mockClient.lastBody, {'accountId': 'id', 'statement': '{"s":1}'});

      await service.deleteRamAccountStatement('id', 'DEV1');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/statement/delete');
      expect(mockClient.lastBody, {'accountId': 'id', 'deviceSerial': 'DEV1'});
    });

    test('token and delete', () async {
      await service.getRamAccountToken('id');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/token/get');
      expect(mockClient.lastBody, {'accountId': 'id'});

      await service.deleteRamAccount('id');
      expect(mockClient.lastEndpoint, '/api/lapp/ram/account/delete');
      expect(mockClient.lastBody, {'accountId': 'id'});
    });
  });
}

