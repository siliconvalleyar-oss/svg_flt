# TODO — animated_app

## ✅ Done
- Renderizado SVG con CSS animado vía WebView
- Rive nativo (v7) + RiveWebView (v6 vía JS runtime CDN)
- Detección automática de versión Rive (byte [4] del header)
- Rotación libre, sin edgeToEdge, SafeArea en todos los bodies
- Carga de SVGs/RIVs desde almacenamiento del teléfono
- Settings: fondo oscuro, rutas personalizadas
- Selección visual (tapped resaltan, resto se opaca)
- Documentación: README, ARCHITECTURE, CHANGELOG, SKILLS, RULES, TODO

## High Priority — Operaciones por lote (selection)
- [ ] Botones Select All / Deselect All por sección
- [ ] Borrar archivos seleccionados (teléfono) con confirmación dialog
- [ ] Compartir archivos seleccionados

## Medium Priority — UX
- [ ] Vista de grilla vs. lista (toggle)
- [ ] Ordenar por nombre/fecha/tamaño
- [ ] Barra de búsqueda/filtro

## Future
- [ ] Cachear runtime JS de Rive localmente (assets bundle)
- [ ] Playback controls para Rive (play/pause/restart, velocidad)
- [ ] Favoritos (marcar archivos locales como favoritos)
- [ ] Exportar/compartir frames individuales de Rive
- [ ] Multi-idioma (es/en)
- [ ] Modo oscuro automático según sistema
- [ ] Tests unitarios
