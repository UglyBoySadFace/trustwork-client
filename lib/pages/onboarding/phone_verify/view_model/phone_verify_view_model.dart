// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fluffychat/pages/onboarding/shared/otp_view_model.dart';

class PhoneVerifyViewModel extends OtpViewModel {
  @override
  Future<void> onVerify(BuildContext context, String code) async {
    context.push('/onboarding/account-exists');
  }
}
