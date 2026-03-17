// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserProfile extends UserProfile {
  @override
  final int id;
  @override
  final String? email;
  @override
  final String? phone;
  @override
  final String? bankIdSub;
  @override
  final String displayName;
  @override
  final String subscriptionStatus;
  @override
  final String? matrixUserId;

  factory _$UserProfile([void Function(UserProfileBuilder)? updates]) =>
      (UserProfileBuilder()..update(updates))._build();

  _$UserProfile._(
      {required this.id,
      this.email,
      this.phone,
      this.bankIdSub,
      required this.displayName,
      required this.subscriptionStatus,
      this.matrixUserId})
      : super._();
  @override
  UserProfile rebuild(void Function(UserProfileBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserProfileBuilder toBuilder() => UserProfileBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
        id == other.id &&
        email == other.email &&
        phone == other.phone &&
        bankIdSub == other.bankIdSub &&
        displayName == other.displayName &&
        subscriptionStatus == other.subscriptionStatus &&
        matrixUserId == other.matrixUserId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, bankIdSub.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, subscriptionStatus.hashCode);
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserProfile')
          ..add('id', id)
          ..add('email', email)
          ..add('phone', phone)
          ..add('bankIdSub', bankIdSub)
          ..add('displayName', displayName)
          ..add('subscriptionStatus', subscriptionStatus)
          ..add('matrixUserId', matrixUserId))
        .toString();
  }
}

class UserProfileBuilder implements Builder<UserProfile, UserProfileBuilder> {
  _$UserProfile? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _bankIdSub;
  String? get bankIdSub => _$this._bankIdSub;
  set bankIdSub(String? bankIdSub) => _$this._bankIdSub = bankIdSub;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _subscriptionStatus;
  String? get subscriptionStatus => _$this._subscriptionStatus;
  set subscriptionStatus(String? subscriptionStatus) =>
      _$this._subscriptionStatus = subscriptionStatus;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  UserProfileBuilder() {
    UserProfile._defaults(this);
  }

  UserProfileBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _phone = $v.phone;
      _bankIdSub = $v.bankIdSub;
      _displayName = $v.displayName;
      _subscriptionStatus = $v.subscriptionStatus;
      _matrixUserId = $v.matrixUserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserProfile other) {
    _$v = other as _$UserProfile;
  }

  @override
  void update(void Function(UserProfileBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserProfile build() => _build();

  _$UserProfile _build() {
    final _$result = _$v ??
        _$UserProfile._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'UserProfile', 'id'),
          email: email,
          phone: phone,
          bankIdSub: bankIdSub,
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'UserProfile', 'displayName'),
          subscriptionStatus: BuiltValueNullFieldError.checkNotNull(
              subscriptionStatus, r'UserProfile', 'subscriptionStatus'),
          matrixUserId: matrixUserId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
