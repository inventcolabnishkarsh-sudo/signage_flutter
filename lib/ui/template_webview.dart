import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../app/app_state.dart';

class TemplateWebView extends StatefulWidget {
  final AppState state;
  const TemplateWebView({super.key, required this.state});

  @override
  State<TemplateWebView> createState() => _TemplateWebViewState();
}

class _TemplateWebViewState extends State<TemplateWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // 🔥 Android-specific creation params
    final params = const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF000000))
      ..addJavaScriptChannel(
        'Flutter',
        onMessageReceived: (message) {
          debugPrint("JS says: ${message.message}");
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            widget.state.updateLoading("Loading template…", p / 100);
          },
          onPageFinished: (_) {
            widget.state.stopTemplateLoading();
            widget.state.showTemplateView();
          },
          onWebResourceError: (error) {
            debugPrint(
              "WebView Error: ${error.errorCode} - ${error.description}",
            );
          },
        ),
      );

    // 🔥 ANDROID AUTOPLAY FIX (THIS IS THE KEY)
    final androidController = _controller.platform as AndroidWebViewController;

    androidController.setMediaPlaybackRequiresUserGesture(false);

    _loadTemplate();
  }

  Future<void> _loadTemplate() async {
    final template = widget.state.currentTemplate;
    if (template == null) return;

    debugPrint("📄 Loading template in WebView: $template");

    widget.state.startTemplateLoading("Preparing content…");

    await _controller.loadRequest(Uri.parse(template));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: WebViewWidget(controller: _controller));
  }
}
