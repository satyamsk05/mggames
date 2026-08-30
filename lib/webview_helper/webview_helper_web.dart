// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use, use_build_context_synchronously
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'package:flutter/material.dart';

Widget buildMinesWebView(
  BuildContext context,
  double currentBalance,
  ValueChanged<double> onBalanceUpdated,
) {
  // Register the iframe view factory once
  ui_web.platformViewRegistry.registerViewFactory(
    'mines-game-iframe',
    (int viewId) => html.IFrameElement()
      ..src = 'assets/assets/mines_game/index.html?balance=$currentBalance'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%',
  );

  // Listen to post messages from the iframe in the same window context
  html.window.onMessage.listen((event) {
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
        onBalanceUpdated(newBal);
      } else if (data['type'] == 'exitGame') {
        Navigator.of(context).pop();
      }
    } catch (_) {}
  });

  return const HtmlElementView(viewType: 'mines-game-iframe');
}
