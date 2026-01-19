import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:testtt/core/theme/colors_manager.dart';
import 'package:testtt/core/theme/text_styles.dart';
import 'package:testtt/data/onboarding_model.dart';
import 'package:testtt/presentation/cubits/onboarding/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _scaleController;
  late AnimationController _floatController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

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
    // Scale animation for images
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeOutBack,
      ),
    );

    // Float animation for continuous movement
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scaleController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _handlePageChanged(int index, OnboardingCubit cubit) {
    cubit.setPage(index);
    _scaleController.reset();
    _scaleController.forward();
  }

  void _handleNext(OnboardingCubit cubit, OnboardingState state) {
    if (state.isLastPage) {
      cubit.completeOnboarding();
      context.go('/signup');
    } else {
      cubit.nextPage();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.primary,
      body: SafeArea(
        child: BlocBuilder<OnboardingCubit, OnboardingState>(
          builder: (context, state) {
            final cubit = context.read<OnboardingCubit>();
            return Stack(
              children: [
                // Decorative circles
                _buildDecorativeCircles(),

                // Main content
                Column(
                  children: [
                    SizedBox(height: 40.h),

                    // Logo placeholder at top
                    _buildLogo(),

                    SizedBox(height: 20.h),

                    // Page indicator dots
                    _buildPageIndicator(state),

                    SizedBox(height: 40.h),

                    // PageView with content
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _onboardingPages.length,
                        onPageChanged: (index) =>
                            _handlePageChanged(index, cubit),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildOnboardingPage(_onboardingPages[index]);
                        },
                      ),
                    ),

                    // Bottom button
                    _buildBottomButton(cubit, state),

                    SizedBox(height: 40.h),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        // Large circle top
        Positioned(
          top: -100.h,
          right: -50.w,
          child: Container(
            width: 300.w,
            height: 300.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManager.whitecolor.withOpacity(0.1),
            ),
          ),
        ),
        // Medium circle
        Positioned(
          top: 100.h,
          left: -80.w,
          child: Container(
            width: 200.w,
            height: 200.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManager.whitecolor.withOpacity(0.08),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsManager.whitecolor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          "assets/images/logo.png",
          width: 32.sp,
          height: 32.sp,
        ),
      ),
    );
  }

  Widget _buildPageIndicator(OnboardingState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _onboardingPages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: state.currentPage == index ? 32.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: state.currentPage == index
                ? ColorsManager.whitecolor
                : ColorsManager.whitecolor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingData data) {
    return Column(
      children: [
        // Image without box - just floating
        Expanded(
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: child,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Image.asset(
                    data.illustration,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Center(
                      child: Icon(
                        Icons.image,
                        size: 80.sp,
                        color: ColorsManager.whitecolor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        SizedBox(height: 40.h),

        // Title and subtitle
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            children: [
              Text(
                data.title,
                style: TextStyles.heading1.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorsManager.whitecolor,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                data.subtitle,
                style: TextStyles.body.copyWith(
                  fontSize: 15.sp,
                  color: ColorsManager.whitecolor.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ],
          ),
        ),

        SizedBox(height: 40.h),
      ],
    );
  }

  Widget _buildBottomButton(OnboardingCubit cubit, OnboardingState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: GestureDetector(
        onTap: () => _handleNext(cubit, state),
        child: Container(
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: ColorsManager.whitecolor,
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              state.isLastPage ? "Commencer" : "Suivant",
              style: TextStyles.heading2.copyWith(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: ColorsManager.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
