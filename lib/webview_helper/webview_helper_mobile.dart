// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

// ─── Mines Mobile Webview Loader ──────────────────────────────────────────────
Widget buildMinesWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _MobileMinesWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _MobileMinesWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;
  const _MobileMinesWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_MobileMinesWebView> createState() => _MobileMinesWebViewState();
}

class _MobileMinesWebViewState extends State<_MobileMinesWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF1E2024))
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            if (data['type'] == 'exitGame') {
              Navigator.of(context).pop();
            } else if (data['type'] == 'updateBalance') {
              final double? newBal = double.tryParse(data['balance'].toString());
              if (newBal != null) widget.onBalanceUpdated(newBal);
            }
          } catch (_) {
            final double? newBal = double.tryParse(message.message);
            if (newBal != null) widget.onBalanceUpdated(newBal);
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          _controller.runJavaScript(
            "if (window.setBalanceFromFlutter) { window.setBalanceFromFlutter(${widget.currentBalance}); }"
          );
        },
      ))
      ..loadFlutterAsset('assets/games/mines/index.html');

    if (_controller.platform is AndroidWebViewController) {
      final android = _controller.platform as AndroidWebViewController;
      android.setAllowFileAccess(true);
      android.setAllowContentAccess(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

// ─── Crash Mobile Webview Loader ──────────────────────────────────────────────
Widget buildCrashWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _MobileCrashWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _MobileCrashWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;
  const _MobileCrashWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_MobileCrashWebView> createState() => _MobileCrashWebViewState();
}

class _MobileCrashWebViewState extends State<_MobileCrashWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFFFFFFF))
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            if (data['type'] == 'exitGame') {
              Navigator.of(context).pop();
            } else if (data['type'] == 'updateBalance') {
              final double? newBal = double.tryParse(data['balance'].toString());
              if (newBal != null) widget.onBalanceUpdated(newBal);
            }
          } catch (_) {
            final double? newBal = double.tryParse(message.message);
            if (newBal != null) widget.onBalanceUpdated(newBal);
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          _controller.runJavaScript(
            "if (window.setBalanceFromFlutter) { window.setBalanceFromFlutter(${widget.currentBalance}); }"
          );
        },
      ))
      ..loadFlutterAsset('assets/games/Crush/index.html');

    if (_controller.platform is AndroidWebViewController) {
      final android = _controller.platform as AndroidWebViewController;
      android.setAllowFileAccess(true);
      android.setAllowContentAccess(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

// ─── Aviator Mobile Webview Loader ───────────────────────────────────────────
Widget buildAviatorWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _MobileAviatorWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _MobileAviatorWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;
  const _MobileAviatorWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_MobileAviatorWebView> createState() => _MobileAviatorWebViewState();
}

class _MobileAviatorWebViewState extends State<_MobileAviatorWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0A0B0C))
      ..addJavaScriptChannel(
        'FlutterBridge',
        onMessageReceived: (JavaScriptMessage message) {
          try {
            final Map<String, dynamic> data = jsonDecode(message.message);
            if (data['type'] == 'exitGame') {
              Navigator.of(context).pop();
            } else if (data['type'] == 'updateBalance') {
              final double? newBal = double.tryParse(data['balance'].toString());
              if (newBal != null) widget.onBalanceUpdated(newBal);
            }
          } catch (_) {
            final double? newBal = double.tryParse(message.message);
            if (newBal != null) widget.onBalanceUpdated(newBal);
          }
        },
      )
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          _controller.runJavaScript(
            "if (window.setBalanceFromFlutter) { window.setBalanceFromFlutter(${widget.currentBalance}); }"
          );
        },
      ))
      ..loadFlutterAsset('assets/games/Aviator/index.html');

    if (_controller.platform is AndroidWebViewController) {
      final android = _controller.platform as AndroidWebViewController;
      android.setAllowFileAccess(true);
      android.setAllowContentAccess(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}

