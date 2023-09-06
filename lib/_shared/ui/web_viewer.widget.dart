import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerWidget extends StatefulWidget {
  final String url;
  const WebViewerWidget({required this.url, super.key});

  @override
  State<WebViewerWidget> createState() => _WebViewerWidgetState();
}

class _WebViewerWidgetState extends State<WebViewerWidget> {
  late final WebViewController? _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
        setState(() {
          _loading = false;
        });
      }))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      _controller != null
          ? WebViewWidget(controller: _controller!)
          : const SizedBox.shrink(),
      _loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : const SizedBox.shrink()
    ]);
  }
}
