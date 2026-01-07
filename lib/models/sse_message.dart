enum SseCommandType {
  templateUpdate,
  scheduledUpdate,
  patchUpdate,
  logCollect,
  powerStatus,
  volumeUpdate,
  brightnessUpdate,
  deleteInstantTemplate,
  deleteScheduledTemplate,
  appendInstantTemplate,
  appendScheduledTemplate,
}

enum PowerStatus { online, offline }

class SseMessage {
  final int screenId;
  final String? macProductId;
  final SseCommandType commandType;
  final String? templateName;
  final String? templateSchedule;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool? status;
  final String? volumeLevel;
  final String? brightnessLevel;
  final PowerStatus? powerStatus;
  final String? fileName;

  SseMessage({
    required this.screenId,
    this.macProductId,
    required this.commandType,
    this.templateName,
    this.templateSchedule,
    this.fromDate,
    this.toDate,
    this.status,
    this.volumeLevel,
    this.brightnessLevel,
    this.powerStatus,
    this.fileName,
  });

  factory SseMessage.fromJson(Map<String, dynamic> json) {
    return SseMessage(
      screenId: json['ScreenId'] ?? 0,

      macProductId: json['Mac_Product_ID'],

      commandType:
          SseCommandType.values[(json['CommandType'] ?? 1) -
              1], // 🔥 1-based enum from backend

      templateName: json['TemplateName'],
      templateSchedule: json['TemplateSchedule'],

      fromDate: json['FromDate'] != null
          ? DateTime.parse(json['FromDate'])
          : null,

      toDate: json['ToDate'] != null ? DateTime.parse(json['ToDate']) : null,

      status: json['Status'],
      volumeLevel: json['VolumeLevel'],
      brightnessLevel: json['BrightnessLevel'],

      powerStatus: json['PowerStatus'] != null
          ? PowerStatus.values[json['PowerStatus']]
          : null,

      fileName: json['FileName'],
    );
  }
}
