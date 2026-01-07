import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'media_type.dart';

class MediaPlayerWidget extends StatefulWidget {
  final String source;

  const MediaPlayerWidget({super.key, required this.source});

  @override
  State<MediaPlayerWidget> createState() =>
      _MediaPlayerWidgetState();
}

class _MediaPlayerWidgetState extends State<MediaPlayerWidget> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initMedia();
  }

  void _initMedia() {
    final type = detectMediaType(widget.source);

    if (type == MediaType.video) {
      _videoController =
      VideoPlayerController.file(File(widget.source))
        ..initialize().then((_) {
          setState(() {});
          _videoController!
            ..setLooping(true)
            ..play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final type = detectMediaType(widget.source);

    switch (type) {
      case MediaType.video:
        return _videoController != null &&
            _videoController!.value.isInitialized
            ? SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width:
              _videoController!.value.size.width,
              height:
              _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
        )
            : const Center(child: CircularProgressIndicator());

      case MediaType.image:
        return SizedBox.expand(
          child: Image.file(
            File(widget.source),
            fit: BoxFit.cover,
          ),
        );

      case MediaType.web:
        return WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..loadRequest(Uri.parse(widget.source)),
        );

      default:
        return const Center(
          child: Text(
            'Unsupported media',
            style: TextStyle(color: Colors.white),
          ),
        );
    }
  }
}
