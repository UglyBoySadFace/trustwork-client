//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_request_create.g.dart';

/// ContactRequestCreate
///
/// Properties:
/// * [targetMatrixId] 
/// * [initialMessage] 
@BuiltValue()
abstract class ContactRequestCreate implements Built<ContactRequestCreate, ContactRequestCreateBuilder> {
  @BuiltValueField(wireName: r'target_matrix_id')
  String get targetMatrixId;

  @BuiltValueField(wireName: r'initial_message')
  String? get initialMessage;

  ContactRequestCreate._();

  factory ContactRequestCreate([void updates(ContactRequestCreateBuilder b)]) = _$ContactRequestCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactRequestCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactRequestCreate> get serializer => _$ContactRequestCreateSerializer();
}

class _$ContactRequestCreateSerializer implements PrimitiveSerializer<ContactRequestCreate> {
  @override
  final Iterable<Type> types = const [ContactRequestCreate, _$ContactRequestCreate];

  @override
  final String wireName = r'ContactRequestCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'target_matrix_id';
    yield serializers.serialize(
      object.targetMatrixId,
      specifiedType: const FullType(String),
    );
    if (object.initialMessage != null) {
      yield r'initial_message';
      yield serializers.serialize(
        object.initialMessage,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactRequestCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactRequestCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'target_matrix_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetMatrixId = valueDes;
          break;
        case r'initial_message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.initialMessage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactRequestCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactRequestCreateBuilder();
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

