import 'dart:async';

import 'package:flutter/material.dart';

class OtpState {
  final String code;
  final int resendCooldown;

  const OtpState({
    this.code = '',
    this.resendCooldown = 30,
  });

  OtpState copyWith({String? code, int? resendCooldown}) => OtpState(
    code: code ?? this.code,
    resendCooldown: resendCooldown ?? this.resendCooldown,
  );
}

abstract class OtpViewModel extends ValueNotifier<OtpState> {
  Timer? _timer;

  OtpViewModel() : super(const OtpState()) {
    _startCooldown();
  }

  void _startCooldown() {
    _timer?.cancel();
    value = value.copyWith(resendCooldown: 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (value.resendCooldown <= 1) {
        timer.cancel();
        value = value.copyWith(resendCooldown: 0);
      } else {
        value = value.copyWith(resendCooldown: value.resendCooldown - 1);
      }
    });
  }

  void onCodeChanged(String code) {
    value = value.copyWith(code: code);
  }

  void onResend() {
    if (value.resendCooldown > 0) return;
    _startCooldown();
  }

  void onVerify(BuildContext context, String code);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
