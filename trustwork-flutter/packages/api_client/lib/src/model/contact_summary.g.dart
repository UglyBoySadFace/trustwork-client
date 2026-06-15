// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_summary.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactSummary extends ContactSummary {
  @override
  final String? matrixUserId;
  @override
  final String displayName;

  factory _$ContactSummary([void Function(ContactSummaryBuilder)? updates]) =>
      (ContactSummaryBuilder()..update(updates))._build();

  _$ContactSummary._({this.matrixUserId, required this.displayName})
      : super._();
  @override
  ContactSummary rebuild(void Function(ContactSummaryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactSummaryBuilder toBuilder() => ContactSummaryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactSummary &&
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
    return (newBuiltValueToStringHelper(r'ContactSummary')
          ..add('matrixUserId', matrixUserId)
          ..add('displayName', displayName))
        .toString();
  }
}

class ContactSummaryBuilder
    implements Builder<ContactSummary, ContactSummaryBuilder> {
  _$ContactSummary? _$v;

  String? _matrixUserId;
  String? get matrixUserId => _$this._matrixUserId;
  set matrixUserId(String? matrixUserId) => _$this._matrixUserId = matrixUserId;

  String? _displayName;
  String? get displayName => _$this._displayName;
  set displayName(String? displayName) => _$this._displayName = displayName;

  ContactSummaryBuilder() {
    ContactSummary._defaults(this);
  }

  ContactSummaryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _matrixUserId = $v.matrixUserId;
      _displayName = $v.displayName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactSummary other) {
    _$v = other as _$ContactSummary;
  }

  @override
  void update(void Function(ContactSummaryBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactSummary build() => _build();

  _$ContactSummary _build() {
    final _$result = _$v ??
        _$ContactSummary._(
          matrixUserId: matrixUserId,
          displayName: BuiltValueNullFieldError.checkNotNull(
              displayName, r'ContactSummary', 'displayName'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
