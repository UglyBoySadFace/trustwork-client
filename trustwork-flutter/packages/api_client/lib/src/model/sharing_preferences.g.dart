// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharing_preferences.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SharingPreferences extends SharingPreferences {
  @override
  final bool? shareCountry;
  @override
  final bool? shareState;
  @override
  final bool? shareStreet;
  @override
  final bool? shareStreetFull;
  @override
  final bool? shareFullAge;
  @override
  final bool? shareDecadeOfAge;
  @override
  final bool? shareIsAdult;
  @override
  final bool? shareNationalities;

  factory _$SharingPreferences(
          [void Function(SharingPreferencesBuilder)? updates]) =>
      (SharingPreferencesBuilder()..update(updates))._build();

  _$SharingPreferences._(
      {this.shareCountry,
      this.shareState,
      this.shareStreet,
      this.shareStreetFull,
      this.shareFullAge,
      this.shareDecadeOfAge,
      this.shareIsAdult,
      this.shareNationalities})
      : super._();
  @override
  SharingPreferences rebuild(
          void Function(SharingPreferencesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SharingPreferencesBuilder toBuilder() =>
      SharingPreferencesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SharingPreferences &&
        shareCountry == other.shareCountry &&
        shareState == other.shareState &&
        shareStreet == other.shareStreet &&
        shareStreetFull == other.shareStreetFull &&
        shareFullAge == other.shareFullAge &&
        shareDecadeOfAge == other.shareDecadeOfAge &&
        shareIsAdult == other.shareIsAdult &&
        shareNationalities == other.shareNationalities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, shareCountry.hashCode);
    _$hash = $jc(_$hash, shareState.hashCode);
    _$hash = $jc(_$hash, shareStreet.hashCode);
    _$hash = $jc(_$hash, shareStreetFull.hashCode);
    _$hash = $jc(_$hash, shareFullAge.hashCode);
    _$hash = $jc(_$hash, shareDecadeOfAge.hashCode);
    _$hash = $jc(_$hash, shareIsAdult.hashCode);
    _$hash = $jc(_$hash, shareNationalities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SharingPreferences')
          ..add('shareCountry', shareCountry)
          ..add('shareState', shareState)
          ..add('shareStreet', shareStreet)
          ..add('shareStreetFull', shareStreetFull)
          ..add('shareFullAge', shareFullAge)
          ..add('shareDecadeOfAge', shareDecadeOfAge)
          ..add('shareIsAdult', shareIsAdult)
          ..add('shareNationalities', shareNationalities))
        .toString();
  }
}

class SharingPreferencesBuilder
    implements Builder<SharingPreferences, SharingPreferencesBuilder> {
  _$SharingPreferences? _$v;

  bool? _shareCountry;
  bool? get shareCountry => _$this._shareCountry;
  set shareCountry(bool? shareCountry) => _$this._shareCountry = shareCountry;

  bool? _shareState;
  bool? get shareState => _$this._shareState;
  set shareState(bool? shareState) => _$this._shareState = shareState;

  bool? _shareStreet;
  bool? get shareStreet => _$this._shareStreet;
  set shareStreet(bool? shareStreet) => _$this._shareStreet = shareStreet;

  bool? _shareStreetFull;
  bool? get shareStreetFull => _$this._shareStreetFull;
  set shareStreetFull(bool? shareStreetFull) =>
      _$this._shareStreetFull = shareStreetFull;

  bool? _shareFullAge;
  bool? get shareFullAge => _$this._shareFullAge;
  set shareFullAge(bool? shareFullAge) => _$this._shareFullAge = shareFullAge;

  bool? _shareDecadeOfAge;
  bool? get shareDecadeOfAge => _$this._shareDecadeOfAge;
  set shareDecadeOfAge(bool? shareDecadeOfAge) =>
      _$this._shareDecadeOfAge = shareDecadeOfAge;

  bool? _shareIsAdult;
  bool? get shareIsAdult => _$this._shareIsAdult;
  set shareIsAdult(bool? shareIsAdult) => _$this._shareIsAdult = shareIsAdult;

  bool? _shareNationalities;
  bool? get shareNationalities => _$this._shareNationalities;
  set shareNationalities(bool? shareNationalities) =>
      _$this._shareNationalities = shareNationalities;

  SharingPreferencesBuilder() {
    SharingPreferences._defaults(this);
  }

  SharingPreferencesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _shareCountry = $v.shareCountry;
      _shareState = $v.shareState;
      _shareStreet = $v.shareStreet;
      _shareStreetFull = $v.shareStreetFull;
      _shareFullAge = $v.shareFullAge;
      _shareDecadeOfAge = $v.shareDecadeOfAge;
      _shareIsAdult = $v.shareIsAdult;
      _shareNationalities = $v.shareNationalities;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SharingPreferences other) {
    _$v = other as _$SharingPreferences;
  }

  @override
  void update(void Function(SharingPreferencesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SharingPreferences build() => _build();

  _$SharingPreferences _build() {
    final _$result = _$v ??
        _$SharingPreferences._(
          shareCountry: shareCountry,
          shareState: shareState,
          shareStreet: shareStreet,
          shareStreetFull: shareStreetFull,
          shareFullAge: shareFullAge,
          shareDecadeOfAge: shareDecadeOfAge,
          shareIsAdult: shareIsAdult,
          shareNationalities: shareNationalities,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
