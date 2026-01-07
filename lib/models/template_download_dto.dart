class TemplateDownloadDto {
  final int screenId;
  final String macProductId;
  final String templateName;

  TemplateDownloadDto({
    required this.screenId,
    required this.macProductId,
    required this.templateName,
  });

  Map<String, dynamic> toJson() {
    return {
      'ScreenID': screenId,
      'Mac_Product_ID': macProductId,
      'TemplateName': templateName,
    };
  }
}
