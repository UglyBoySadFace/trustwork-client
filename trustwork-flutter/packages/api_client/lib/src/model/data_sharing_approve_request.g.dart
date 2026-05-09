// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_sharing_approve_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DataSharingApproveRequest extends DataSharingApproveRequest {
  @override
  final String calleeMatrixId;
  @override
  final BuiltList<SharableField> approvedFields;

  factory _$DataSharingApproveRequest(
          [void Function(DataSharingApproveRequestBuilder)? updates]) =>
      (DataSharingApproveRequestBuilder()..update(updates))._build();

  _$DataSharingApproveRequest._(
      {required this.calleeMatrixId, required this.approvedFields})
      : super._();
  @override
  DataSharingApproveRequest rebuild(
          void Function(DataSharingApproveRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DataSharingApproveRequestBuilder toBuilder() =>
      DataSharingApproveRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DataSharingApproveRequest &&
        calleeMatrixId == other.calleeMatrixId &&
        approvedFields == other.approvedFields;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, calleeMatrixId.hashCode);
    _$hash = $jc(_$hash, approvedFields.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DataSharingApproveRequest')
          ..add('calleeMatrixId', calleeMatrixId)
          ..add('approvedFields', approvedFields))
        .toString();
  }
}

class DataSharingApproveRequestBuilder
    implements
        Builder<DataSharingApproveRequest, DataSharingApproveRequestBuilder> {
  _$DataSharingApproveRequest? _$v;

  String? _calleeMatrixId;
  String? get calleeMatrixId => _$this._calleeMatrixId;
  set calleeMatrixId(String? calleeMatrixId) =>
      _$this._calleeMatrixId = calleeMatrixId;

  ListBuilder<SharableField>? _approvedFields;
  ListBuilder<SharableField> get approvedFields =>
      _$this._approvedFields ??= ListBuilder<SharableField>();
  set approvedFields(ListBuilder<SharableField>? approvedFields) =>
      _$this._approvedFields = approvedFields;

  DataSharingApproveRequestBuilder() {
    DataSharingApproveRequest._defaults(this);
  }

  DataSharingApproveRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _calleeMatrixId = $v.calleeMatrixId;
      _approvedFields = $v.approvedFields.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DataSharingApproveRequest other) {
    _$v = other as _$DataSharingApproveRequest;
  }

  @override
  void update(void Function(DataSharingApproveRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DataSharingApproveRequest build() => _build();

  _$DataSharingApproveRequest _build() {
    _$DataSharingApproveRequest _$result;
    try {
      _$result = _$v ??
          _$DataSharingApproveRequest._(
            calleeMatrixId: BuiltValueNullFieldError.checkNotNull(
                calleeMatrixId, r'DataSharingApproveRequest', 'calleeMatrixId'),
            approvedFields: approvedFields.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'approvedFields';
        approvedFields.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'DataSharingApproveRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
