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
      title: "Bienvenue chez Park&Pick!",
      subtitle: "Ton meilleur moment de la journée commence ici",
      illustration: "assets/images/onboarding_ani.png",
    ),
    OnboardingData(
      title: "Une expérience attractive",
      subtitle:
          "Découvre une animation qui t'invite à vivre quelque chose d'unique",
      illustration: "assets/images/onboarding_ani.png",
    ),
    OnboardingData(
      title: "Prêt à commencer?",
      subtitle: "Profite de nos services et fais-toi plaisir dès maintenant",
      illustration: "assets/images/onboarding_ani.png",
    ),
  ];
}
