// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_start_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$EmailStartResponse extends EmailStartResponse {
  @override
  final String message;
  @override
  final int expiresIn;

  factory _$EmailStartResponse(
          [void Function(EmailStartResponseBuilder)? updates]) =>
      (EmailStartResponseBuilder()..update(updates))._build();

  _$EmailStartResponse._({required this.message, required this.expiresIn})
      : super._();
  @override
  EmailStartResponse rebuild(
          void Function(EmailStartResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EmailStartResponseBuilder toBuilder() =>
      EmailStartResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EmailStartResponse &&
        message == other.message &&
        expiresIn == other.expiresIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EmailStartResponse')
          ..add('message', message)
          ..add('expiresIn', expiresIn))
        .toString();
  }
}

class EmailStartResponseBuilder
    implements Builder<EmailStartResponse, EmailStartResponseBuilder> {
  _$EmailStartResponse? _$v;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  EmailStartResponseBuilder() {
    EmailStartResponse._defaults(this);
  }

  EmailStartResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _message = $v.message;
      _expiresIn = $v.expiresIn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EmailStartResponse other) {
    _$v = other as _$EmailStartResponse;
  }

  @override
  void update(void Function(EmailStartResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EmailStartResponse build() => _build();

  _$EmailStartResponse _build() {
    final _$result = _$v ??
        _$EmailStartResponse._(
          message: BuiltValueNullFieldError.checkNotNull(
              message, r'EmailStartResponse', 'message'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'EmailStartResponse', 'expiresIn'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
