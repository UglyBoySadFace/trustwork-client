// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupMember extends GroupMember {
  @override
  final String? matrixUserId;
  @override
  final String displayName;
  @override
  final String status;
  @override
  final bool? isAdmin;

  factory _$GroupMember([void Function(GroupMemberBuilder)? updates]) =>
      (GroupMemberBuilder()..update(updates))._build();

  _$GroupMember._(
      {this.matrixUserId,
      required this.displayName,
      required this.status,
      this.isAdmin})
      : super._();
  @override
  GroupMember rebuild(void Function(GroupMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupMemberBuilder toBuilder() => GroupMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupMember &&
        matrixUserId == other.matrixUserId &&
        displayName == other.displayName &&
        status == other.status &&
        isAdmin == other.isAdmin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, isAdmin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupMember')
          ..add('matrixUserId', matrixUserId)
          ..add('displayName', displayName)
          ..add('status', status)
          ..add('isAdmin', isAdmin))
        .toString();
  }
}

class GroupMemberBuilder implements Builder<GroupMember, GroupMemberBuilder> {
  _$GroupMember? _$v;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  bool? _isAdmin;
  bool? get isAdmin => _$this._isAdmin;
  set isAdmin(bool? isAdmin) => _$this._isAdmin = isAdmin;

  GroupMemberBuilder() {
    GroupMember._defaults(this);
  }

  GroupMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixUserId = $v.matrixUserId;
      _displayName = $v.displayName;
      _status = $v.status;
      _isAdmin = $v.isAdmin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupMember other) {
    _$v = other as _$GroupMember;
  }

  @override
  void update(void Function(GroupMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupMember build() => _build();

  _$GroupMember _build() {
    final _$result = _$v ??
        _$GroupMember._(
          matrixUserId: matrixUserId,
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'GroupMember', 'displayName'),
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'GroupMember', 'status'),
          isAdmin: isAdmin,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
