enum UpdateType {
  templateUpdateStatus,
  scheduledTemplateUpdateStatus,
  patchUpdateStatus,
  logCollectStatus,
  deleteInstantTemplate,
  deleteScheduledTemplate,
  appendInstantTemplateStatus,
  appendScheduledTemplateStatus,
  activeTemplateName,
}

class UpdateCmdStatusDTO {
  final int screenId;
  final String macProductId;
  final UpdateType updateType;
  final String templateName;
  final String status;
  final String fileName;

  UpdateCmdStatusDTO({
    required this.screenId,
    required this.macProductId,
    required this.updateType,
    required this.templateName,
    required this.status,
    required this.fileName,
  });

  factory UpdateCmdStatusDTO.fromJson(Map<String, dynamic> json) {
    return UpdateCmdStatusDTO(
      screenId: json['screenID'],
      macProductId: json['mac_Product_ID'],
      updateType: UpdateType.values[json['updateType']],
      templateName: json['templateName'],
      status: json['status'],
      fileName: json['fileName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'screenID': screenId,
      'mac_Product_ID': macProductId,
      'updateType': updateType.index,
      'templateName': templateName,
      'status': status,
      'fileName': fileName,
    };
  }
}

class UpdateCmdStatusDTOResponse {
  final bool result;
  final String message;

  UpdateCmdStatusDTOResponse({
    required this.result,
    required this.message,
  });

  factory UpdateCmdStatusDTOResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCmdStatusDTOResponse(
      result: json['result'],
      message: json['message'],
    );
  }
}
