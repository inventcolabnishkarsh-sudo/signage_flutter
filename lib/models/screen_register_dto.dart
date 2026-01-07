class ScreenRegisterDTO {
  final String macProductId;
  final String deviceId;
  final String tagName;
  final String location;
  final String city;
  final String uniqueCode;
  final double latitude;
  final double longitude;
  final String geoCode;
  final String playerType;
  final DateTime? lastCheckIn;
  final String screenWidth;
  final String screenHeight;

  ScreenRegisterDTO({
    required this.macProductId,
    required this.deviceId,
    required this.tagName,
    required this.location,
    required this.city,
    required this.uniqueCode,
    required this.latitude,
    required this.longitude,
    required this.geoCode,
    required this.playerType,
    this.lastCheckIn,
    required this.screenWidth,
    required this.screenHeight,
  });

  factory ScreenRegisterDTO.fromJson(Map<String, dynamic> json) {
    return ScreenRegisterDTO(
      macProductId: json['mac_Product_ID'],
      deviceId: json['deviceId'],
      tagName: json['tagName'],
      location: json['location'],
      city: json['city'],
      uniqueCode: json['uniqueCode'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      geoCode: json['geoCode'],
      playerType: json['playerType'],
      lastCheckIn: json['lastCheckIn'] != null
          ? DateTime.parse(json['lastCheckIn'])
          : null,
      screenWidth: json['screenWidth'],
      screenHeight: json['screenHeight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mac_Product_ID': macProductId,
      'deviceId': deviceId,
      'tagName': tagName,
      'location': location,
      'city': city,
      'uniqueCode': uniqueCode,
      'latitude': latitude,
      'longitude': longitude,
      'geoCode': geoCode,
      'playerType': playerType,
      'lastCheckIn': lastCheckIn?.toIso8601String(),
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
    };
  }
}
