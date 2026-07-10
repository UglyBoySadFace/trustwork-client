// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_request_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactRequestCreate extends ContactRequestCreate {
  @override
  final String targetMatrixId;
  @override
  final String? initialMessage;

  factory _$ContactRequestCreate(
          [void Function(ContactRequestCreateBuilder)? updates]) =>
      (ContactRequestCreateBuilder()..update(updates))._build();

  _$ContactRequestCreate._({required this.targetMatrixId, this.initialMessage})
      : super._();
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
        targetMatrixId == other.targetMatrixId &&
        initialMessage == other.initialMessage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, targetMatrixId.hashCode);
    _$hash = $jc(_$hash, initialMessage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactRequestCreate')
          ..add('targetMatrixId', targetMatrixId)
          ..add('initialMessage', initialMessage))
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

  String? _initialMessage;
  String? get initialMessage => _$this._initialMessage;
  set initialMessage(String? initialMessage) =>
      _$this._initialMessage = initialMessage;

  ContactRequestCreateBuilder() {
    ContactRequestCreate._defaults(this);
  }

  ContactRequestCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _targetMatrixId = $v.targetMatrixId;
      _initialMessage = $v.initialMessage;
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
          initialMessage: initialMessage,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
