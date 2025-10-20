/// EZVIZ API regions
enum EzvizRegion {
  india,
  china,
  europe,
  russia,
  singapore,
  southAmerica,
  northAmerica,
  custom,
}

class EzvizConstants {
  static String _baseUrl = 'https://open.ezvizlife.com';
  static const String areaDomainPlaceholder = '{areaDomain}';

  /// Regional API endpoints - Official EZVIZ domains
  static const Map<EzvizRegion, String> regionUrls = {
    EzvizRegion.india: "https://iindiaopen.ezvizlife.com", // Confirmed correct
    EzvizRegion.china: "https://open.ys7.com", // Updated to official
    EzvizRegion.europe: "https://ieuopen.ezvizlife.com", // Updated to official
    EzvizRegion.russia:
        "https://iruopen.ezvizlife.com", // Legacy - may need verification
    EzvizRegion.singapore:
        "https://isgpopen.ezvizlife.com", // Added official Singapore
    EzvizRegion.northAmerica:
        "https://iusopen.ezvizlife.com", // Added official North America
    EzvizRegion.southAmerica:
        "https://isaopen.ezvizlife.com", // Added official South America
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
