// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verify_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailVerifyRequest extends EmailVerifyRequest {
  @override
  final String email;
  @override
  final String code;
  @override
  final String? phone;

  factory _$EmailVerifyRequest(
          [void Function(EmailVerifyRequestBuilder)? updates]) =>
      (EmailVerifyRequestBuilder()..update(updates))._build();

  _$EmailVerifyRequest._({required this.email, required this.code, this.phone})
      : super._();
  @override
  EmailVerifyRequest rebuild(
          void Function(EmailVerifyRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailVerifyRequestBuilder toBuilder() =>
      EmailVerifyRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailVerifyRequest &&
        email == other.email &&
        code == other.code &&
        phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailVerifyRequest')
          ..add('email', email)
          ..add('code', code)
          ..add('phone', phone))
        .toString();
  }
}

class EmailVerifyRequestBuilder
    implements Builder<EmailVerifyRequest, EmailVerifyRequestBuilder> {
  _$EmailVerifyRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  EmailVerifyRequestBuilder() {
    EmailVerifyRequest._defaults(this);
  }

  EmailVerifyRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailVerifyRequest other) {
    _$v = other as _$EmailVerifyRequest;
  }

  @override
  void update(void Function(EmailVerifyRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailVerifyRequest build() => _build();

  _$EmailVerifyRequest _build() {
    final _$result = _$v ??
        _$EmailVerifyRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailVerifyRequest', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'EmailVerifyRequest', 'code'),
          phone: phone,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
