// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matrix_password_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatrixPasswordResponse extends MatrixPasswordResponse {
  @override
  final String matrixPassword;

  factory _$MatrixPasswordResponse(
          [void Function(MatrixPasswordResponseBuilder)? updates]) =>
      (MatrixPasswordResponseBuilder()..update(updates))._build();

  _$MatrixPasswordResponse._({required this.matrixPassword}) : super._();
  @override
  MatrixPasswordResponse rebuild(
          void Function(MatrixPasswordResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatrixPasswordResponseBuilder toBuilder() =>
      MatrixPasswordResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatrixPasswordResponse &&
        matrixPassword == other.matrixPassword;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matrixPassword.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatrixPasswordResponse')
          ..add('matrixPassword', matrixPassword))
        .toString();
  }
}

class MatrixPasswordResponseBuilder
    implements Builder<MatrixPasswordResponse, MatrixPasswordResponseBuilder> {
  _$MatrixPasswordResponse? _$v;

  String? _matrixPassword;
  String? get matrixPassword => _$this._matrixPassword;
  set matrixPassword(String? matrixPassword) =>
      _$this._matrixPassword = matrixPassword;

  MatrixPasswordResponseBuilder() {
    MatrixPasswordResponse._defaults(this);
  }

  MatrixPasswordResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixPassword = $v.matrixPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatrixPasswordResponse other) {
    _$v = other as _$MatrixPasswordResponse;
  }

  @override
  void update(void Function(MatrixPasswordResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatrixPasswordResponse build() => _build();

  _$MatrixPasswordResponse _build() {
    final _$result = _$v ??
        _$MatrixPasswordResponse._(
          matrixPassword: BuiltValueNullFieldError.checkNotNull(
              matrixPassword, r'MatrixPasswordResponse', 'matrixPassword'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
