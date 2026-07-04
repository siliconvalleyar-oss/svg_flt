# Reglas de Oro

## Stack
- Flutter + Dart
- `rive: ^0.14.9`
- `webview_flutter: ^4.10.0`

## Renderizado
- **SVGs animados** → `SvgWebView` (WebView). `flutter_svg` no soporta `@keyframes` ni `transform: rotate(Xdeg)`.
- **.riv v7** → `RiveWidgetBuilder` nativo.
- **.riv v6** (marty.riv, off_road_car_0_6.riv, success_check.riv) → `RiveWebView` (WebView + runtime JS `@rive-app/canvas@2.23.0` desde unpkg.com).
- La versión del .riv se detecta automáticamente leyendo el byte `[4]` del header.

## Pantalla
- Rotación libre: no usar `setPreferredOrientations`.
- Sin `edgeToEdge`. `systemNavigationBarColor: Colors.black` opaco.
- Todos los bodies envueltos con `SafeArea`.

## Android
- Permiso `INTERNET` necesario para WebView.
