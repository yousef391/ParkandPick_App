class OnboardingData {
  final String title;
  final String subtitle;
  final String illustration;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });

  static List<OnboardingData> onboardingPages = [
    OnboardingData(
      title: "Fresh Coffee",
      subtitle: "Enjoy the aroma of freshly brewed coffee every day",
      illustration: "assets/images/onboarding images.png",
    ),
    OnboardingData(
      title: "Fast Service",
      subtitle: "Get your coffee fast and hot with our optimized service",
      illustration: "assets/images/onboarding images1.png",
    ),
    OnboardingData(
      title: "Relax & Enjoy",
      subtitle: "Comfortable seats and cozy ambiance for your coffee break",
      illustration: "assets/images/onboarding images2.png",
    ),
  ];
}
