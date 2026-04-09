// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matched_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MatchedContact extends MatchedContact {
  @override
  final String phoneHash;
  @override
  final String displayName;
  @override
  final String? matrixUserId;

  factory _$MatchedContact([void Function(MatchedContactBuilder)? updates]) =>
      (MatchedContactBuilder()..update(updates))._build();

  _$MatchedContact._(
      {required this.phoneHash, required this.displayName, this.matrixUserId})
      : super._();
  @override
  MatchedContact rebuild(void Function(MatchedContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MatchedContactBuilder toBuilder() => MatchedContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MatchedContact &&
        phoneHash == other.phoneHash &&
        displayName == other.displayName &&
        matrixUserId == other.matrixUserId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phoneHash.hashCode);
    _$hash = $jc(_$hash, displayName.hashCode);
    _$hash = $jc(_$hash, matrixUserId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MatchedContact')
          ..add('phoneHash', phoneHash)
          ..add('displayName', displayName)
          ..add('matrixUserId', matrixUserId))
        .toString();
  }
}

class MatchedContactBuilder
    implements Builder<MatchedContact, MatchedContactBuilder> {
  _$MatchedContact? _$v;

  String? _phoneHash;
  String? get phoneHash => _$this._phoneHash;
  set phoneHash(String? phoneHash) => _$this._phoneHash = phoneHash;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  MatchedContactBuilder() {
    MatchedContact._defaults(this);
  }

  MatchedContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phoneHash = $v.phoneHash;
      _displayName = $v.displayName;
      _matrixUserId = $v.matrixUserId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MatchedContact other) {
    _$v = other as _$MatchedContact;
  }

  @override
  void update(void Function(MatchedContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MatchedContact build() => _build();

  _$MatchedContact _build() {
    final _$result = _$v ??
        _$MatchedContact._(
          phoneHash: BuiltValueNullFieldError.checkNotNull(
              phoneHash, r'MatchedContact', 'phoneHash'),
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'MatchedContact', 'displayName'),
          matrixUserId: matrixUserId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
