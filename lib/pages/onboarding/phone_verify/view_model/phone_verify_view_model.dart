import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:fluffychat/pages/onboarding/shared/otp_view_model.dart';

class PhoneVerifyViewModel extends OtpViewModel {
  @override
  Future<void> onVerify(BuildContext context, String code) async {
    context.push('/onboarding/account-exists');
  }
}
