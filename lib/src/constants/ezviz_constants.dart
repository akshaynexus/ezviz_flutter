/// EZVIZ API regions
enum EzvizRegion { india, china, europe, russia, usa, custom }

class EzvizConstants {
  static String _baseUrl = 'https://open.ezvizlife.com';
  static const String areaDomainPlaceholder = '{areaDomain}';

  /// Regional API endpoints
  static const Map<EzvizRegion, String> regionUrls = {
    EzvizRegion.india: "https://iindiaopen.ezvizlife.com",
    EzvizRegion.china: "https://iopen.ezvizlife.com",
    EzvizRegion.europe: "https://ieuopen.ezvizlife.com",
    EzvizRegion.russia: "https://iruopen.ezvizlife.com",
    EzvizRegion.usa: "https://iusopen.ezvizlife.com",
  };

  /// Gets the current base URL for EZVIZ API
  static String get baseUrl => _baseUrl;

  /// Sets the region for EZVIZ API
  ///
  /// Example:
  /// ```dart
  /// EzvizConstants.setRegion(EzvizRegion.europe);
  /// ```
  static void setRegion(EzvizRegion region) {
    final url = regionUrls[region];
    if (url != null) {
      _baseUrl = url;
    }
  }

  /// Sets a custom base URL for EZVIZ API
  ///
  /// Use this for custom or private EZVIZ deployments
  ///
  /// Example:
  /// ```dart
  /// EzvizConstants.setBaseUrl('https://custom.ezvizlife.com');
  /// ```
  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  /// Gets the URL for a specific region without changing the global setting
  static String? getRegionUrl(EzvizRegion region) {
    return regionUrls[region];
  }
}
