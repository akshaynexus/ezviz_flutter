class Camera {
  final String deviceSerial;
  final String channelNo;
  final String channelName;
  final String status;
  final String isShared;
  final String thumbnailUrl;
  final bool isEncrypt;
  final String videoLevel;

  Camera({
    required this.deviceSerial,
    required this.channelNo,
    required this.channelName,
    required this.status,
    required this.isShared,
    required this.thumbnailUrl,
    required this.isEncrypt,
    required this.videoLevel,
  });

  @override
  String toString() {
    return 'Camera{deviceSerial: $deviceSerial, channelNo: $channelNo, channelName: $channelName, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Camera &&
          runtimeType == other.runtimeType &&
          deviceSerial == other.deviceSerial &&
          channelNo == other.channelNo;

  @override
  int get hashCode => deviceSerial.hashCode ^ channelNo.hashCode;
}
