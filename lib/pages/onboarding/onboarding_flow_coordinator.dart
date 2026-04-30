import 'package:api_client/api_client.dart';

class OnboardingFlowCoordinator {
  static final instance = OnboardingFlowCoordinator._();
  OnboardingFlowCoordinator._();

  String? phoneNumber;
  bool? isRegistered;
  String? newEmail;
  AuthResponse? authResponse;
  String? matrixLoginToken;
  String? matrixDeviceId;

  void reset() {
    phoneNumber = null;
    isRegistered = null;
    newEmail = null;
    authResponse = null;
    matrixLoginToken = null;
    matrixDeviceId = null;
  }
}
