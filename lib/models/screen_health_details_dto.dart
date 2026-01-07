class ScreenHealthDetailsDTO {
  final int screenId;
  final String macProductId;
  final String templateName;
  final double totalSpace;
  final double filledSpace;

  ScreenHealthDetailsDTO({
    required this.screenId,
    required this.macProductId,
    required this.templateName,
    required this.totalSpace,
    required this.filledSpace,
  });

  factory ScreenHealthDetailsDTO.fromJson(Map<String, dynamic> json) {
    return ScreenHealthDetailsDTO(
      screenId: json['screenID'],
      macProductId: json['mac_Product_ID'],
      templateName: json['templateName'],
      totalSpace: (json['totalSpace'] as num).toDouble(),
      filledSpace: (json['filledSpace'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screenID': screenId,
      'mac_Product_ID': macProductId,
      'templateName': templateName,
      'totalSpace': totalSpace,
      'filledSpace': filledSpace,
    };
  }
}
