// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_admin_transfer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupAdminTransfer extends GroupAdminTransfer {
  @override
  final String matrixUserId;

  factory _$GroupAdminTransfer(
          [void Function(GroupAdminTransferBuilder)? updates]) =>
      (GroupAdminTransferBuilder()..update(updates))._build();

  _$GroupAdminTransfer._({required this.matrixUserId}) : super._();
  @override
  GroupAdminTransfer rebuild(
          void Function(GroupAdminTransferBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupAdminTransferBuilder toBuilder() =>
      GroupAdminTransferBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupAdminTransfer && matrixUserId == other.matrixUserId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupAdminTransfer')
          ..add('matrixUserId', matrixUserId))
        .toString();
  }
}

class GroupAdminTransferBuilder
    implements Builder<GroupAdminTransfer, GroupAdminTransferBuilder> {
  _$GroupAdminTransfer? _$v;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  GroupAdminTransferBuilder() {
    GroupAdminTransfer._defaults(this);
  }

  GroupAdminTransferBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixUserId = $v.matrixUserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupAdminTransfer other) {
    _$v = other as _$GroupAdminTransfer;
  }

  @override
  void update(void Function(GroupAdminTransferBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupAdminTransfer build() => _build();

  _$GroupAdminTransfer _build() {
    final _$result = _$v ??
        _$GroupAdminTransfer._(
          matrixUserId: BuiltValueNullFieldError.checkNotNull(
              matrixUserId, r'GroupAdminTransfer', 'matrixUserId'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
