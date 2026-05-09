// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sharing_approve_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DataSharingApproveResponse extends DataSharingApproveResponse {
  @override
  final String token;

  factory _$DataSharingApproveResponse(
          [void Function(DataSharingApproveResponseBuilder)? updates]) =>
      (DataSharingApproveResponseBuilder()..update(updates))._build();

  _$DataSharingApproveResponse._({required this.token}) : super._();
  @override
  DataSharingApproveResponse rebuild(
          void Function(DataSharingApproveResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataSharingApproveResponseBuilder toBuilder() =>
      DataSharingApproveResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataSharingApproveResponse && token == other.token;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, token.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataSharingApproveResponse')
          ..add('token', token))
        .toString();
  }
}

class DataSharingApproveResponseBuilder
    implements
        Builder<DataSharingApproveResponse, DataSharingApproveResponseBuilder> {
  _$DataSharingApproveResponse? _$v;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  DataSharingApproveResponseBuilder() {
    DataSharingApproveResponse._defaults(this);
  }

  DataSharingApproveResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _token = $v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataSharingApproveResponse other) {
    _$v = other as _$DataSharingApproveResponse;
  }

  @override
  void update(void Function(DataSharingApproveResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DataSharingApproveResponse build() => _build();

  _$DataSharingApproveResponse _build() {
    final _$result = _$v ??
        _$DataSharingApproveResponse._(
          token: BuiltValueNullFieldError.checkNotNull(
              token, r'DataSharingApproveResponse', 'token'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
