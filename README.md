# animated_app

Galería de animaciones SVG y Rive para Flutter, con soporte de archivos locales y renderizado vía WebView.

## Features

- Galería de SVGs animados (con soporte CSS `@keyframes` y `transform`) renderizados en WebView
- Galería de Rive (`.riv`) — nativo para v7, WebView + runtime JS para v6
- Carga de SVGs y RIVs desde el almacenamiento del teléfono
- Splash screen animada
- Tema Material 3 con Google Fonts (Poppins)
- Rotación libre, sin restricciones de orientación

## Stack

- Flutter + Dart
- `rive` (nativo para .riv v7)
- `webview_flutter` (SVGs animados y .riv v6)
- `flutter_animate` (transiciones)
- `file_picker` (carga de archivos locales)

## Docs

- `docs/ARCHITECTURE.md` — estructura del proyecto
- `docs/RULES.md` — reglas de versionado y git
- `docs/SKILLS.md` — convenciones de código
- `docs/CHANGELOG.md` — historial de cambios
- `RULES.md` — reglas de oro del proyecto
- `TODO.md` — tareas pendientes
