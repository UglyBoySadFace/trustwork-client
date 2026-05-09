// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SharedData extends SharedData {
  @override
  final String? country;
  @override
  final String? state;
  @override
  final String? street;
  @override
  final String? streetFull;
  @override
  final int? fullAge;
  @override
  final String? decadeOfAge;
  @override
  final bool? isAdult;
  @override
  final BuiltList<String>? nationalities;

  factory _$SharedData([void Function(SharedDataBuilder)? updates]) =>
      (SharedDataBuilder()..update(updates))._build();

  _$SharedData._(
      {this.country,
      this.state,
      this.street,
      this.streetFull,
      this.fullAge,
      this.decadeOfAge,
      this.isAdult,
      this.nationalities})
      : super._();
  @override
  SharedData rebuild(void Function(SharedDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SharedDataBuilder toBuilder() => SharedDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SharedData &&
        country == other.country &&
        state == other.state &&
        street == other.street &&
        streetFull == other.streetFull &&
        fullAge == other.fullAge &&
        decadeOfAge == other.decadeOfAge &&
        isAdult == other.isAdult &&
        nationalities == other.nationalities;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, streetFull.hashCode);
    _$hash = $jc(_$hash, fullAge.hashCode);
    _$hash = $jc(_$hash, decadeOfAge.hashCode);
    _$hash = $jc(_$hash, isAdult.hashCode);
    _$hash = $jc(_$hash, nationalities.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SharedData')
          ..add('country', country)
          ..add('state', state)
          ..add('street', street)
          ..add('streetFull', streetFull)
          ..add('fullAge', fullAge)
          ..add('decadeOfAge', decadeOfAge)
          ..add('isAdult', isAdult)
          ..add('nationalities', nationalities))
        .toString();
  }
}

class SharedDataBuilder implements Builder<SharedData, SharedDataBuilder> {
  _$SharedData? _$v;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _streetFull;
  String? get streetFull => _$this._streetFull;
  set streetFull(String? streetFull) => _$this._streetFull = streetFull;

  int? _fullAge;
  int? get fullAge => _$this._fullAge;
  set fullAge(int? fullAge) => _$this._fullAge = fullAge;

  String? _decadeOfAge;
  String? get decadeOfAge => _$this._decadeOfAge;
  set decadeOfAge(String? decadeOfAge) => _$this._decadeOfAge = decadeOfAge;

  bool? _isAdult;
  bool? get isAdult => _$this._isAdult;
  set isAdult(bool? isAdult) => _$this._isAdult = isAdult;

  ListBuilder<String>? _nationalities;
  ListBuilder<String> get nationalities =>
      _$this._nationalities ??= ListBuilder<String>();
  set nationalities(ListBuilder<String>? nationalities) =>
      _$this._nationalities = nationalities;

  SharedDataBuilder() {
    SharedData._defaults(this);
  }

  SharedDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _country = $v.country;
      _state = $v.state;
      _street = $v.street;
      _streetFull = $v.streetFull;
      _fullAge = $v.fullAge;
      _decadeOfAge = $v.decadeOfAge;
      _isAdult = $v.isAdult;
      _nationalities = $v.nationalities?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SharedData other) {
    _$v = other as _$SharedData;
  }

  @override
  void update(void Function(SharedDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SharedData build() => _build();

  _$SharedData _build() {
    _$SharedData _$result;
    try {
      _$result = _$v ??
          _$SharedData._(
            country: country,
            state: state,
            street: street,
            streetFull: streetFull,
            fullAge: fullAge,
            decadeOfAge: decadeOfAge,
            isAdult: isAdult,
            nationalities: _nationalities?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nationalities';
        _nationalities?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'SharedData', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
