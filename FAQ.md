# EZVIZ Flutter SDK - FAQ & Troubleshooting

## ⚠️ MOST COMMON ISSUE - READ THIS FIRST!

**🚨 Can't authenticate / get access token? 99% of the time it's incorrect region configuration!**

Your EZVIZ account is tied to a specific region. The SDK **MUST** use the same region:

```dart
// Set this BEFORE any authentication attempts
EzvizConstants.setRegion(EzvizRegion.europe);  // Match your account region!
```

**Quick region guide** (Official EZVIZ domains):
- Europe/UK/Germany → `EzvizRegion.europe`
- USA/Canada/North America → `EzvizRegion.northAmerica`
- India/South Asia → `EzvizRegion.india`
- Singapore/Southeast Asia → `EzvizRegion.singapore`
- Mexico/Brazil/South America → `EzvizRegion.southAmerica`
- China → `EzvizRegion.china`
- Russia → `EzvizRegion.russia`

👉 **[Jump to complete region guide](#region-configuration)**

---

## 📋 Table of Contents
- [Common SDK Issues](#common-sdk-issues)
- [Authentication Problems](#authentication-problems)
- [Device Management Issues](#device-management-issues)
- [Playback Issues](#playback-issues)
- [Recording Search Issues](#recording-search-issues)
- [Audio Issues](#audio-issues)
- [Recording Issues](#recording-issues)
- [Wi-Fi Configuration Issues](#wi-fi-configuration-issues)
- [Video Player Issues](#video-player-issues)
- [Performance Issues](#performance-issues)
- [Region Configuration](#region-configuration)

## Common SDK Issues

### Authentication Problems

**Q: My access token expired. How do I refresh it?**
- Use `EzvizAuthManager.getAccessToken()` to check token validity
- The SDK automatically refreshes tokens when using `EzvizClient` with appKey/appSecret
- For manual refresh, call the authentication method again

**Q: Login failed with "area not found" error**
- Ensure correct area/region selection with `EzvizAuthManager.getAreaList()`
- Check if your account is registered in the selected region
- Try different regions if unsure: `EzvizConstants.setRegion(EzvizRegion.europe)`

**Q: Can't get access token / Authentication always fails**
- ⚠️ **Most Common Issue**: Incorrect region configuration
- Your EZVIZ/HIK-Connect account is tied to a specific region where it was created
- The SDK **must** use the same region as your account registration
- **Solution**: Set the correct region based on where your account was created:

```dart
// If account created in Europe/Germany/UK/etc
EzvizConstants.setRegion(EzvizRegion.europe);

// If account created in USA/Canada/North America
EzvizConstants.setRegion(EzvizRegion.northAmerica);

// If account created in Mexico/Brazil/South America
EzvizConstants.setRegion(EzvizRegion.southAmerica);

// If account created in India/Singapore/South Asia
EzvizConstants.setRegion(EzvizRegion.india);

// If account created in China
EzvizConstants.setRegion(EzvizRegion.china);

// If account created in Russia/CIS
EzvizConstants.setRegion(EzvizRegion.russia);
```

- **How to find your account region**:
  1. Check the EZVIZ mobile app - it connects to specific regional servers
  2. Look at your account registration email domain
  3. Try the region where you physically registered the account
  4. Test different regions systematically until authentication succeeds

- **Important**: Without the correct region, you cannot:
  - Get access tokens
  - Load device lists
  - Stream camera video
  - Access any API data

**Q: Global SDK initialization fails**
- Initialize proper area with `EzvizAuthManager.initGlobalSDK()`
- Ensure you've selected the correct region before initialization
- Check network connectivity to the selected region's servers

### Device Management Issues

**Q: Device not found when trying to add**
- Use `EzvizDeviceManager.probeDeviceInfo()` first to verify device exists
- Ensure device is powered on and connected to network
- Check if device serial number is correct

**Q: Add device failed with error codes**
- **20020**: Device already added to another account
- **20022**: Device requires verification code
- **20023**: Invalid verification code provided
- Solution: Provide correct verification code or reset device

**Q: Device list is empty**
- Ensure user is logged in with valid access token
- Check if devices are associated with the account
- Verify region settings match where devices are registered

### Playback Issues

**Q: Pause/Resume not working on my stream**
- These functions only work for recorded video playback
- Live streams cannot be paused
- Use `stopRealPlay()` and `startRealPlay()` for live streams

**Q: Video seek is not working**
- Ensure you're using recorded video playback, not live streaming
- Check if the recording supports seeking
- Use `controller.seekPlayback()` with valid timestamp

**Q: No audio in playback**
- Check device audio capabilities
- Enable audio with `controller.openSound()`
- Ensure device microphone/speaker is not muted
- Verify audio permissions are granted

**Q: Can't change playback speed**
- Use `controller.setPlaySpeed()` only during recorded video playback
- Speed control not available for live streams
- Supported speeds: 0.25x, 0.5x, 1x, 2x, 4x

### Recording Search Issues

**Q: No recordings found**
- Check time range is correct (use milliseconds since epoch)
- Verify recording types: timing, alarm, manual
- Ensure device was recording during the specified period

**Q: Difference between cloud and device records?**
- Cloud records: Stored on EZVIZ servers, requires subscription
- Device records: Stored on device SD card
- Use appropriate search method:
  - `searchCloudRecordFiles()` for cloud
  - `searchDeviceRecordFiles()` for device

**Q: Time range format issues**
- Always use milliseconds since epoch for timestamps
- Example: `DateTime.now().millisecondsSinceEpoch`
- Ensure start time is before end time

### Audio Issues

**Q: Microphone not working**
- Ensure microphone permissions are granted in app settings
- Check `Info.plist` (iOS) or `AndroidManifest.xml` (Android)
- Verify device supports audio features

**Q: Intercom audio problems**
- Verify intercom parameters:
  - Full-duplex: use `supportTalk: 1`
  - Half-duplex: use `supportTalk: 3`
- Check network bandwidth for two-way audio
- Ensure both app and device support intercom

### Recording Issues

**Q: Can't save recordings**
- Check storage permissions are granted
- Ensure sufficient device storage available
- Verify recording format is supported
- Check write permissions to the save directory

**Q: How to check if recording is active?**
- Use `controller.isLocalRecording()` to check status
- Monitor recording callbacks for success/failure
- Check available storage before starting

### Wi-Fi Configuration Issues

**Q: Device won't connect to Wi-Fi**
- Ensure location permissions for Wi-Fi scanning
- Check device is in configuration mode (usually blinking LED)
- Verify network credentials are correct
- Ensure 2.4GHz network (5GHz often not supported)

**Q: Configuration modes explained**
- **Wi-Fi Mode**: Direct Wi-Fi configuration
- **Wave Mode**: Sound wave configuration
- **AP Mode**: Access Point mode configuration
- Choose based on device capabilities

### Video Player Issues

**Q: Black screen in player**
- Check device serial number is correct
- Verify encryption/verification code if required
- Ensure network connectivity to device
- Check if device is online

**Q: Fullscreen not working properly**
- Ensure proper controller lifecycle management
- Call `controller.dispose()` when done
- Handle orientation changes correctly
- Check for navigation bar/status bar conflicts

**Q: Auto-play not starting**
- Verify access token is valid
- Check device status (online/offline)
- Ensure `autoPlay: true` in configuration
- Network delays may affect auto-play

**Q: Encryption password dialog not showing**
- Enable with `enableEncryptionDialog: true` in config
- Implement `onPasswordRequired` callback
- Provide password via `encryptionPassword` parameter

### Performance Issues

**Q: Slow video loading**
- Use `EzvizSimplePlayer` for optimized performance
- Check network bandwidth
- Consider using lower video quality initially
- Implement proper loading states

**Q: High memory usage**
- Dispose controllers properly in `dispose()` method
- Limit concurrent video streams
- Use `stopRealPlay()` when player not visible
- Clear cache periodically

**Q: Multiple players causing lag**
- Limit to 1-2 concurrent video streams
- Use thumbnail previews instead of live streams
- Implement lazy loading for player widgets
- Consider using lower quality for multiple streams

## Region Configuration

⚠️ **CRITICAL**: Region configuration is the #1 cause of authentication failures!

**Q: How do I set the correct region?**

**First, identify your account region** - Your EZVIZ/HIK-Connect account is locked to the region where it was created:

| Account Created In | Use Region | Example Countries | Official Domain |
|-------------------|------------|-------------------|-----------------|
| Europe/EU | `EzvizRegion.europe` | Germany, UK, France, Netherlands, Spain | `open.ezvizlife.com` |
| USA/North America | `EzvizRegion.northAmerica` | USA, Canada | `apius.ezvizlife.com` |
| India/South Asia | `EzvizRegion.india` | India, Bangladesh, Sri Lanka | `iindiaopen.ezvizlife.com` |
| Singapore/SEA | `EzvizRegion.singapore` | Singapore, Malaysia, Thailand | `apiisgp.ezvizlife.com` |
| Mexico/South America | `EzvizRegion.southAmerica` | Mexico, Brazil, Argentina, Colombia | `isgpopen.ezviz.com` |
| China | `EzvizRegion.china` | China, Hong Kong | `open.ys7.com` |
| Russia/CIS | `EzvizRegion.russia` | Russia, Kazakhstan, Belarus | `iruopen.ezvizlife.com` |

**Then configure globally:**
```dart
// At app startup - MATCH YOUR ACCOUNT REGION
EzvizConstants.setRegion(EzvizRegion.europe);  // Example for EU accounts
```

**Or per-instance:**
```dart
// For specific client/player
EzvizClient(
  appKey: 'KEY',
  appSecret: 'SECRET',
  region: EzvizRegion.northAmerica,  // Example for US accounts
)
```

**Q: How do I find my account region?**
1. **EZVIZ Mobile App**: Check which regional server it connects to
2. **Registration Location**: Where you created your account physically
3. **Email Domain**: Check your registration/welcome emails for regional domains
4. **Trial & Error**: Test regions systematically until authentication works

**Q: Available regions?**
- `EzvizRegion.india` - India, South Asia
- `EzvizRegion.china` - China (mainland)
- `EzvizRegion.europe` - European regions
- `EzvizRegion.northAmerica` - USA, Canada, North America
- `EzvizRegion.singapore` - Singapore, Southeast Asia
- `EzvizRegion.southAmerica` - Mexico, Brazil, South America
- `EzvizRegion.russia` - Russia, CIS countries

**Q: Custom endpoint needed?**
```dart
EzvizConstants.setBaseUrl('https://custom.ezvizlife.com');
```

## Platform-Specific Issues

### iOS Issues

**Q: App crashes on iOS 14+**
- Add required privacy permissions to Info.plist
- Enable background modes if needed
- Check for Swift compatibility issues

### Android Issues

**Q: Android build fails**
- Ensure minSdkVersion >= 21
- Add required permissions to AndroidManifest.xml
- Check ProGuard rules for release builds

## Getting Help

If your issue isn't covered here:

1. Check the [example folder](example/) for working code
2. Review the [API documentation](https://pub.dev/documentation/ezviz_flutter/latest/)
3. Search [existing issues](https://github.com/akshaynexus/ezviz_flutter/issues)
4. Create a new issue with:
   - Flutter version
   - Plugin version
   - Device/Platform
   - Error logs
   - Minimal code to reproduce

## Common Error Codes

| Code | Description | Solution |
|------|-------------|----------|
| 10001 | Invalid access token | Refresh token or re-authenticate |
| 10002 | Token expired | Get new token |
| 20008 | Device offline | Check device power and network |
| 20020 | Device already added | Remove from other account first |
| 20022 | Verification code required | Provide device verification code |
| 20023 | Invalid verification code | Check code on device label |
| 30001 | Network timeout | Check internet connection |
| 30003 | Server error | Try again later |

## Best Practices

1. **Always dispose controllers** when done to prevent memory leaks
2. **Handle errors gracefully** with try-catch blocks
3. **Check permissions** before using camera/microphone features
4. **Use appropriate video quality** based on network conditions
5. **Implement proper loading states** for better UX
6. **Cache authentication tokens** securely
7. **Test on both platforms** as behavior may differ