enum MediaType {
  video,
  image,
  web,
  unknown,
}

MediaType detectMediaType(String fileName) {
  final lower = fileName.toLowerCase();

  if (lower.endsWith('.mp4')) return MediaType.video;
  if (lower.endsWith('.jpg') || lower.endsWith('.png'))
    return MediaType.image;
  if (lower.endsWith('.html') || lower.startsWith('http'))
    return MediaType.web;

  return MediaType.unknown;
}
