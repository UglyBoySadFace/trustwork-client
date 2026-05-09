//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sharable_field.g.dart';

class SharableField extends EnumClass {

  @BuiltValueEnumConst(wireName: r'country')
  static const SharableField country = _$country;
  @BuiltValueEnumConst(wireName: r'state')
  static const SharableField state = _$state;
  @BuiltValueEnumConst(wireName: r'street')
  static const SharableField street = _$street;
  @BuiltValueEnumConst(wireName: r'street_full')
  static const SharableField streetFull = _$streetFull;
  @BuiltValueEnumConst(wireName: r'full_age')
  static const SharableField fullAge = _$fullAge;
  @BuiltValueEnumConst(wireName: r'decade_of_age')
  static const SharableField decadeOfAge = _$decadeOfAge;
  @BuiltValueEnumConst(wireName: r'is_adult')
  static const SharableField isAdult = _$isAdult;
  @BuiltValueEnumConst(wireName: r'nationalities')
  static const SharableField nationalities = _$nationalities;

  static Serializer<SharableField> get serializer => _$sharableFieldSerializer;

  const SharableField._(String name): super(name);

  static BuiltSet<SharableField> get values => _$values;
  static SharableField valueOf(String name) => _$valueOf(name);
}

/// Optionally, enum_class can generate a mixin to go with your enum for use
/// with Angular. It exposes your enum constants as getters. So, if you mix it
/// in to your Dart component class, the values become available to the
/// corresponding Angular template.
///
/// Trigger mixin generation by writing a line like this one next to your enum.
abstract class SharableFieldMixin = Object with _$SharableFieldMixin;

