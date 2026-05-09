//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sharing_preferences.g.dart';

/// SharingPreferences
///
/// Properties:
/// * [shareCountry] 
/// * [shareState] 
/// * [shareStreet] 
/// * [shareStreetFull] 
/// * [shareFullAge] 
/// * [shareDecadeOfAge] 
/// * [shareIsAdult] 
/// * [shareNationalities] 
@BuiltValue()
abstract class SharingPreferences implements Built<SharingPreferences, SharingPreferencesBuilder> {
  @BuiltValueField(wireName: r'share_country')
  bool? get shareCountry;

  @BuiltValueField(wireName: r'share_state')
  bool? get shareState;

  @BuiltValueField(wireName: r'share_street')
  bool? get shareStreet;

  @BuiltValueField(wireName: r'share_street_full')
  bool? get shareStreetFull;

  @BuiltValueField(wireName: r'share_full_age')
  bool? get shareFullAge;

  @BuiltValueField(wireName: r'share_decade_of_age')
  bool? get shareDecadeOfAge;

  @BuiltValueField(wireName: r'share_is_adult')
  bool? get shareIsAdult;

  @BuiltValueField(wireName: r'share_nationalities')
  bool? get shareNationalities;

  SharingPreferences._();

  factory SharingPreferences([void updates(SharingPreferencesBuilder b)]) = _$SharingPreferences;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SharingPreferencesBuilder b) => b
      ..shareCountry = false
      ..shareState = false
      ..shareStreet = false
      ..shareStreetFull = false
      ..shareFullAge = false
      ..shareDecadeOfAge = false
      ..shareIsAdult = false
      ..shareNationalities = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<SharingPreferences> get serializer => _$SharingPreferencesSerializer();
}

class _$SharingPreferencesSerializer implements PrimitiveSerializer<SharingPreferences> {
  @override
  final Iterable<Type> types = const [SharingPreferences, _$SharingPreferences];

  @override
  final String wireName = r'SharingPreferences';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SharingPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.shareCountry != null) {
      yield r'share_country';
      yield serializers.serialize(
        object.shareCountry,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareState != null) {
      yield r'share_state';
      yield serializers.serialize(
        object.shareState,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareStreet != null) {
      yield r'share_street';
      yield serializers.serialize(
        object.shareStreet,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareStreetFull != null) {
      yield r'share_street_full';
      yield serializers.serialize(
        object.shareStreetFull,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareFullAge != null) {
      yield r'share_full_age';
      yield serializers.serialize(
        object.shareFullAge,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareDecadeOfAge != null) {
      yield r'share_decade_of_age';
      yield serializers.serialize(
        object.shareDecadeOfAge,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareIsAdult != null) {
      yield r'share_is_adult';
      yield serializers.serialize(
        object.shareIsAdult,
        specifiedType: const FullType(bool),
      );
    }
    if (object.shareNationalities != null) {
      yield r'share_nationalities';
      yield serializers.serialize(
        object.shareNationalities,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    SharingPreferences object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SharingPreferencesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'share_country':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareCountry = valueDes;
          break;
        case r'share_state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareState = valueDes;
          break;
        case r'share_street':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareStreet = valueDes;
          break;
        case r'share_street_full':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareStreetFull = valueDes;
          break;
        case r'share_full_age':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareFullAge = valueDes;
          break;
        case r'share_decade_of_age':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareDecadeOfAge = valueDes;
          break;
        case r'share_is_adult':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareIsAdult = valueDes;
          break;
        case r'share_nationalities':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.shareNationalities = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SharingPreferences deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SharingPreferencesBuilder();
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

