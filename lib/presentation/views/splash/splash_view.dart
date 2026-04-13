import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../app_shell.dart';

class SplashView extends StatefulWidget {
const  SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1600),
    );

    _scaleAnim = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    _glowAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) async {
      await Future.delayed(Duration(milliseconds: 800));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => AppShell(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 700),
          ),
        );
      }
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
      backgroundColor: AppTheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'NETFLIX',
                      style: TextStyle(
                        color: AppTheme.netflixRed,
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(
                            color: AppTheme.netflixRed.withOpacity(
                              _glowAnim.value * 0.8,
                            ),
                            blurRadius: 30 * _glowAnim.value,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),

                    FadeTransition(
                      opacity: _glowAnim,
                      child: Text(
                        'Watch Anywhere. Cancel Anytime.',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 60),

                    FadeTransition(
                      opacity: _glowAnim,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppTheme.netflixRed,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
