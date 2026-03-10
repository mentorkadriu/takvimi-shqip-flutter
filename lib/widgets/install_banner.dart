import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'install_platform_stub.dart'
    if (dart.library.js) 'install_platform_web.dart' as platform;

class InstallBanner extends StatefulWidget {
  const InstallBanner({super.key});

  @override
  State<InstallBanner> createState() => _InstallBannerState();
}

class _InstallBannerState extends State<InstallBanner> {
  bool _available = false;
  bool _dismissed = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _check();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _check());
  }

  void _check() {
    final available = platform.canInstall();
    if (available != _available) {
      setState(() => _available = available);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _install() {
    platform.triggerInstall();
    setState(() => _dismissed = true);
  }

  void _dismiss() => setState(() => _dismissed = true);

  @override
  Widget build(BuildContext context) {
    if (!_available || _dismissed) return const SizedBox.shrink();

    return Positioned(
      left: 16,
      right: 16,
      bottom: 100,
      child: _BannerCard(onInstall: _install, onDismiss: _dismiss)
          .animate()
          .slideY(begin: 1, end: 0, duration: 400.ms, curve: Curves.easeOutCubic)
          .fadeIn(duration: 300.ms),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final VoidCallback onInstall;
  final VoidCallback onDismiss;

  const _BannerCard({required this.onInstall, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.darkCard.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.emerald500.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.emerald600.withValues(alpha: 0.2),
                  border: Border.all(
                    color: AppColors.emerald400.withValues(alpha: 0.4),
                  ),
                ),
                child: const Center(
                  child: Text('☪', style: TextStyle(fontSize: 20)),
                ),
              ),
              const SizedBox(width: 12),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Instalo Aplikacionin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Shto në ekranin kryesor',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Install button
              GestureDetector(
                onTap: onInstall,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.emerald600,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Instalo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Dismiss
              GestureDetector(
                onTap: onDismiss,
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
