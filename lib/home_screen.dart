import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'widgets/svg_webview.dart';
import 'widgets/rive_player.dart';
import 'widgets/animated_icon.dart';
import 'widgets/minimal_button.dart';
import 'widgets/animated_splash_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _svgPath = '/sdcard/Pictures/svg';
  String _rivPath = '/sdcard/Pictures/riv';
  bool _darkBackground = false;

  List<File> _phoneSvgs = [];
  List<File> _phoneRivs = [];
  List<String> _assetSvgs = [];
  List<String> _assetRives = [];
  bool _loadingPhone = false;

  final Set<String> _selected = {};

  @override
  void initState() {
    super.initState();
    _loadAssetSvgs();
    _loadAssetRives();
  }

  Future<void> _loadAssetSvgs() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _assetSvgs = manifest.listAssets()
          .where((key) => key.startsWith('assets/svg/') && key.endsWith('.svg'))
          .toList()
        ..sort();
    } catch (_) {
      _assetSvgs = [
        'assets/svg/animated_00.svg',
        'assets/svg/animated_01.svg',
        'assets/svg/atardecer_00.svg',
        'assets/svg/car_animated_04.svg',
        'assets/svg/car-lite.svg',
        'assets/svg/index-octonaut.svg',
        'assets/svg/jellyfish.svg',
        'assets/svg/simbol_git.svg',
      ];
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadAssetRives() async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _assetRives = manifest.listAssets()
          .where((key) => key.startsWith('assets/riv/') && key.endsWith('.riv'))
          .toList()
        ..sort();
    } catch (_) {
      _assetRives = [
        'assets/riv/animated-button.riv',
        'assets/riv/chat-icon.riv',
        'assets/riv/confetti-celebration.riv',
      ];
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadPhoneFiles(String type) async {
    setState(() => _loadingPhone = true);
    try {
      final dir = type == 'svg'
          ? Directory(_svgPath)
          : Directory(_rivPath);

      if (await dir.exists()) {
        final files = dir.listSync().whereType<File>().toList();
        if (type == 'svg') {
          _phoneSvgs = files
              .where((f) => f.path.toLowerCase().endsWith('.svg'))
              .toList();
        } else {
          _phoneRivs = files
              .where((f) => f.path.toLowerCase().endsWith('.riv'))
              .toList();
        }
      }
    } catch (_) {}
    if (mounted) setState(() => _loadingPhone = false);
  }

  void _showSettings() {
    final svgCtrl = TextEditingController(text: _svgPath);
    final rivCtrl = TextEditingController(text: _rivPath);
    bool darkBg = _darkBackground;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24, right: 24, top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).viewPadding.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Configuración',
                    style: Theme.of(ctx).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  TextField(
                    controller: svgCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ruta SVGs (relativa a /storage/emulated/0/)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: rivCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Ruta RIVs (relativa a /storage/emulated/0/)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Fondo oscuro'),
                    subtitle: Text(darkBg ? 'Negro' : 'Blanco'),
                    value: darkBg,
                    onChanged: (v) {
                      setSheetState(() => darkBg = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        setState(() {
                          _svgPath = svgCtrl.text;
                          _rivPath = rivCtrl.text;
                          _darkBackground = darkBg;
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Guardar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Color get _bgColor =>
      _darkBackground ? Colors.black : Colors.white;
  Color get _fgColor =>
      _darkBackground ? Colors.white : Colors.black;
  Color get _cardColor =>
      _darkBackground ? Colors.grey.shade900 : Colors.white;
  Color get _scaffoldBg =>
      _darkBackground ? Colors.black : Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: _fgColor,
        title: Text(
          'Animated App',
          style: TextStyle(
            color: _fgColor.withValues(alpha: 0.7),
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('SVG Animations'),
              const SizedBox(height: 12),
              _svgGrid(),
              const SizedBox(height: 32),
              _sectionTitle('Rive Animations'),
              const SizedBox(height: 12),
              _riveGrid(),
              const SizedBox(height: 32),
              _sectionTitle('Animated Icons'),
              const SizedBox(height: 12),
              _iconRow(),
              const SizedBox(height: 32),
              _sectionTitle('Minimal Buttons'),
              const SizedBox(height: 12),
              _buttonRow(),
              const SizedBox(height: 32),
              _sectionTitle('SVGs del teléfono'),
              const SizedBox(height: 12),
              _phoneSvgSection(),
              const SizedBox(height: 32),
              _sectionTitle('RIVs del teléfono'),
              const SizedBox(height: 12),
              _phoneRivSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: _fgColor.withValues(alpha: 0.6),
          letterSpacing: 1,
        ),
      ),
    ).animate().fadeIn().slideX(begin: -20, end: 0);
  }

  Set<String> _sectionSelected(Iterable<String> items) =>
      _selected.where((p) => items.any((i) => i == p)).toSet();

  Widget _buildGridItem({
    required String id,
    required Set<String> sectionSelected,
    required int index,
    required Widget child,
    double width = 140,
    EdgeInsets padding = const EdgeInsets.all(16),
    VoidCallback? onTap,
  }) {
    final isSelected = sectionSelected.contains(id);
    final opacity = sectionSelected.isNotEmpty ? (isSelected ? 1.0 : 0.35) : 1.0;

    return GestureDetector(
      onTap: onTap ?? () => setState(() {
        if (isSelected) { _selected.remove(id); }
        else { _selected.add(id); }
      }),
      child: AnimatedOpacity(
        opacity: opacity,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms, delay: (index * 150).ms).slideX(
          begin: 30,
          end: 0,
          duration: 500.ms,
        );
  }

  Widget _svgGrid() {
    final sectionSelected = _sectionSelected(_assetSvgs);
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _assetSvgs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final path = _assetSvgs[index];
          final isAnimated = path == 'assets/svg/animated_00.svg';
          return _buildGridItem(
            id: path,
            sectionSelected: sectionSelected,
            index: index,
            onTap: () => _showSvgFullscreen(path),
            child: isAnimated
                ? const AnimatedSplashSvg(width: 100, height: 100)
                : _AnimatedSvgViewer(assetPath: path, width: 100, height: 100),
          );
        },
      ),
    );
  }

  Widget _riveGrid() {
    final sectionSelected = _sectionSelected(_assetRives);
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _assetRives.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final path = _assetRives[index];
          return _buildGridItem(
            id: path,
            sectionSelected: sectionSelected,
            index: index,
            padding: const EdgeInsets.all(8),
            onTap: () => _showRiveFullscreen(path),
            child: RivePlayerWidget(
              assetPath: path,
              width: 120,
              height: 120,
              onTap: () => _showRiveFullscreen(path),
            ),
          );
        },
      ),
    );
  }

  Widget _phoneSvgSection() {
    return Column(
      children: [
        if (_phoneSvgs.isEmpty && !_loadingPhone)
          _buildPickButton(
            icon: Icons.folder_open,
            label: 'Cargar SVGs del teléfono',
            onTap: () => _loadPhoneFiles('svg'),
          ),
        if (_loadingPhone)
          const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          )),
        if (_phoneSvgs.isNotEmpty) ...[
          _buildPickButton(
            icon: Icons.refresh,
            label: 'Cambiar carpeta SVGs',
            onTap: () => _loadPhoneFiles('svg'),
          ),
          const SizedBox(height: 8),
          _buildSelectionToolbar(
            sectionSelected: _sectionSelected(_phoneSvgs.map((f) => f.path)),
            allFiles: _phoneSvgs,
            sectionLabel: 'SVG',
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _phoneSvgs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final file = _phoneSvgs[index];
                return _buildGridItem(
                  id: file.path,
                  sectionSelected: _sectionSelected(_phoneSvgs.map((f) => f.path)),
                  index: index,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: SvgPicture.file(
                          file,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        file.path.split('/').last,
                        style: TextStyle(
                          fontSize: 10,
                          color: _fgColor.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _phoneRivSection() {
    return Column(
      children: [
        if (_phoneRivs.isEmpty && !_loadingPhone)
          _buildPickButton(
            icon: Icons.folder_open,
            label: 'Cargar RIVs del teléfono',
            onTap: () => _loadPhoneFiles('riv'),
          ),
        if (_loadingPhone)
          const Center(child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          )),
        if (_phoneRivs.isNotEmpty) ...[
          _buildPickButton(
            icon: Icons.refresh,
            label: 'Cambiar carpeta RIVs',
            onTap: () => _loadPhoneFiles('riv'),
          ),
          const SizedBox(height: 8),
          _buildSelectionToolbar(
            sectionSelected: _sectionSelected(_phoneRivs.map((f) => f.path)),
            allFiles: _phoneRivs,
            sectionLabel: 'RIV',
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _phoneRivs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final file = _phoneRivs[index];
                return _buildGridItem(
                  id: file.path,
                  sectionSelected: _sectionSelected(_phoneRivs.map((f) => f.path)),
                  index: index,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: RivePlayerWidget(
                          filePath: file.path,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        file.path.split('/').last,
                        style: TextStyle(
                          fontSize: 10,
                          color: _fgColor.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPickButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: _fgColor,
          side: BorderSide(color: _fgColor.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionToolbar({
    required Set<String> sectionSelected,
    required List<File> allFiles,
    required String sectionLabel,
  }) {
    if (allFiles.isEmpty) return const SizedBox.shrink();
    final allSelected = sectionSelected.length == allFiles.length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: () => setState(() {
              if (allSelected) {
                _selected.removeWhere((p) => allFiles.any((f) => f.path == p));
              } else {
                for (final f in allFiles) {
                  _selected.add(f.path);
                }
              }
            }),
            style: OutlinedButton.styleFrom(
              foregroundColor: _fgColor,
              side: BorderSide(color: _fgColor.withValues(alpha: 0.3)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              textStyle: const TextStyle(fontSize: 12),
            ),
            child: Text(allSelected ? 'Deselect All' : 'Select All'),
          ),
          if (sectionSelected.isNotEmpty) ...[
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _deleteSelected(sectionSelected, allFiles, sectionLabel),
              icon: const Icon(Icons.delete_outline, size: 18),
              label: const Text('Delete', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red.withValues(alpha: 0.4)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () => _shareSelected(sectionSelected),
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share', style: TextStyle(fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: _fgColor,
                side: BorderSide(color: _fgColor.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _deleteSelected(
    Set<String> sectionSelected,
    List<File> allFiles,
    String sectionLabel,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete files'),
        content: Text(
          'Delete $sectionSelected.length $sectionLabel file(s)?\nThis cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    for (final f in allFiles) {
      if (sectionSelected.contains(f.path)) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
    if (mounted) {
      setState(() {
        _selected.removeAll(sectionSelected);
        _phoneSvgs.removeWhere((f) => sectionSelected.contains(f.path));
        _phoneRivs.removeWhere((f) => sectionSelected.contains(f.path));
      });
      _showSnackBar('Deleted ${sectionSelected.length} file(s)');
    }
  }

  Future<void> _shareSelected(Set<String> paths) async {
    final files = paths.map((p) => XFile(p)).toList();
    await Share.shareXFiles(files, text: 'Shared from Animated App');
  }

  Widget _iconRow() {
    final icons = [
      ('assets/icons/home.svg', 'Home'),
      ('assets/icons/search.svg', 'Search'),
      ('assets/icons/heart.svg', 'Heart'),
      ('assets/icons/star.svg', 'Star'),
      ('assets/icons/user.svg', 'User'),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: icons.map((entry) {
        return AnimatedIconWidget(
          assetPath: entry.$1,
          size: 36,
          color: _fgColor,
          onTap: () => _showIconFullscreen(entry.$1, entry.$2),
        );
      }).toList(),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 20, end: 0);
  }

  void _showIconFullscreen(String assetPath, String label) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _fgColor,
            elevation: 0,
            title: Text(label),
          ),
          body: SafeArea(
            child: Center(
              child: _AnimatedSvgViewer(assetPath: assetPath, width: 200, height: 200),
            ),
          ),
        ),
      ),
    );
  }

  void _showSvgFullscreen(String path) {
    final name = path.split('/').last.replaceAll('.svg', '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _fgColor,
            elevation: 0,
            title: Text(name),
          ),
          body: SafeArea(
            child: Center(
              child: path == 'assets/svg/animated_00.svg'
                  ? const AnimatedSplashSvg(width: double.infinity, height: double.infinity)
                  : _AnimatedSvgViewer(assetPath: path, width: double.infinity, height: double.infinity),
            ),
          ),
        ),
      ),
    );
  }

  void _showRiveFullscreen(String path) {
    final name = path.split('/').last.replaceAll('.riv', '');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _fgColor,
            elevation: 0,
            title: Text(name),
          ),
          body: SafeArea(
            child: Center(
              child: RivePlayerWidget(
                assetPath: path,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonRow() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MinimalButton(
          iconPath: 'assets/icons/heart.svg',
          label: 'Favoritos',
          onTap: () => _showSnackBar('Favoritos'),
        ),
        MinimalButton(
          iconPath: 'assets/icons/star.svg',
          label: 'Destacados',
          onTap: () => _showSnackBar('Destacados'),
        ),
        MinimalButton(
          iconPath: 'assets/icons/settings.svg',
          label: 'Ajustes',
          onTap: () => _showSettings(),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 20, end: 0);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _AnimatedSvgViewer extends StatefulWidget {
  final String assetPath;
  final double width;
  final double height;

  const _AnimatedSvgViewer({
    required this.assetPath,
    this.width = 300,
    this.height = 300,
  });

  @override
  State<_AnimatedSvgViewer> createState() => _AnimatedSvgViewerState();
}

class _AnimatedSvgViewerState extends State<_AnimatedSvgViewer> {
  String? _svgContent;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_AnimatedSvgViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _load();
    }
  }

  Future<void> _load() async {
    try {
      final content = await rootBundle.loadString(widget.assetPath);
      if (mounted) setState(() => _svgContent = content);
    } catch (_) {
      if (mounted) setState(() => _svgContent = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_svgContent == null) {
      return const SizedBox(width: 300, height: 300, child: Center(child: CircularProgressIndicator(strokeWidth: 2)));
    }
    return SvgWebView(svgContent: _svgContent!, width: widget.width, height: widget.height);
  }
}
