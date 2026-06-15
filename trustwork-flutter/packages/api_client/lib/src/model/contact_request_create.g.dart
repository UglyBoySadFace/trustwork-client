// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_request_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactRequestCreate extends ContactRequestCreate {
  @override
  final String targetMatrixId;

  factory _$ContactRequestCreate(
          [void Function(ContactRequestCreateBuilder)? updates]) =>
      (ContactRequestCreateBuilder()..update(updates))._build();

  _$ContactRequestCreate._({required this.targetMatrixId}) : super._();
  @override
  ContactRequestCreate rebuild(
          void Function(ContactRequestCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactRequestCreateBuilder toBuilder() =>
      ContactRequestCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactRequestCreate &&
        targetMatrixId == other.targetMatrixId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetMatrixId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactRequestCreate')
          ..add('targetMatrixId', targetMatrixId))
        .toString();
  }
}

class ContactRequestCreateBuilder
    implements Builder<ContactRequestCreate, ContactRequestCreateBuilder> {
  _$ContactRequestCreate? _$v;

  String? _targetMatrixId;
  String? get targetMatrixId => _$this._targetMatrixId;
  set targetMatrixId(String? targetMatrixId) =>
      _$this._targetMatrixId = targetMatrixId;

  ContactRequestCreateBuilder() {
    ContactRequestCreate._defaults(this);
  }

  ContactRequestCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetMatrixId = $v.targetMatrixId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactRequestCreate other) {
    _$v = other as _$ContactRequestCreate;
  }

  @override
  void update(void Function(ContactRequestCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactRequestCreate build() => _build();

  _$ContactRequestCreate _build() {
    final _$result = _$v ??
        _$ContactRequestCreate._(
          targetMatrixId: BuiltValueNullFieldError.checkNotNull(
              targetMatrixId, r'ContactRequestCreate', 'targetMatrixId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
