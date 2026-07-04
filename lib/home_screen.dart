import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'widgets/svg_viewer.dart';
import 'widgets/rive_player.dart';
import 'widgets/animated_icon.dart';
import 'widgets/minimal_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Animated App',
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w300,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
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
            _buttonRow(context),
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
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.black45,
          letterSpacing: 1,
        ),
      ),
    ).animate().fadeIn().slideX(begin: -20, end: 0);
  }

  Widget _svgGrid() {
    final svgs = [
      'assets/svg/animated_00.svg',
      'assets/svg/atom-portal.svg',
      'assets/svg/sample.svg',
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: svgs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: SvgViewer(
              assetPath: svgs[index],
              width: 100,
              height: 100,
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

  Widget _riveGrid() {
    final rives = [
      'assets/riv/animated-button.riv',
      'assets/riv/chat-icon.riv',
      'assets/riv/confetti-celebration.riv',
    ];

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: rives.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Container(
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
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
              assetPath: rives[index],
              width: 120,
              height: 120,
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
          color: Colors.black54,
          onTap: () => _showFullscreen(context, entry.$1, entry.$2),
        );
      }).toList(),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 20, end: 0);
  }

  void _showFullscreen(BuildContext context, String assetPath, String label) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
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

  Widget _buttonRow(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        MinimalButton(
          iconPath: 'assets/icons/heart.svg',
          label: 'Favoritos',
          onTap: () => _showSnackBar(context, 'Favoritos'),
        ),
        MinimalButton(
          iconPath: 'assets/icons/star.svg',
          label: 'Destacados',
          onTap: () => _showSnackBar(context, 'Destacados'),
        ),
        MinimalButton(
          iconPath: 'assets/icons/settings.svg',
          label: 'Ajustes',
          onTap: () => _showSnackBar(context, 'Ajustes'),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 300.ms).slideY(begin: 20, end: 0);
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
