// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_invite_preview.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GroupInvitePreview extends GroupInvitePreview {
  @override
  final int id;
  @override
  final String name;
  @override
  final ContactProfile admin;
  @override
  final int totalMembers;
  @override
  final int knownCount;
  @override
  final int unknownCount;
  @override
  final ContactProfile? suggestedBy;

  factory _$GroupInvitePreview(
          [void Function(GroupInvitePreviewBuilder)? updates]) =>
      (GroupInvitePreviewBuilder()..update(updates))._build();

  _$GroupInvitePreview._(
      {required this.id,
      required this.name,
      required this.admin,
      required this.totalMembers,
      required this.knownCount,
      required this.unknownCount,
      this.suggestedBy})
      : super._();
  @override
  GroupInvitePreview rebuild(
          void Function(GroupInvitePreviewBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupInvitePreviewBuilder toBuilder() =>
      GroupInvitePreviewBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GroupInvitePreview &&
        id == other.id &&
        name == other.name &&
        admin == other.admin &&
        totalMembers == other.totalMembers &&
        knownCount == other.knownCount &&
        unknownCount == other.unknownCount &&
        suggestedBy == other.suggestedBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, admin.hashCode);
    _$hash = $jc(_$hash, totalMembers.hashCode);
    _$hash = $jc(_$hash, knownCount.hashCode);
    _$hash = $jc(_$hash, unknownCount.hashCode);
    _$hash = $jc(_$hash, suggestedBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GroupInvitePreview')
          ..add('id', id)
          ..add('name', name)
          ..add('admin', admin)
          ..add('totalMembers', totalMembers)
          ..add('knownCount', knownCount)
          ..add('unknownCount', unknownCount)
          ..add('suggestedBy', suggestedBy))
        .toString();
  }
}

class GroupInvitePreviewBuilder
    implements Builder<GroupInvitePreview, GroupInvitePreviewBuilder> {
  _$GroupInvitePreview? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ContactProfileBuilder? _admin;
  ContactProfileBuilder get admin => _$this._admin ??= ContactProfileBuilder();
  set admin(ContactProfileBuilder? admin) => _$this._admin = admin;

  int? _totalMembers;
  int? get totalMembers => _$this._totalMembers;
  set totalMembers(int? totalMembers) => _$this._totalMembers = totalMembers;

  int? _knownCount;
  int? get knownCount => _$this._knownCount;
  set knownCount(int? knownCount) => _$this._knownCount = knownCount;

  int? _unknownCount;
  int? get unknownCount => _$this._unknownCount;
  set unknownCount(int? unknownCount) => _$this._unknownCount = unknownCount;

  ContactProfileBuilder? _suggestedBy;
  ContactProfileBuilder get suggestedBy =>
      _$this._suggestedBy ??= ContactProfileBuilder();
  set suggestedBy(ContactProfileBuilder? suggestedBy) =>
      _$this._suggestedBy = suggestedBy;

  GroupInvitePreviewBuilder() {
    GroupInvitePreview._defaults(this);
  }

  GroupInvitePreviewBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _admin = $v.admin.toBuilder();
      _totalMembers = $v.totalMembers;
      _knownCount = $v.knownCount;
      _unknownCount = $v.unknownCount;
      _suggestedBy = $v.suggestedBy?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GroupInvitePreview other) {
    _$v = other as _$GroupInvitePreview;
  }

  @override
  void update(void Function(GroupInvitePreviewBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GroupInvitePreview build() => _build();

  _$GroupInvitePreview _build() {
    _$GroupInvitePreview _$result;
    try {
      _$result = _$v ??
          _$GroupInvitePreview._(
            id: BuiltValueNullFieldError.checkNotNull(
                id, r'GroupInvitePreview', 'id'),
            name: BuiltValueNullFieldError.checkNotNull(
                name, r'GroupInvitePreview', 'name'),
            admin: admin.build(),
            totalMembers: BuiltValueNullFieldError.checkNotNull(
                totalMembers, r'GroupInvitePreview', 'totalMembers'),
            knownCount: BuiltValueNullFieldError.checkNotNull(
                knownCount, r'GroupInvitePreview', 'knownCount'),
            unknownCount: BuiltValueNullFieldError.checkNotNull(
                unknownCount, r'GroupInvitePreview', 'unknownCount'),
            suggestedBy: _suggestedBy?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'admin';
        admin.build();

        _$failedField = 'suggestedBy';
        _suggestedBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'GroupInvitePreview', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
