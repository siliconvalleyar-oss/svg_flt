# Arquitectura — animated_app

## Stack tecnológico

| Capa | Tecnología |
|------|------------|
| Lenguaje | Dart 3.12+ |
| Framework | Flutter (Material 3) |
| Animaciones | `flutter_animate`, `rive`, `flutter_svg` |
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
    ├── svg_viewer.dart      # Visualizador de SVGs
    ├── rive_player.dart     # Reproductor de Rive animations
    ├── animated_icon.dart   # Icono animado (scale, rotate, opacity, slide)
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
