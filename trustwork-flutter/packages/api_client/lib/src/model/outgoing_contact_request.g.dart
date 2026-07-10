// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outgoing_contact_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$OutgoingContactRequest extends OutgoingContactRequest {
  @override
  final int id;
  @override
  final String status;
  @override
  final String targetMatrixId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? respondedAt;
  @override
  final ContactProfile? target;
  @override
  final String? matrixRoomId;

  factory _$OutgoingContactRequest(
          [void Function(OutgoingContactRequestBuilder)? updates]) =>
      (OutgoingContactRequestBuilder()..update(updates))._build();

  _$OutgoingContactRequest._(
      {required this.id,
      required this.status,
      required this.targetMatrixId,
      required this.createdAt,
      this.respondedAt,
      this.target,
      this.matrixRoomId})
      : super._();
  @override
  OutgoingContactRequest rebuild(
          void Function(OutgoingContactRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OutgoingContactRequestBuilder toBuilder() =>
      OutgoingContactRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OutgoingContactRequest &&
        id == other.id &&
        status == other.status &&
        targetMatrixId == other.targetMatrixId &&
        createdAt == other.createdAt &&
        respondedAt == other.respondedAt &&
        target == other.target &&
        matrixRoomId == other.matrixRoomId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, targetMatrixId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, matrixRoomId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OutgoingContactRequest')
          ..add('id', id)
          ..add('status', status)
          ..add('targetMatrixId', targetMatrixId)
          ..add('createdAt', createdAt)
          ..add('respondedAt', respondedAt)
          ..add('target', target)
          ..add('matrixRoomId', matrixRoomId))
        .toString();
  }
}

class OutgoingContactRequestBuilder
    implements Builder<OutgoingContactRequest, OutgoingContactRequestBuilder> {
  _$OutgoingContactRequest? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _targetMatrixId;
  String? get targetMatrixId => _$this._targetMatrixId;
  set targetMatrixId(String? targetMatrixId) =>
      _$this._targetMatrixId = targetMatrixId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  ContactProfileBuilder? _target;
  ContactProfileBuilder get target =>
      _$this._target ??= ContactProfileBuilder();
  set target(ContactProfileBuilder? target) => _$this._target = target;

  String? _matrixRoomId;
  String? get matrixRoomId => _$this._matrixRoomId;
  set matrixRoomId(String? matrixRoomId) => _$this._matrixRoomId = matrixRoomId;

  OutgoingContactRequestBuilder() {
    OutgoingContactRequest._defaults(this);
  }

  OutgoingContactRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _targetMatrixId = $v.targetMatrixId;
      _createdAt = $v.createdAt;
      _respondedAt = $v.respondedAt;
      _target = $v.target?.toBuilder();
      _matrixRoomId = $v.matrixRoomId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OutgoingContactRequest other) {
    _$v = other as _$OutgoingContactRequest;
  }

  @override
  void update(void Function(OutgoingContactRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OutgoingContactRequest build() => _build();

  _$OutgoingContactRequest _build() {
    _$OutgoingContactRequest _$result;
    try {
      _$result = _$v ??
          _$OutgoingContactRequest._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'OutgoingContactRequest', 'id'),
            status: BuiltValueNullFieldError.checkNotNull(
                status, r'OutgoingContactRequest', 'status'),
            targetMatrixId: BuiltValueNullFieldError.checkNotNull(
                targetMatrixId, r'OutgoingContactRequest', 'targetMatrixId'),
            createdAt: BuiltValueNullFieldError.checkNotNull(
                createdAt, r'OutgoingContactRequest', 'createdAt'),
            respondedAt: respondedAt,
            target: _target?.build(),
            matrixRoomId: matrixRoomId,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'target';
        _target?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'OutgoingContactRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
