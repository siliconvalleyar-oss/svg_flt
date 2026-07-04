# Skills — animated_app

## Dart & Flutter

- Usar **Material 3** (`useMaterial3: true`)
- Preferir `StatelessWidget` cuando no haya estado mutable
- Usar `AnimationController` con `SingleTickerProviderStateMixin` para animaciones custom
- No mezclar `flutter_animate` con Animation Controller en el mismo widget
- Los assets SVG deben ir en `assets/svg/` o `assets/icons/`
- Los assets Rive deben ir en `assets/riv/`

## Versionado

- Seguir estrictamente `RULE.md`
- `VERSION` es la fuente de verdad para tags
- Incrementar `VERSION` antes de cada commit

## Estilo de código

- Sin comentarios en código (el código debe ser auto-documentado)
- Nombres en inglés para clases, métodos y variables
- Usar `const` siempre que sea posible
- Seguir `flutter_lints` (`analysis_options.yaml`)

## Testing

- `flutter test` antes de pushear
- Los tests van en `test/`
- Usar `flutter_test` del SDK

## Build

```bash
# Android debug
flutter build apk --debug

# Android release
flutter build apk --release

# iOS (solo macOS)
flutter build ios --debug --no-codesign

# Run en dispositivo conectado
flutter run
```
