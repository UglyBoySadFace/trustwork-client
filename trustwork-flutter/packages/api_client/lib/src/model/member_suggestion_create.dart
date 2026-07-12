//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_suggestion_create.g.dart';

/// MemberSuggestionCreate
///
/// Properties:
/// * [suggestedMatrixId] 
/// * [message] 
@BuiltValue()
abstract class MemberSuggestionCreate implements Built<MemberSuggestionCreate, MemberSuggestionCreateBuilder> {
  @BuiltValueField(wireName: r'suggested_matrix_id')
  String get suggestedMatrixId;

  @BuiltValueField(wireName: r'message')
  String? get message;

  MemberSuggestionCreate._();

  factory MemberSuggestionCreate([void updates(MemberSuggestionCreateBuilder b)]) = _$MemberSuggestionCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberSuggestionCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberSuggestionCreate> get serializer => _$MemberSuggestionCreateSerializer();
}

class _$MemberSuggestionCreateSerializer implements PrimitiveSerializer<MemberSuggestionCreate> {
  @override
  final Iterable<Type> types = const [MemberSuggestionCreate, _$MemberSuggestionCreate];

  @override
  final String wireName = r'MemberSuggestionCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberSuggestionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'suggested_matrix_id';
    yield serializers.serialize(
      object.suggestedMatrixId,
      specifiedType: const FullType(String),
    );
    if (object.message != null) {
      yield r'message';
      yield serializers.serialize(
        object.message,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MemberSuggestionCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberSuggestionCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'suggested_matrix_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.suggestedMatrixId = valueDes;
          break;
        case r'message':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MemberSuggestionCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberSuggestionCreateBuilder();
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

