import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/presentation/screens/onboarding_screen.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AnimationController _textAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  bool _isVideoInitialized = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeTextAnimation();
    _scheduleNavigation();
  }

  void _initializeVideo() {
    _videoController =
        VideoPlayerController.asset('assets/videos/splash_intro.mp4')
          ..initialize().then((_) {
            if (mounted) {
              setState(() {
                _isVideoInitialized = true;
              });
              _videoController.play();
              _videoController.setLooping(false);
            }
          }).catchError((error) {
            debugPrint('Video initialization error: $error');

            if (mounted) {
              setState(() {
                _isVideoInitialized = false;
              });
            }
          });
  }

  /// Initialize text animation (starts at 1.5s)
  void _initializeTextAnimation() {
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Fade: 0 → 1
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Slide: slight upward motion (14px → 0)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.03), // ~14px on typical screen
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Scale: micro-scale (0.96 → 1.0)
    _scaleAnimation = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _textAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start text animation at 1.5s
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });
  }

  /// Schedule navigation to next screen at 3.0s
  void _scheduleNavigation() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted && !_hasNavigated) {
        _hasNavigated = true;
        _navigateToNextScreen();
      }
    });
  }

  /// Navigate with clean fade transition
  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return OnboardingScreen();
        },
        transitionDuration: const Duration(milliseconds: 400),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _videoController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      body: SafeArea(
        child: Stack(
          children: [
            // Video Layer (centered, full-width)
            Center(
              child: _isVideoInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 400.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.primary,
                          strokeWidth: 2.5,
                        ),
                      ),
                    ),
            ),

            // Brand Name Layer (bottom-centered, animated)
            Positioned(
              left: 0,
              right: 0,
              bottom: 120.h,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Text(
                      'Park&Pick',
                      textAlign: TextAlign.center,
                      style: TextStyles.heading1.copyWith(
                        color: ColorsManager.primary,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
