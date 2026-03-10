class PhoneState {
  final bool isValid;

  const PhoneState({this.isValid = false});

  PhoneState copyWith({bool? isValid}) => PhoneState(
    isValid: isValid ?? this.isValid,
  );
}
