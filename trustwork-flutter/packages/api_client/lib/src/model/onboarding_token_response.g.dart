// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_token_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OnboardingTokenResponse extends OnboardingTokenResponse {
  @override
  final String onboardingToken;
  @override
  final int expiresIn;

  factory _$OnboardingTokenResponse(
          [void Function(OnboardingTokenResponseBuilder)? updates]) =>
      (OnboardingTokenResponseBuilder()..update(updates))._build();

  _$OnboardingTokenResponse._(
      {required this.onboardingToken, required this.expiresIn})
      : super._();
  @override
  OnboardingTokenResponse rebuild(
          void Function(OnboardingTokenResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OnboardingTokenResponseBuilder toBuilder() =>
      OnboardingTokenResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OnboardingTokenResponse &&
        onboardingToken == other.onboardingToken &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, onboardingToken.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OnboardingTokenResponse')
          ..add('onboardingToken', onboardingToken)
          ..add('expiresIn', expiresIn))
        .toString();
  }
}

class OnboardingTokenResponseBuilder
    implements
        Builder<OnboardingTokenResponse, OnboardingTokenResponseBuilder> {
  _$OnboardingTokenResponse? _$v;

  String? _onboardingToken;
  String? get onboardingToken => _$this._onboardingToken;
  set onboardingToken(String? onboardingToken) =>
      _$this._onboardingToken = onboardingToken;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  OnboardingTokenResponseBuilder() {
    OnboardingTokenResponse._defaults(this);
  }

  OnboardingTokenResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _onboardingToken = $v.onboardingToken;
      _expiresIn = $v.expiresIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OnboardingTokenResponse other) {
    _$v = other as _$OnboardingTokenResponse;
  }

  @override
  void update(void Function(OnboardingTokenResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OnboardingTokenResponse build() => _build();

  _$OnboardingTokenResponse _build() {
    final _$result = _$v ??
        _$OnboardingTokenResponse._(
          onboardingToken: BuiltValueNullFieldError.checkNotNull(
              onboardingToken, r'OnboardingTokenResponse', 'onboardingToken'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'OnboardingTokenResponse', 'expiresIn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
