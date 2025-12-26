import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/data/onboarding_model.dart';
import 'package:testtt/presentation/screens/sign_up.dart';
import 'package:testtt/presentation/widgets/button_widget.dart';
import 'package:testtt/providers/provider_onboarding.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<OnboardingData> _onboardingPages = OnboardingData.onboardingPages;
  bool _imagesPrecached = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initializeAnimations();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache images after context is available
    if (!_imagesPrecached) {
      _precacheImages();
      _imagesPrecached = true;
    }
  }

  void _precacheImages() {
    for (var page in _onboardingPages) {
      precacheImage(AssetImage(page.illustration), context);
    }
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int index, OnboardingProvider provider) {
    provider.setPage(index);
    _animationController.reset();
    _animationController.forward();
  }

  void _handleSkip(OnboardingProvider provider) {
    provider.setPage(_onboardingPages.length - 1);
    _pageController.animateToPage(
      _onboardingPages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _handleNext(OnboardingProvider provider) {
    if (provider.isLastPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );
    } else {
      provider.nextPage();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.whitecolor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<OnboardingProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                // Skip Button
                _buildSkipButton(provider),

                // PageView with Images
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingPages.length,
                    onPageChanged: (index) =>
                        _handlePageChanged(index, provider),
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildOnboardingPage(_onboardingPages[index]);
                    },
                  ),
                ),

                // Bottom Section: Dots + Next Button
                _buildBottomSection(provider),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSkipButton(OnboardingProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () => _handleSkip(provider),
          style: TextButton.styleFrom(
            foregroundColor: ColorsManager.greycolor,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            minimumSize: Size(60.w, 36.h),
          ),
          child: Text(
            'Skip',
            style: TextStyles.body.copyWith(
              color: ColorsManager.greycolor,
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SVG Illustration
              _buildSvgIllustration(data),

              SizedBox(height: 56.h),

              // Title
              Text(
                data.title,
                style: TextStyles.heading1.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.primaryDark,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 16.h),

              // Subtitle
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  data.subtitle,
                  style: TextStyles.body.copyWith(
                    fontSize: 16.sp,
                    color: ColorsManager.greycolor,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSvgIllustration(OnboardingData data) {
    return SizedBox(
      height: 320.h,
      width: double.infinity,
      child: Image.asset(
        data.illustration,
        height: 320.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(
            Icons.coffee,
            size: 120.sp,
            color: ColorsManager.primary.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection(OnboardingProvider provider) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
      child: Row(
        children: [
          // Page Indicator (Dots)
          SmoothPageIndicator(
            controller: _pageController,
            count: _onboardingPages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: ColorsManager.primary,
              dotColor: ColorsManager.softGrey,
              dotHeight: 10.h,
              dotWidth: 10.w,
              spacing: 8.w,
              expansionFactor: 4,
            ),
          ),

          SizedBox(width: 16.w),

          // Next/Get Started Button
          Expanded(
            child: ButtonWidget(
              title: provider.isLastPage ? "Get Started" : "Next",
              onTap: () => _handleNext(provider),
              height: 56.h,
            ),
          ),
        ],
      ),
    );
  }
}
