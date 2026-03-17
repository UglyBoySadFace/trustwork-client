//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'phone_check_response.g.dart';

/// PhoneCheckResponse
///
/// Properties:
/// * [phone] 
/// * [registered] 
@BuiltValue()
abstract class PhoneCheckResponse implements Built<PhoneCheckResponse, PhoneCheckResponseBuilder> {
  @BuiltValueField(wireName: r'phone')
  String get phone;

  @BuiltValueField(wireName: r'registered')
  bool get registered;

  PhoneCheckResponse._();

  factory PhoneCheckResponse([void updates(PhoneCheckResponseBuilder b)]) = _$PhoneCheckResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PhoneCheckResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PhoneCheckResponse> get serializer => _$PhoneCheckResponseSerializer();
}

class _$PhoneCheckResponseSerializer implements PrimitiveSerializer<PhoneCheckResponse> {
  @override
  final Iterable<Type> types = const [PhoneCheckResponse, _$PhoneCheckResponse];

  @override
  final String wireName = r'PhoneCheckResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PhoneCheckResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
    yield r'registered';
    yield serializers.serialize(
      object.registered,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PhoneCheckResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PhoneCheckResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phone = valueDes;
          break;
        case r'registered':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.registered = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PhoneCheckResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PhoneCheckResponseBuilder();
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

