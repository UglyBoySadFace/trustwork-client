// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_detail.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupDetail extends GroupDetail {
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
  final BuiltList<GroupMember> members;

  factory _$GroupDetail([void Function(GroupDetailBuilder)? updates]) =>
      (GroupDetailBuilder()..update(updates))._build();

  _$GroupDetail._(
      {required this.id,
      required this.name,
      required this.admin,
      this.matrixRoomId,
      required this.myStatus,
      required this.members})
      : super._();
  @override
  GroupDetail rebuild(void Function(GroupDetailBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupDetailBuilder toBuilder() => GroupDetailBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupDetail &&
        id == other.id &&
        name == other.name &&
        admin == other.admin &&
        matrixRoomId == other.matrixRoomId &&
        myStatus == other.myStatus &&
        members == other.members;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, admin.hashCode);
    _$hash = $jc(_$hash, matrixRoomId.hashCode);
    _$hash = $jc(_$hash, myStatus.hashCode);
    _$hash = $jc(_$hash, members.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupDetail')
          ..add('id', id)
          ..add('name', name)
          ..add('admin', admin)
          ..add('matrixRoomId', matrixRoomId)
          ..add('myStatus', myStatus)
          ..add('members', members))
        .toString();
  }
}

class GroupDetailBuilder implements Builder<GroupDetail, GroupDetailBuilder> {
  _$GroupDetail? _$v;

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

  ListBuilder<GroupMember>? _members;
  ListBuilder<GroupMember> get members =>
      _$this._members ??= ListBuilder<GroupMember>();
  set members(ListBuilder<GroupMember>? members) => _$this._members = members;

  GroupDetailBuilder() {
    GroupDetail._defaults(this);
  }

  GroupDetailBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _admin = $v.admin.toBuilder();
      _matrixRoomId = $v.matrixRoomId;
      _myStatus = $v.myStatus;
      _members = $v.members.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupDetail other) {
    _$v = other as _$GroupDetail;
  }

  @override
  void update(void Function(GroupDetailBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupDetail build() => _build();

  _$GroupDetail _build() {
    _$GroupDetail _$result;
    try {
      _$result = _$v ??
          _$GroupDetail._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'GroupDetail', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupDetail', 'name'),
            admin: admin.build(),
            matrixRoomId: matrixRoomId,
            myStatus: BuiltValueNullFieldError.checkNotNull(
                myStatus, r'GroupDetail', 'myStatus'),
            members: members.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'admin';
        admin.build();

        _$failedField = 'members';
        members.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupDetail', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
