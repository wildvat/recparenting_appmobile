import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewerWidget extends StatefulWidget {
  final String url;
  final String? token;
  const WebViewerWidget({required this.url, super.key, this.token});

  @override
  State<WebViewerWidget> createState() => _WebViewerWidgetState();
}

class _WebViewerWidgetState extends State<WebViewerWidget> {
  late final WebViewController? _controller;
  bool _loading = true;
  @override
  initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (String url) {
        setState(() {
          _loading = false;
        });
      }))
      ..loadRequest(Uri.parse(widget.url), headers: {
        'Content-Type': 'text/html; charset=UTF-8',
        'Authorization': 'Bearer ${widget.token ?? ''}'
      });
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
