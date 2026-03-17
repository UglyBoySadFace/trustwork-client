// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

class OtpState {
  final String code;
  final int resendCooldown;
  final bool isLoading;
  final String? error;

  const OtpState({
    this.code = '',
    this.resendCooldown = 30,
    this.isLoading = false,
    this.error,
  });

  OtpState copyWith({
    String? code,
    int? resendCooldown,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => OtpState(
    code: code ?? this.code,
    resendCooldown: resendCooldown ?? this.resendCooldown,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
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
    value = value.copyWith(code: code, clearError: true);
  }

  void onResend() {
    if (value.resendCooldown > 0) return;
    _startCooldown();
  }

  Future<void> onVerify(BuildContext context, String code);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
