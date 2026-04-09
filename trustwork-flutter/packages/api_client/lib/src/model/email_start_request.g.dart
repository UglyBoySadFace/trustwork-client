// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_start_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailStartRequest extends EmailStartRequest {
  @override
  final String email;

  factory _$EmailStartRequest(
          [void Function(EmailStartRequestBuilder)? updates]) =>
      (EmailStartRequestBuilder()..update(updates))._build();

  _$EmailStartRequest._({required this.email}) : super._();
  @override
  EmailStartRequest rebuild(void Function(EmailStartRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailStartRequestBuilder toBuilder() =>
      EmailStartRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailStartRequest && email == other.email;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailStartRequest')
          ..add('email', email))
        .toString();
  }
}

class EmailStartRequestBuilder
    implements Builder<EmailStartRequest, EmailStartRequestBuilder> {
  _$EmailStartRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  EmailStartRequestBuilder() {
    EmailStartRequest._defaults(this);
  }

  EmailStartRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailStartRequest other) {
    _$v = other as _$EmailStartRequest;
  }

  @override
  void update(void Function(EmailStartRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailStartRequest build() => _build();

  _$EmailStartRequest _build() {
    final _$result = _$v ??
        _$EmailStartRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'EmailStartRequest', 'email'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
