import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/shared/otp_view_model.dart';

class EmailNewVerifyViewModel extends OtpViewModel {
  @override
  void onVerify(BuildContext context, String code) {
    context.go('/onboarding/welcome');
  }
}
