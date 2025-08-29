import 'package:ezviz_flutter/ezviz_flutter.dart';
import 'api_config.dart';
// Helper for conceptual MD5 hashing (replace with actual implementation if needed)
// import 'package:crypto/crypto.dart';
// import 'dart:convert'; // for utf8

void main() async {
  // API credentials are now in ApiConfig.dart
  // Use mainAccountAppKey and mainAccountAppSecret for RAM operations
  final client = EzvizClient(
    appKey: ApiConfig.mainAccountAppKey,
    appSecret: ApiConfig.mainAccountAppSecret,
  );
  final ramService = RamAccountService(client);

  // Note: RAM account operations often require specific permissions for the main account's token.
  // The password for sub-accounts is MD5 hashed: LowerCase(MD5(AppKey#PasswordPlaintext))
  // Ensure your mainAppKey is correctly used if you manually compute this for 'createRamAccount' or 'updateRamAccountPassword'.

  // String? newAccountId; // To store the ID of a newly created account for further operations

  try {
    print('Listing RAM accounts (first page)...');
    final listResponse = await ramService.getRamAccountList(pageSize: 5);
    print('RAM Account List: $listResponse');

    // Example: Create a new RAM account
    // const String newRamAccountName = 'testSubAccount123';
    // const String newRamAccountPasswordPlain = 'SubAccountP@ss1';
    // // IMPORTANT: The password needs to be hashed as per EZVIZ docs: LowerCase(MD5(ApiConfig.mainAccountAppKey#newRamAccountPasswordPlain))
    // // This step should ideally be done securely. For simplicity, we assume you have the hashed password.
    // // You would need a crypto library (like 'crypto') to compute MD5.
    // // Example (conceptual - you need to implement actual MD5 hashing):
    // // String hashedPassword = computeMd5Hash('\${ApiConfig.mainAccountAppKey}#\$newRamAccountPasswordPlain').toLowerCase();
    // String exampleHashedPassword = 'replace_with_actual_hashed_password'; // Replace this!

    // print('\nCreating RAM account: \$newRamAccountName...');
    // if (exampleHashedPassword != 'replace_with_actual_hashed_password') {
    //   final createResponse = await ramService.createRamAccount(newRamAccountName, exampleHashedPassword);
    //   print('Create RAM Account Response: \$createResponse');
    //   if (createResponse['code'] == '200' && createResponse['data'] != null) {
    //     newAccountId = createResponse['data']['accountId'];
    //     print('Created RAM Account ID: \$newAccountId');
    //   }
    // } else {
    //   print('Skipping RAM account creation, placeholder hashed password not replaced.');
    // }

    // If an account was created or you have an existing one:
    // const String existingAccountId = 'AN_EXISTING_RAM_ACCOUNT_ID'; // Replace if testing with an existing one
    // final accountIdToTest = newAccountId ?? (existingAccountId != 'AN_EXISTING_RAM_ACCOUNT_ID' ? existingAccountId : null);

    // if (accountIdToTest != null) {
    //   print('\nFetching info for RAM account: \$accountIdToTest...');
    //   final getInfoResponse = await ramService.getRamAccountInfo(accountId: accountIdToTest);
    //   print('Get RAM Account Info: \$getInfoResponse');

    //   print('\nGetting token for RAM account: \$accountIdToTest...');
    //   final getTokenResponse = await ramService.getRamAccountToken(accountIdToTest);
    //   print('Get RAM Account Token: \$getTokenResponse');

    // Example: Set RAM Account Policy (Requires correctly formatted JSON string for policy)
    // String policyJson = '{"Statement":[{"Permission":"GET,UPDATE","Resource":["dev:\${ApiConfig.exampleDeviceSerial}"]}]}'; // Use a device serial from config
    // print('\nSetting policy for RAM account: \$accountIdToTest...');
    // final setPolicyResponse = await ramService.setRamAccountPolicy(accountIdToTest, policyJson);
    // print('Set RAM Policy Response: \$setPolicyResponse');

    // Example: Delete RAM Account (Use with caution!)
    // print('\nDeleting RAM account: \$accountIdToTest...');
    // final deleteResponse = await ramService.deleteRamAccount(accountIdToTest);
    // print('Delete RAM Account Response: \$deleteResponse');
    // }
  } catch (e) {
    if (e is EzvizAuthException) {
      print('EZVIZ Authentication Error: ${e.message} (Code: ${e.code})');
    } else if (e is EzvizApiException) {
      print('EZVIZ API Error: ${e.message} (Code: ${e.code})');
    } else {
      print('An unexpected error occurred: $e');
    }
  }
}

// String computeMd5Hash(String input) {
//   return md5.convert(utf8.encode(input)).toString();
// }
