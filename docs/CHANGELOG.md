# Changelog

## [1.0.0] — 2026-07-04

### Added
- Initial release
- Splash screen with animated SVG
- Home screen with SVG gallery, Rive animations, animated icons, and minimal buttons
- Rive animation support (`.riv` files)
- SVG rendering via `flutter_svg`
- Google Fonts (Poppins) integration
- Material 3 theme
- Custom animated icon widget with scale, rotation, opacity, and slide effects
- Minimal button widget with press feedback
- Project documentation (`RULE.md`, `ARCHITECTURE.md`, `SKILLS.md`)

## [1.0.3] — 2026-07-04

### Added
- Carga de SVGs y RIVs desde almacenamiento del teléfono (`file_picker`)
- Configuración de rutas y color de fondo
- Icono de app personalizado

### Fixed
- Modo claro por defecto al iniciar

## [unreleased]

### Added
- Soporte para .riv v6 (marty.riv, off_road_car_0_6.riv, success_check.riv) vía `RiveWebView` (WebView + runtime JS `@rive-app/canvas`)

### Changed
- **SVGs animados**: migrados de `flutter_svg` a `SvgWebView` (WebView) — soporta `@keyframes` y `transform: rotate(Xdeg)`
- **Rotación**: eliminado `setPreferredOrientations` — la app gira libremente
- **Barra de sistema Android**: eliminado `edgeToEdge`, `systemNavigationBarColor: Colors.black`, todos los bodies envueltos con `SafeArea`
- Documentación: `RULES.md`, `TODO.md`, README actualizado, ARCHITECTURE.md actualizado
