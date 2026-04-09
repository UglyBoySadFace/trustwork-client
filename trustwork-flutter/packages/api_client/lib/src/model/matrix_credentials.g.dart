// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matrix_credentials.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatrixCredentials extends MatrixCredentials {
  @override
  final String matrixUserId;
  @override
  final String matrixAccessToken;
  @override
  final String matrixPassword;

  factory _$MatrixCredentials(
          [void Function(MatrixCredentialsBuilder)? updates]) =>
      (MatrixCredentialsBuilder()..update(updates))._build();

  _$MatrixCredentials._(
      {required this.matrixUserId,
      required this.matrixAccessToken,
      required this.matrixPassword})
      : super._();
  @override
  MatrixCredentials rebuild(void Function(MatrixCredentialsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatrixCredentialsBuilder toBuilder() =>
      MatrixCredentialsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatrixCredentials &&
        matrixUserId == other.matrixUserId &&
        matrixAccessToken == other.matrixAccessToken &&
        matrixPassword == other.matrixPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jc(_$hash, matrixAccessToken.hashCode);
    _$hash = $jc(_$hash, matrixPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatrixCredentials')
          ..add('matrixUserId', matrixUserId)
          ..add('matrixAccessToken', matrixAccessToken)
          ..add('matrixPassword', matrixPassword))
        .toString();
  }
}

class MatrixCredentialsBuilder
    implements Builder<MatrixCredentials, MatrixCredentialsBuilder> {
  _$MatrixCredentials? _$v;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  String? _matrixAccessToken;
  String? get matrixAccessToken => _$this._matrixAccessToken;
  set matrixAccessToken(String? matrixAccessToken) =>
      _$this._matrixAccessToken = matrixAccessToken;

  String? _matrixPassword;
  String? get matrixPassword => _$this._matrixPassword;
  set matrixPassword(String? matrixPassword) =>
      _$this._matrixPassword = matrixPassword;

  MatrixCredentialsBuilder() {
    MatrixCredentials._defaults(this);
  }

  MatrixCredentialsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixUserId = $v.matrixUserId;
      _matrixAccessToken = $v.matrixAccessToken;
      _matrixPassword = $v.matrixPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatrixCredentials other) {
    _$v = other as _$MatrixCredentials;
  }

  @override
  void update(void Function(MatrixCredentialsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatrixCredentials build() => _build();

  _$MatrixCredentials _build() {
    final _$result = _$v ??
        _$MatrixCredentials._(
          matrixUserId: BuiltValueNullFieldError.checkNotNull(
              matrixUserId, r'MatrixCredentials', 'matrixUserId'),
          matrixAccessToken: BuiltValueNullFieldError.checkNotNull(
              matrixAccessToken, r'MatrixCredentials', 'matrixAccessToken'),
          matrixPassword: BuiltValueNullFieldError.checkNotNull(
              matrixPassword, r'MatrixCredentials', 'matrixPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
