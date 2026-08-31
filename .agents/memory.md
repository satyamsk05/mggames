# BC.Game Flutter Clone - Project Memory

This memory file saves details of the project architecture, dependencies, and protocols to avoid redundant analysis.

---

## 1. Project Overview & Architecture
*   **Goal**: A Flutter mobile casino application wrapper containing local HTML5/Canvas games.
*   **Key Design**: Virtual device framing (`VirtualMobileFrame`) is used to render a mockup of a mobile screen inside larger displays (width: 360, height: 804).
*   **Key Files**:
    *   [`lib/main.dart`](file:///Users/satyamkumar/Desktop/bc.game/lib/main.dart): Entrypoint and dashboard. Currently contains the bulk of the application UI (~3,632 lines).
    *   [`lib/webview_helper/`](file:///Users/satyamkumar/Desktop/bc.game/lib/webview_helper/): Cross-platform web view loading layers.
        *   [`webview_helper_stub.dart`](file:///Users/satyamkumar/Desktop/bc.game/lib/webview_helper/webview_helper_stub.dart): Platform-independent stub.
        *   [`webview_helper_mobile.dart`](file:///Users/satyamkumar/Desktop/bc.game/lib/webview_helper/webview_helper_mobile.dart): Mobile target using `webview_flutter`.
        *   [`webview_helper_web.dart`](file:///Users/satyamkumar/Desktop/bc.game/lib/webview_helper/webview_helper_web.dart): Web target using `dart:html` `IFrameElement`.

---

## 2. Integrated Games
Local HTML5 games are stored under `assets/games/` and declared in [`pubspec.yaml`](file:///Users/satyamkumar/Desktop/bc.game/pubspec.yaml):

1.  **Mines**: Located at [`assets/games/mines/`](file:///Users/satyamkumar/Desktop/bc.game/assets/games/mines/)
2.  **Crash (Crush)**: Located at [`assets/games/Crush/`](file:///Users/satyamkumar/Desktop/bc.game/assets/games/Crush/) (Note: Case-sensitive `"Crush"`)
3.  **Aviator**: Located at [`assets/games/Aviator/`](file:///Users/satyamkumar/Desktop/bc.game/assets/games/Aviator/)

---

## 3. Communication Bridge Protocol (Flutter ⇆ JavaScript)
### Channel Name: `FlutterBridge`

#### Web Platform
*   **Initialization**: IFrame loaded with query params: `?balance=$currentBalance&v=$timestamp`.
*   **JS → Flutter**: 
    ```javascript
    window.parent.postMessage(JSON.stringify({ type: 'updateBalance', balance: newBalance }), '*');
    window.parent.postMessage(JSON.stringify({ type: 'exitGame' }), '*');
    ```
*   **Flutter → JS**: Listened via `html.window.onMessage` StreamSubscription.

#### Mobile Platform
*   **Initialization**: Balance synced on `onPageFinished` via controller injection:
    ```javascript
    window.setBalanceFromFlutter(balance);
    ```
*   **JS → Flutter**:
    ```javascript
    if (window.FlutterBridge) {
        window.FlutterBridge.postMessage(JSON.stringify({ type: 'updateBalance', balance: newBalance }));
    }
    ```
*   **Flutter → JS**: Listened via WebViewController's JavaScriptChannel `'FlutterBridge'`.

#### Protocol Fallback
Dart parses messages using `jsonDecode`. If json parsing fails, it attempts a direct double/string parsing to capture legacy direct balance messages safely.

---

## 4. Current Guidelines & Rules
*   Refactor and extract widgets out of [`main.dart`](file:///Users/satyamkumar/Desktop/bc.game/lib/main.dart) (limit Dart files to 400 lines max).
*   Follow the hot reload protocol (using DTD & `hot_reload` tool) when modifying Dart/Flutter source files.
