import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/blood_drop_logo.dart';
import 'main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _backgroundColor = Color(0xFF1B2433);
  static const _progressTrackColor = Color(0xFF3A4454);
  static const _progressFillColor = Color(0xFF2DD4BF);

  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: _backgroundColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _progress = Tween<double>(begin: 0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BloodDropLogo(size: 78),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Blood Sugar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          height: 1.05,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              left: 48,
              right: 48,
              bottom: 36,
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final fillWidth =
                          constraints.maxWidth * _progress.value.clamp(0.0, 1.0);

                      return SizedBox(
                        height: 3,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _progressTrackColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 120),
                              width: fillWidth,
                              decoration: BoxDecoration(
                                color: _progressFillColor,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
