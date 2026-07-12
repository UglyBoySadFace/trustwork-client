// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupSummary extends GroupSummary {
  @override
  final int id;
  @override
  final String name;
  @override
  final ContactProfile admin;
  @override
  final String? matrixRoomId;
  @override
  final String myStatus;
  @override
  final int memberCount;

  factory _$GroupSummary([void Function(GroupSummaryBuilder)? updates]) =>
      (GroupSummaryBuilder()..update(updates))._build();

  _$GroupSummary._(
      {required this.id,
      required this.name,
      required this.admin,
      this.matrixRoomId,
      required this.myStatus,
      required this.memberCount})
      : super._();
  @override
  GroupSummary rebuild(void Function(GroupSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupSummaryBuilder toBuilder() => GroupSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupSummary &&
        id == other.id &&
        name == other.name &&
        admin == other.admin &&
        matrixRoomId == other.matrixRoomId &&
        myStatus == other.myStatus &&
        memberCount == other.memberCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, admin.hashCode);
    _$hash = $jc(_$hash, matrixRoomId.hashCode);
    _$hash = $jc(_$hash, myStatus.hashCode);
    _$hash = $jc(_$hash, memberCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupSummary')
          ..add('id', id)
          ..add('name', name)
          ..add('admin', admin)
          ..add('matrixRoomId', matrixRoomId)
          ..add('myStatus', myStatus)
          ..add('memberCount', memberCount))
        .toString();
  }
}

class GroupSummaryBuilder
    implements Builder<GroupSummary, GroupSummaryBuilder> {
  _$GroupSummary? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ContactProfileBuilder? _admin;
  ContactProfileBuilder get admin => _$this._admin ??= ContactProfileBuilder();
  set admin(ContactProfileBuilder? admin) => _$this._admin = admin;

  String? _matrixRoomId;
  String? get matrixRoomId => _$this._matrixRoomId;
  set matrixRoomId(String? matrixRoomId) => _$this._matrixRoomId = matrixRoomId;

  String? _myStatus;
  String? get myStatus => _$this._myStatus;
  set myStatus(String? myStatus) => _$this._myStatus = myStatus;

  int? _memberCount;
  int? get memberCount => _$this._memberCount;
  set memberCount(int? memberCount) => _$this._memberCount = memberCount;

  GroupSummaryBuilder() {
    GroupSummary._defaults(this);
  }

  GroupSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _admin = $v.admin.toBuilder();
      _matrixRoomId = $v.matrixRoomId;
      _myStatus = $v.myStatus;
      _memberCount = $v.memberCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupSummary other) {
    _$v = other as _$GroupSummary;
  }

  @override
  void update(void Function(GroupSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupSummary build() => _build();

  _$GroupSummary _build() {
    _$GroupSummary _$result;
    try {
      _$result = _$v ??
          _$GroupSummary._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GroupSummary', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupSummary', 'name'),
            admin: admin.build(),
            matrixRoomId: matrixRoomId,
            myStatus: BuiltValueNullFieldError.checkNotNull(
                myStatus, r'GroupSummary', 'myStatus'),
            memberCount: BuiltValueNullFieldError.checkNotNull(
                memberCount, r'GroupSummary', 'memberCount'),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'admin';
        admin.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupSummary', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
