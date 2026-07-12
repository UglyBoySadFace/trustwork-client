// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupCreate extends GroupCreate {
  @override
  final String name;
  @override
  final BuiltList<String> memberMatrixIds;

  factory _$GroupCreate([void Function(GroupCreateBuilder)? updates]) =>
      (GroupCreateBuilder()..update(updates))._build();

  _$GroupCreate._({required this.name, required this.memberMatrixIds})
      : super._();
  @override
  GroupCreate rebuild(void Function(GroupCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupCreateBuilder toBuilder() => GroupCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupCreate &&
        name == other.name &&
        memberMatrixIds == other.memberMatrixIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, memberMatrixIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupCreate')
          ..add('name', name)
          ..add('memberMatrixIds', memberMatrixIds))
        .toString();
  }
}

class GroupCreateBuilder implements Builder<GroupCreate, GroupCreateBuilder> {
  _$GroupCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ListBuilder<String>? _memberMatrixIds;
  ListBuilder<String> get memberMatrixIds =>
      _$this._memberMatrixIds ??= ListBuilder<String>();
  set memberMatrixIds(ListBuilder<String>? memberMatrixIds) =>
      _$this._memberMatrixIds = memberMatrixIds;

  GroupCreateBuilder() {
    GroupCreate._defaults(this);
  }

  GroupCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _memberMatrixIds = $v.memberMatrixIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupCreate other) {
    _$v = other as _$GroupCreate;
  }

  @override
  void update(void Function(GroupCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupCreate build() => _build();

  _$GroupCreate _build() {
    _$GroupCreate _$result;
    try {
      _$result = _$v ??
          _$GroupCreate._(
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupCreate', 'name'),
            memberMatrixIds: memberMatrixIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'memberMatrixIds';
        memberMatrixIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupCreate', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
