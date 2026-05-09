// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharable_field.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const SharableField _$country = const SharableField._('country');
const SharableField _$state = const SharableField._('state');
const SharableField _$street = const SharableField._('street');
const SharableField _$streetFull = const SharableField._('streetFull');
const SharableField _$fullAge = const SharableField._('fullAge');
const SharableField _$decadeOfAge = const SharableField._('decadeOfAge');
const SharableField _$isAdult = const SharableField._('isAdult');
const SharableField _$nationalities = const SharableField._('nationalities');

SharableField _$valueOf(String name) {
  switch (name) {
    case 'country':
      return _$country;
    case 'state':
      return _$state;
    case 'street':
      return _$street;
    case 'streetFull':
      return _$streetFull;
    case 'fullAge':
      return _$fullAge;
    case 'decadeOfAge':
      return _$decadeOfAge;
    case 'isAdult':
      return _$isAdult;
    case 'nationalities':
      return _$nationalities;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<SharableField> _$values =
    BuiltSet<SharableField>(const <SharableField>[
  _$country,
  _$state,
  _$street,
  _$streetFull,
  _$fullAge,
  _$decadeOfAge,
  _$isAdult,
  _$nationalities,
]);

class _$SharableFieldMeta {
  const _$SharableFieldMeta();
  SharableField get country => _$country;
  SharableField get state => _$state;
  SharableField get street => _$street;
  SharableField get streetFull => _$streetFull;
  SharableField get fullAge => _$fullAge;
  SharableField get decadeOfAge => _$decadeOfAge;
  SharableField get isAdult => _$isAdult;
  SharableField get nationalities => _$nationalities;
  SharableField valueOf(String name) => _$valueOf(name);
  BuiltSet<SharableField> get values => _$values;
}

abstract class _$SharableFieldMixin {
  // ignore: non_constant_identifier_names
  _$SharableFieldMeta get SharableField => const _$SharableFieldMeta();
}

Serializer<SharableField> _$sharableFieldSerializer =
    _$SharableFieldSerializer();

class _$SharableFieldSerializer implements PrimitiveSerializer<SharableField> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'country': 'country',
    'state': 'state',
    'street': 'street',
    'streetFull': 'street_full',
    'fullAge': 'full_age',
    'decadeOfAge': 'decade_of_age',
    'isAdult': 'is_adult',
    'nationalities': 'nationalities',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'country': 'country',
    'state': 'state',
    'street': 'street',
    'street_full': 'streetFull',
    'full_age': 'fullAge',
    'decade_of_age': 'decadeOfAge',
    'is_adult': 'isAdult',
    'nationalities': 'nationalities',
  };

  @override
  final Iterable<Type> types = const <Type>[SharableField];
  @override
  final String wireName = 'SharableField';

  @override
  Object serialize(Serializers serializers, SharableField object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  SharableField deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      SharableField.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
