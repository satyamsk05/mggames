# Workspace Coding & Architecture Guidelines

This document outlines the coding standards, architectural rules, and WebView communication protocols for this Flutter game integration project. All modifications and additions must strictly adhere to these guidelines.

---

## 1. Codebase Architecture & File Size Limits
*   **Decouple Bloated Files**: Do not let any single Dart file exceed **400 lines**. The current `main.dart` is too large. All widgets, custom screens, stateful models, or UI frames must be extracted to modular files under:
    *   `lib/screens/` (for page/dashboard widgets)
    *   `lib/widgets/` (for reusable UI elements like buttons, frames, dialogs)
    *   `lib/models/` (for data structures and schemas)
    *   `lib/services/` (for API, configuration, and storage logic)
*   **Import Optimization**: Use absolute package imports (`package:bcgame/...`) instead of deeply nested relative imports, except when importing from the same subfolder.

---

## 2. WebView Platform Abstractions
*   **Conditionally Loaded WebViews**: The project must support both web and mobile environments cleanly. Always implement web view helpers using the platform conditional import pattern:
    ```dart
    import 'webview_helper/webview_helper_stub.dart'
        if (dart.library.html) 'webview_helper/webview_helper_web.dart'
        if (dart.library.io) 'webview_helper/webview_helper_mobile.dart';
    ```
*   **Uniform Function Signatures**: Any new game WebView launcher helper must conform to the signature:
    ```dart
    Widget build<GameName>WebView(
      BuildContext context,
      double currentBalance,
      ValueChanged<double> onBalanceUpdated,
    )
    ```
*   **Stub Maintenance**: Always ensure `webview_helper_stub.dart` implements a default fallback (e.g., returning `const SizedBox.shrink()`) matching the above function signature.

---

## 3. WebView JavaScript Bridge Protocol
*   **Channel Registration**: Use the unified channel name `'FlutterBridge'` for message passing. Avoid game-specific channel names.
*   **HTML/JS Side (Sending Messages)**:
    *   To support both Web (iframe postMessage) and Mobile (JavaScriptChannel), the JS side should use a unified messenger function:
        ```javascript
        function sendToFlutter(type, data = {}) {
            // Web Platform
            window.parent.postMessage(JSON.stringify({ type, ...data }), '*');
            
            // Mobile Platform (using FlutterBridge channel)
            if (window.FlutterBridge) {
                window.FlutterBridge.postMessage(JSON.stringify({ type, ...data }));
            }
        }
        ```
*   **Dart Side (Receiving Messages)**:
    *   Mobile: Set up the channel via `..addJavaScriptChannel('FlutterBridge', onMessageReceived: ...)` on the `WebViewController`.
    *   Web: Listen to `html.window.onMessage` StreamSubscription.
    *   Both environments must support JSON parsing fallbacks. If JSON parsing fails, attempt a direct string/double parse to gracefully handle legacy message structures:
        ```dart
        try {
          final Map<String, dynamic> data = jsonDecode(message);
          if (data['type'] == 'exitGame') {
            Navigator.of(context).pop();
          } else if (data['type'] == 'updateBalance') {
            final double? newBal = double.tryParse(data['balance'].toString());
            if (newBal != null) onBalanceUpdated(newBal);
          }
        } catch (_) {
          final double? newBal = double.tryParse(message);
          if (newBal != null) onBalanceUpdated(newBal);
        }
        ```
*   **Initial Balance Sync**: Always trigger initial balance sync on page loading completion (`onPageFinished` event on Mobile WebView, or via URL parameter/postMessage initialization on Web WebView) by calling:
    ```javascript
    window.setBalanceFromFlutter(balance);
    ```

---

## 4. Assets & Games Registration
*   **Folder Names**: Maintain the folder structures under `assets/games/` exactly as registered in `pubspec.yaml`:
    *   Mines: `assets/games/mines/`
    *   Crash (Crush): `assets/games/Crush/`
    *   Aviator: `assets/games/Aviator/`
*   **Caching/Bust**: When loading local assets on Web platform, append a cache-busting timestamp parameter to the URL to avoid stale resources:
    ```dart
    ..src = '$gameUrl?balance=$currentBalance&v=${DateTime.now().millisecondsSinceEpoch}'
    ```

---

## 5. Development & Verification Rules
*   **Hot Reload Protocol**: When modifying Dart/Flutter source files, proactively check if a Dart Tooling Daemon (DTD) is available. Run `hot_reload` or appropriate tooling to push files instantly to the running app.
*   **Accessibility (a11y)**: When designing or updating components, use standard semantic components, proper screen reader labels, and maintain good color contrast ratios.
