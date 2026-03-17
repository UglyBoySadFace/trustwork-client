//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_start_request.g.dart';

/// EmailStartRequest
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class EmailStartRequest implements Built<EmailStartRequest, EmailStartRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  EmailStartRequest._();

  factory EmailStartRequest([void updates(EmailStartRequestBuilder b)]) = _$EmailStartRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailStartRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailStartRequest> get serializer => _$EmailStartRequestSerializer();
}

class _$EmailStartRequestSerializer implements PrimitiveSerializer<EmailStartRequest> {
  @override
  final Iterable<Type> types = const [EmailStartRequest, _$EmailStartRequest];

  @override
  final String wireName = r'EmailStartRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    EmailStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailStartRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  EmailStartRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailStartRequestBuilder();
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

