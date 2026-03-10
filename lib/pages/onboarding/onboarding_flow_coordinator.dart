class OnboardingFlowCoordinator {
  static final instance = OnboardingFlowCoordinator._();
  OnboardingFlowCoordinator._();

  String? phoneNumber;
  String? newEmail;

  void reset() {
    phoneNumber = null;
    newEmail = null;
  }
}
