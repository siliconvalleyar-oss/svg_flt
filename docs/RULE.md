# Reglas de Oro — Build, Versionado y Push

## Versión y Tag

- Cada cambio debe incrementar la versión.
- La versión se define ÚNICAMENTE en `VERSION` (formato semver: `X.Y.Z`).
- Cada push a `main` debe llevar un tag `vX.Y.Z` que coincida EXACTAMENTE con el contenido de `VERSION`.

```
VERSION = 1.0.0  →  tag v1.0.0
```

## Flujo de trabajo

```bash
# 1. Hacer los cambios necesarios

# 2. Incrementar versión
echo "1.1.0" > VERSION

# 3. Compilar y verificar
flutter clean
flutter pub get
flutter analyze
flutter test
flutter build apk --debug   # o flutter run

# 4. Commit con el mensaje incluyendo la versión
git add -A
git commit -m "feat: descripción del cambio (v$(cat VERSION))"

# 5. Taggear con la misma versión
git tag v$(cat VERSION)

# 6. Pushear commit + tags
git push origin main --tags
```

## Reglas

| Regla | Descripción |
|-------|-------------|
| R1 | `VERSION` siempre refleja el **próximo tag** a pushear |
| R2 | No pushear sin tag |
| R3 | El tag DEBE coincidir con `VERSION` |
| R4 | No sobrescribir tags existentes |
| R5 | `flutter analyze` debe pasar antes de commitear |
| R6 | `flutter test` debe pasar antes de pushear |

## Convención de commits

| Tipo | Ejemplo |
|------|---------|
| `feat:` | `feat: splash screen con animación (v1.1.0)` |
| `fix:` | `fix: crash en Android 12 (v1.1.1)` |
| `chore:` | `chore: actualizar dependencias (v1.2.0)` |
| `refactor:` | `refactor: extraer widget de botón (v1.3.0)` |
| `docs:` | `docs: actualizar arquitectura (v1.0.1)` |
