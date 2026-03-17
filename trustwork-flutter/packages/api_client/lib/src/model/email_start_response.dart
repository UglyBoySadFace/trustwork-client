//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_start_response.g.dart';

/// EmailStartResponse
///
/// Properties:
/// * [message] 
/// * [expiresIn] 
@BuiltValue()
abstract class EmailStartResponse implements Built<EmailStartResponse, EmailStartResponseBuilder> {
  @BuiltValueField(wireName: r'message')
  String get message;

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  EmailStartResponse._();

  factory EmailStartResponse([void updates(EmailStartResponseBuilder b)]) = _$EmailStartResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailStartResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailStartResponse> get serializer => _$EmailStartResponseSerializer();
}

class _$EmailStartResponseSerializer implements PrimitiveSerializer<EmailStartResponse> {
  @override
  final Iterable<Type> types = const [EmailStartResponse, _$EmailStartResponse];

  @override
  final String wireName = r'EmailStartResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailStartResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'message';
    yield serializers.serialize(
      object.message,
      specifiedType: const FullType(String),
    );
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailStartResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailStartResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.message = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmailStartResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailStartResponseBuilder();
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

