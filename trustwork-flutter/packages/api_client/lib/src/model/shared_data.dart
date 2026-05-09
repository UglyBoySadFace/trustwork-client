//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'shared_data.g.dart';

/// SharedData
///
/// Properties:
/// * [country] 
/// * [state] 
/// * [street] 
/// * [streetFull] 
/// * [fullAge] 
/// * [decadeOfAge] 
/// * [isAdult] 
/// * [nationalities] 
@BuiltValue()
abstract class SharedData implements Built<SharedData, SharedDataBuilder> {
  @BuiltValueField(wireName: r'country')
  String? get country;

  @BuiltValueField(wireName: r'state')
  String? get state;

  @BuiltValueField(wireName: r'street')
  String? get street;

  @BuiltValueField(wireName: r'street_full')
  String? get streetFull;

  @BuiltValueField(wireName: r'full_age')
  int? get fullAge;

  @BuiltValueField(wireName: r'decade_of_age')
  String? get decadeOfAge;

  @BuiltValueField(wireName: r'is_adult')
  bool? get isAdult;

  @BuiltValueField(wireName: r'nationalities')
  BuiltList<String>? get nationalities;

  SharedData._();

  factory SharedData([void updates(SharedDataBuilder b)]) = _$SharedData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharedDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharedData> get serializer => _$SharedDataSerializer();
}

class _$SharedDataSerializer implements PrimitiveSerializer<SharedData> {
  @override
  final Iterable<Type> types = const [SharedData, _$SharedData];

  @override
  final String wireName = r'SharedData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharedData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.country != null) {
      yield r'country';
      yield serializers.serialize(
        object.country,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.state != null) {
      yield r'state';
      yield serializers.serialize(
        object.state,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.street != null) {
      yield r'street';
      yield serializers.serialize(
        object.street,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.streetFull != null) {
      yield r'street_full';
      yield serializers.serialize(
        object.streetFull,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.fullAge != null) {
      yield r'full_age';
      yield serializers.serialize(
        object.fullAge,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.decadeOfAge != null) {
      yield r'decade_of_age';
      yield serializers.serialize(
        object.decadeOfAge,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.isAdult != null) {
      yield r'is_adult';
      yield serializers.serialize(
        object.isAdult,
        specifiedType: const FullType.nullable(bool),
      );
    }
    if (object.nationalities != null) {
      yield r'nationalities';
      yield serializers.serialize(
        object.nationalities,
        specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SharedData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharedDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.country = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.state = valueDes;
          break;
        case r'street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.street = valueDes;
          break;
        case r'street_full':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.streetFull = valueDes;
          break;
        case r'full_age':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.fullAge = valueDes;
          break;
        case r'decade_of_age':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.decadeOfAge = valueDes;
          break;
        case r'is_adult':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.isAdult = valueDes;
          break;
        case r'nationalities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.nationalities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SharedData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharedDataBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

