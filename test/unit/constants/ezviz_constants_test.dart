import 'package:flutter_test/flutter_test.dart';
import 'package:ezviz_flutter/ezviz_flutter.dart';
import '../../test_utils.dart';

void main() {
  group('EzvizConstants', () {
    // Store original state to restore after each test
    late String originalBaseUrl;
    
    setUp(() {
      originalBaseUrl = EzvizConstants.baseUrl;
    });
    
    tearDown(() {
      // Restore original base URL to avoid test interdependencies
      EzvizConstants.setBaseUrl(originalBaseUrl);
    });
    
    group('baseUrl getter', () {
      test('returns default URL when no region is set', () {
        EzvizConstants.baseUrl.expectMeaningful(
          equals('https://open.ezvizlife.com'),
          reason: 'Default base URL should be the global endpoint',
        );
      });
      
      test('returns current base URL after modification', () {
        const testUrl = 'https://custom.example.com';
        EzvizConstants.setBaseUrl(testUrl);
        
        EzvizConstants.baseUrl.expectMeaningful(
          equals(testUrl),
          reason: 'Base URL should reflect the last set value',
        );
      });
    });
    
    group('setRegion', () {
      test('sets base URL to correct region endpoint', () {
        EzvizConstants.setRegion(EzvizRegion.europe);
        EzvizConstants.baseUrl.expectMeaningful(
          equals('https://open.ezvizlife.com'),
          reason: 'Europe region should use official European endpoint',
        );
        
        EzvizConstants.setRegion(EzvizRegion.usa);
        EzvizConstants.baseUrl.expectMeaningful(
          equals('https://apius.ezvizlife.com'),
          reason: 'USA region should use official North American endpoint',
        );
        
        EzvizConstants.setRegion(EzvizRegion.china);
        EzvizConstants.baseUrl.expectMeaningful(
          equals('https://open.ys7.com'),
          reason: 'China region should use official Chinese endpoint',
        );
        
        EzvizConstants.setRegion(EzvizRegion.singapore);
        EzvizConstants.baseUrl.expectMeaningful(
          equals('https://apiisgp.ezvizlife.com'),
          reason: 'Singapore region should use official Singapore endpoint',
        );
      });
      
      test('handles all supported regions correctly', () {
        final regionTests = {
          EzvizRegion.india: 'https://iindiaopen.ezvizlife.com',
          EzvizRegion.china: 'https://open.ys7.com', 
          EzvizRegion.europe: 'https://open.ezvizlife.com',
          EzvizRegion.russia: 'https://iruopen.ezvizlife.com',
          EzvizRegion.usa: 'https://apius.ezvizlife.com',
          EzvizRegion.singapore: 'https://apiisgp.ezvizlife.com',
          EzvizRegion.americas: 'https://isgpopen.ezviz.com',
        };
        
        for (final entry in regionTests.entries) {
          EzvizConstants.setRegion(entry.key);
          EzvizConstants.baseUrl.expectMeaningful(
            equals(entry.value),
            reason: 'Region ${entry.key} should map to ${entry.value}',
          );
        }
      });
      
      test('ignores custom region enum value', () {
        const originalUrl = 'https://test.example.com';
        EzvizConstants.setBaseUrl(originalUrl);
        
        EzvizConstants.setRegion(EzvizRegion.custom);
        
        // Should remain unchanged since custom has no URL mapping
        EzvizConstants.baseUrl.expectMeaningful(
          equals(originalUrl),
          reason: 'Custom region should not change base URL',
        );
      });
    });
    
    group('setBaseUrl', () {
      test('sets custom URL correctly', () {
        final testUrls = [
          'https://custom1.example.com',
          'https://private.ezviz.internal',
          'https://localhost:8080/api',
        ];
        
        for (final url in testUrls) {
          EzvizConstants.setBaseUrl(url);
          EzvizConstants.baseUrl.expectMeaningful(
            equals(url),
            reason: 'Custom URL should be set exactly as provided',
          );
        }
      });
      
      test('overrides region-set URLs', () {
        EzvizConstants.setRegion(EzvizRegion.usa);
        final regionUrl = EzvizConstants.baseUrl;
        
        const customUrl = 'https://override.example.com';
        EzvizConstants.setBaseUrl(customUrl);
        
        EzvizConstants.baseUrl.expectMeaningful(
          equals(customUrl),
          reason: 'Custom URL should override region URL',
        );
        
        customUrl.expectMeaningful(
          isNot(equals(regionUrl)),
          reason: 'New URL should be different from region URL',
        );
      });
      
      test('accepts various URL formats', () {
        final urlFormats = [
          'https://example.com',
          'http://internal.api.local',
          'https://api.example.com:8443',
          'https://subdomain.domain.tld/api/v1',
        ];
        
        for (final url in urlFormats) {
          EzvizConstants.setBaseUrl(url);
          EzvizConstants.baseUrl.expectMeaningful(
            equals(url),
            reason: 'URL format should be preserved: $url',
          );
        }
      });
    });
    
    group('getRegionUrl', () {
      test('returns correct URL for each region without side effects', () {
        const originalUrl = 'https://preserved.example.com';
        EzvizConstants.setBaseUrl(originalUrl);
        
        final regionTests = {
          EzvizRegion.india: 'https://iindiaopen.ezvizlife.com',
          EzvizRegion.china: 'https://open.ys7.com',
          EzvizRegion.europe: 'https://open.ezvizlife.com', 
          EzvizRegion.usa: 'https://apius.ezvizlife.com',
          EzvizRegion.singapore: 'https://apiisgp.ezvizlife.com',
        };
        
        for (final entry in regionTests.entries) {
          final regionUrl = EzvizConstants.getRegionUrl(entry.key);
          
          regionUrl.expectMeaningful(
            equals(entry.value),
            reason: 'getRegionUrl should return correct URL for ${entry.key}',
          );
          
          // Verify no side effect on current baseUrl
          EzvizConstants.baseUrl.expectMeaningful(
            equals(originalUrl),
            reason: 'getRegionUrl should not modify current baseUrl',
          );
        }
      });
      
      test('returns null for custom region', () {
        final customUrl = EzvizConstants.getRegionUrl(EzvizRegion.custom);
        
        customUrl.expectMeaningful(
          isNull,
          reason: 'Custom region should return null URL',
        );
      });
      
      test('handles all enum values consistently', () {
        for (final region in EzvizRegion.values) {
          final result = EzvizConstants.getRegionUrl(region);
          
          if (region == EzvizRegion.custom) {
            result.expectMeaningful(
              isNull,
              reason: 'Custom region should return null',
            );
          } else {
            result.expectMeaningful(
              isNotNull,
              reason: 'Non-custom region ${region.name} should have URL',
            );
            result!.expectMeaningful(
              startsWith('https://'),
              reason: 'All region URLs should use HTTPS',
            );
          }
        }
      });
    });
    
    group('areaDomainPlaceholder', () {
      test('has correct placeholder value', () {
        EzvizConstants.areaDomainPlaceholder.expectMeaningful(
          equals('{areaDomain}'),
          reason: 'Area domain placeholder should be the template string',
        );
      });
    });
    
    group('regionUrls map', () {
      test('contains all non-custom regions', () {
        final expectedRegions = EzvizRegion.values
            .where((r) => r != EzvizRegion.custom)
            .toSet();
        final mapRegions = EzvizConstants.regionUrls.keys.toSet();
        
        mapRegions.expectMeaningful(
          equals(expectedRegions),
          reason: 'regionUrls should contain all non-custom regions',
        );
      });
      
      test('all URLs are valid HTTPS endpoints', () {
        for (final entry in EzvizConstants.regionUrls.entries) {
          entry.value.expectMeaningful(
            startsWith('https://'),
            reason: 'Region ${entry.key.name} should use HTTPS',
          );
          
          entry.value.expectMeaningful(
            contains('.'),
            reason: 'Region ${entry.key.name} should have valid domain',
          );
        }
      });
      
      test('URLs are unique across regions', () {
        final urls = EzvizConstants.regionUrls.values.toList();
        final uniqueUrls = urls.toSet();
        
        urls.length.expectMeaningful(
          equals(uniqueUrls.length),
          reason: 'All region URLs should be unique',
        );
      });
    });
  });
  
  group('EzvizRegion enum', () {
    test('contains expected regions', () {
      final expectedRegions = {
        'india', 'china', 'europe', 'russia', 
        'usa', 'singapore', 'americas', 'custom'
      };
      
      final actualRegions = EzvizRegion.values
          .map((r) => r.name)
          .toSet();
      
      actualRegions.expectMeaningful(
        equals(expectedRegions),
        reason: 'Enum should contain all expected region names',
      );
    });
    
    test('enum values can be used in switch statements', () {
      String getRegionDescription(EzvizRegion region) {
        switch (region) {
          case EzvizRegion.india:
            return 'India/South Asia';
          case EzvizRegion.china:
            return 'China';
          case EzvizRegion.europe:
            return 'Europe';
          case EzvizRegion.russia:
            return 'Russia/CIS';
          case EzvizRegion.usa:
            return 'USA/North America';
          case EzvizRegion.singapore:
            return 'Singapore/SEA';
          case EzvizRegion.americas:
            return 'Americas General';
          case EzvizRegion.custom:
            return 'Custom';
        }
      }
      
      for (final region in EzvizRegion.values) {
        final description = getRegionDescription(region);
        description.expectMeaningful(
          isNotEmpty,
          reason: 'Each region should have a description: ${region.name}',
        );
      }
    });
  });
}