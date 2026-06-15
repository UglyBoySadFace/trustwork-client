// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactProfile extends ContactProfile {
  @override
  final String? matrixUserId;
  @override
  final String displayName;

  factory _$ContactProfile([void Function(ContactProfileBuilder)? updates]) =>
      (ContactProfileBuilder()..update(updates))._build();

  _$ContactProfile._({this.matrixUserId, required this.displayName})
      : super._();
  @override
  ContactProfile rebuild(void Function(ContactProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactProfileBuilder toBuilder() => ContactProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactProfile &&
        matrixUserId == other.matrixUserId &&
        displayName == other.displayName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ContactProfile')
          ..add('matrixUserId', matrixUserId)
          ..add('displayName', displayName))
        .toString();
  }
}

class ContactProfileBuilder
    implements Builder<ContactProfile, ContactProfileBuilder> {
  _$ContactProfile? _$v;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  ContactProfileBuilder() {
    ContactProfile._defaults(this);
  }

  ContactProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixUserId = $v.matrixUserId;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactProfile other) {
    _$v = other as _$ContactProfile;
  }

  @override
  void update(void Function(ContactProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactProfile build() => _build();

  _$ContactProfile _build() {
    final _$result = _$v ??
        _$ContactProfile._(
          matrixUserId: matrixUserId,
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ContactProfile', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
