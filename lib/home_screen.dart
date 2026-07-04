import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/svg_viewer.dart';
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
  String _svgPath = 'Pictures/svg';
  String _rivPath = 'Pictures/riv';
  bool _darkBackground = false;

  List<File> _phoneSvgs = [];
  List<File> _phoneRivs = [];
  List<String> _assetRives = [];
  bool _loadingPhone = false;

  @override
  void initState() {
    super.initState();
    _loadAssetRives();
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
          ? Directory('/storage/emulated/0/$_svgPath')
          : Directory('/storage/emulated/0/$_rivPath');

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
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
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
      body: SingleChildScrollView(
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

  Widget _svgGrid() {
    final svgs = <_SvgItem>[
      _SvgItem('assets/svg/animated_00.svg', 'Animated 00', true),
      _SvgItem('assets/svg/atom-portal.svg', 'Atom Portal', false),
      _SvgItem('assets/svg/sample.svg', 'Sample', false),
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: svgs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = svgs[index];
          return GestureDetector(
            onTap: () => _showSvgFullscreen(item),
            child: Container(
              width: 140,
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
              padding: const EdgeInsets.all(16),
              child: item.animated
                  ? const AnimatedSplashSvg(width: 100, height: 100)
                  : SvgViewer(
                      assetPath: item.path,
                      width: 100,
                      height: 100,
                    ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: (index * 150).ms).slideX(
                begin: 30,
                end: 0,
                duration: 500.ms,
              );
        },
      ),
    );
  }

  void _showSvgFullscreen(_SvgItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: _fgColor,
            elevation: 0,
            title: Text(item.label),
          ),
          body: Center(
            child: item.animated
                ? const AnimatedSplashSvg(width: 300, height: 300)
                : SvgViewer(
                    assetPath: item.path,
                    width: 300,
                    height: 300,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _riveGrid() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _assetRives.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final path = _assetRives[index];
          final label = path.split('/').last.replaceAll('.riv', '');
          return GestureDetector(
            onTap: () => _showRiveFullscreen(path, label),
            child: Container(
              width: 140,
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
              padding: const EdgeInsets.all(8),
              child: RivePlayerWidget(
                assetPath: path,
                width: 120,
                height: 120,
              ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: (index * 150).ms).slideX(
                begin: 30,
                end: 0,
                duration: 500.ms,
              );
        },
      ),
    );
  }

  void _showRiveFullscreen(String path, String label) {
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
          body: Center(
            child: RivePlayerWidget(
              assetPath: path,
              width: 300,
              height: 300,
            ),
          ),
        ),
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
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _phoneSvgs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final file = _phoneSvgs[index];
                final name = file.path.split('/').last;
                return GestureDetector(
                  onTap: () => _showPhoneSvgFullscreen(file, name),
                  child: Container(
                    width: 140,
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
                          name,
                          style: TextStyle(
                            fontSize: 10,
                            color: _fgColor.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _showPhoneSvgFullscreen(File file, String label) {
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
          body: Center(
            child: SvgPicture.file(
              file,
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
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
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _phoneRivs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final file = _phoneRivs[index];
                final name = file.path.split('/').last;
                return GestureDetector(
                  onTap: () => _showPhoneRivFullscreen(file, name),
                  child: Container(
                    width: 140,
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
                          name,
                          style: TextStyle(
                            fontSize: 10,
                            color: _fgColor.withValues(alpha: 0.5),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  void _showPhoneRivFullscreen(File file, String label) {
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
          body: Center(
            child: RivePlayerWidget(
              filePath: file.path,
              width: 300,
              height: 300,
            ),
          ),
        ),
      ),
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
          body: Center(
            child: SvgViewer(
              assetPath: assetPath,
              width: 200,
              height: 200,
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

class _SvgItem {
  final String path;
  final String label;
  final bool animated;

  const _SvgItem(this.path, this.label, this.animated);
}
