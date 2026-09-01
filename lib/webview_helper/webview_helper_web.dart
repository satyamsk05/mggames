// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use, use_build_context_synchronously
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import '../screens/deposit_screen.dart';

// ─── Mines Webview Loader ──────────────────────────────────────────────────────
Widget buildMinesWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _WebMinesWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _WebMinesWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const _WebMinesWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_WebMinesWebView> createState() => _WebMinesWebViewState();
}

class _WebMinesWebViewState extends State<_WebMinesWebView> {
  late final String _viewType;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'mines-game-iframe-${DateTime.now().microsecondsSinceEpoch}';

    const gameUrl = 'assets/assets/games/mines/index.html';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        return html.IFrameElement()
          ..src = '$gameUrl?balance=${widget.currentBalance}&v=${DateTime.now().millisecondsSinceEpoch}'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..style.background = '#313738';
      },
    );

    _messageSubscription = html.window.onMessage.listen((event) {
      try {
        Map<String, dynamic> data;
        if (event.data is String) {
          data = jsonDecode(event.data as String) as Map<String, dynamic>;
        } else if (event.data is Map) {
          data = Map<String, dynamic>.from(event.data as Map);
        } else {
          return;
        }
        if (data['type'] == 'updateBalance') {
          final double newBal = (data['balance'] as num).toDouble();
          widget.onBalanceUpdated(newBal);
        } else if (data['type'] == 'exitGame') {
          Navigator.of(context).pop();
        } else if (data['type'] == 'openDeposit') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DepositScreen(
                currentBalance: widget.currentBalance,
                onBalanceUpdated: widget.onBalanceUpdated,
              ),
            ),
          );
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

// ─── Crash (Crush) Webview Loader ──────────────────────────────────────────────
Widget buildCrashWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _WebCrashWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _WebCrashWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const _WebCrashWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_WebCrashWebView> createState() => _WebCrashWebViewState();
}

class _WebCrashWebViewState extends State<_WebCrashWebView> {
  late final String _viewType;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'crash-game-iframe-${DateTime.now().microsecondsSinceEpoch}';

    const gameUrl = 'assets/assets/games/Crush/index.html';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        return html.IFrameElement()
          ..src = '$gameUrl?balance=${widget.currentBalance}&v=${DateTime.now().millisecondsSinceEpoch}'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..style.background = '#ffffff';
      },
    );

    _messageSubscription = html.window.onMessage.listen((event) {
      try {
        Map<String, dynamic> data;
        if (event.data is String) {
          data = jsonDecode(event.data as String) as Map<String, dynamic>;
        } else if (event.data is Map) {
          data = Map<String, dynamic>.from(event.data as Map);
        } else {
          return;
        }
        if (data['type'] == 'updateBalance') {
          final double newBal = (data['balance'] as num).toDouble();
          widget.onBalanceUpdated(newBal);
        } else if (data['type'] == 'exitGame') {
          Navigator.of(context).pop();
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

// ─── Aviator Webview Loader ───────────────────────────────────────────────────
Widget buildAviatorWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  return _WebAviatorWebView(
    currentBalance: currentBalance,
    onBalanceUpdated: onBalanceUpdated,
  );
}

class _WebAviatorWebView extends StatefulWidget {
  final double currentBalance;
  final ValueChanged<double> onBalanceUpdated;

  const _WebAviatorWebView({
    required this.currentBalance,
    required this.onBalanceUpdated,
  });

  @override
  State<_WebAviatorWebView> createState() => _WebAviatorWebViewState();
}

class _WebAviatorWebViewState extends State<_WebAviatorWebView> {
  late final String _viewType;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _viewType = 'aviator-game-iframe-${DateTime.now().microsecondsSinceEpoch}';

    const gameUrl = 'assets/assets/games/Aviator/index.html';

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) {
        return html.IFrameElement()
          ..src = '$gameUrl?balance=${widget.currentBalance}&v=${DateTime.now().millisecondsSinceEpoch}'
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.display = 'block'
          ..style.background = '#0a0b0c';
      },
    );

    _messageSubscription = html.window.onMessage.listen((event) {
      try {
        Map<String, dynamic> data;
        if (event.data is String) {
          data = jsonDecode(event.data as String) as Map<String, dynamic>;
        } else if (event.data is Map) {
          data = Map<String, dynamic>.from(event.data as Map);
        } else {
          return;
        }
        if (data['type'] == 'updateBalance') {
          final double newBal = (data['balance'] as num).toDouble();
          widget.onBalanceUpdated(newBal);
        } else if (data['type'] == 'exitGame') {
          Navigator.of(context).pop();
        }
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: HtmlElementView(viewType: _viewType),
    );
  }
}

