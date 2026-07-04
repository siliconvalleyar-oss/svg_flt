# Arquitectura — animated_app

## Stack tecnológico

| Capa | Tecnología |
|------|------------|
| Lenguaje | Dart 3.12+ |
| Framework | Flutter (Material 3) |
| Animaciones | `flutter_animate`, `rive`, `webview_flutter` |
| Fuentes | Google Fonts (Poppins) |
| Build | Gradle (Android), Xcode (iOS) |

## Estructura del proyecto

```
lib/
├── main.dart                # Entry point, configuración global
├── splash_screen.dart       # Pantalla de bienvenida (3s)
├── home_screen.dart         # Pantalla principal con galería
├── utils/
│   └── animations.dart      # Constantes de animación
└── widgets/
    ├── svg_webview.dart     # SVG animados vía WebView (soporta CSS)
    ├── rive_player.dart     # Reproductor nativo de Rive (.riv v7)
    ├── rive_webview.dart    # Rive v6 vía WebView + runtime JS
    ├── animated_icon.dart   # Icono animado (scale, rotate, opacity, slide)
    ├── animated_splash_svg.dart  # SVG animado del splash
    └── minimal_button.dart  # Botón minimalista con press effect

assets/
├── svg/     # Archivos SVG
├── riv/     # Archivos Rive (.riv + .md metadata)
└── icons/   # Iconos SVG para la UI
```

## Flujo de navegación

```
main.dart
  └─ SplashScreen (3s)
       └─ HomeScreen
            ├─ SVG Gallery (horizontal scroll)
            ├─ Rive Gallery (horizontal scroll)
            ├─ Animated Icons (row)
            └─ Minimal Buttons (wrap)
```

## Patrones

- **Widgets reutilizables**: los widgets en `lib/widgets/` son puramente visuales y reciben datos por constructor.
- **Animaciones con controller**: los widgets stateful usan `AnimationController` con `SingleTickerProviderStateMixin`.
- **Constantes centralizadas**: `utils/animations.dart` agrupa duraciones y tween values.
- **flutter_animate para entradas**: las transiciones de pantalla (fade, slide) se manejan con el paquete `flutter_animate`.
- **WebView para SVG animados**: `flutter_svg` no soporta CSS (`@keyframes`, `transform: rotate`). Los SVGs se renderizan en un WebView con motor Chrome.
- **WebView para Rive v6**: el runtime nativo `rive_native` solo soporta formato v7. Los archivos v6 se renderizan con el runtime JS de Rive en un WebView.
- **Detección automática de versión Rive**: se lee el byte `[4]` del header del .riv para decidir entre render nativo (v7) o WebView (v6).
