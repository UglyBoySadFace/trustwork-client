class PhoneState {
  final bool isValid;
  final bool isLoading;
  final String? error;

  const PhoneState({
    this.isValid = false,
    this.isLoading = false,
    this.error,
  });

  PhoneState copyWith({
    bool? isValid,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => PhoneState(
    isValid: isValid ?? this.isValid,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : error ?? this.error,
  );
}
