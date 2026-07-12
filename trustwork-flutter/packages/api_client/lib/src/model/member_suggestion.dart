//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'member_suggestion.g.dart';

/// A suggestion shown to the admin.  `suggested` identity is only populated when the admin already knows the suggested person (an accepted contact); otherwise `admin_knows_suggested` is false and only the Matrix ID is exposed.
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [createdAt] 
/// * [suggester] 
/// * [suggestedMatrixId] 
/// * [suggested] 
/// * [adminKnowsSuggested] 
/// * [message] 
@BuiltValue()
abstract class MemberSuggestion implements Built<MemberSuggestion, MemberSuggestionBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'suggester')
  ContactProfile get suggester;

  @BuiltValueField(wireName: r'suggested_matrix_id')
  String get suggestedMatrixId;

  @BuiltValueField(wireName: r'suggested')
  ContactProfile? get suggested;

  @BuiltValueField(wireName: r'admin_knows_suggested')
  bool get adminKnowsSuggested;

  @BuiltValueField(wireName: r'message')
  String? get message;

  MemberSuggestion._();

  factory MemberSuggestion([void updates(MemberSuggestionBuilder b)]) = _$MemberSuggestion;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MemberSuggestionBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MemberSuggestion> get serializer => _$MemberSuggestionSerializer();
}

class _$MemberSuggestionSerializer implements PrimitiveSerializer<MemberSuggestion> {
  @override
  final Iterable<Type> types = const [MemberSuggestion, _$MemberSuggestion];

  @override
  final String wireName = r'MemberSuggestion';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MemberSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'suggester';
    yield serializers.serialize(
      object.suggester,
      specifiedType: const FullType(ContactProfile),
    );
    yield r'suggested_matrix_id';
    yield serializers.serialize(
      object.suggestedMatrixId,
      specifiedType: const FullType(String),
    );
    if (object.suggested != null) {
      yield r'suggested';
      yield serializers.serialize(
        object.suggested,
        specifiedType: const FullType.nullable(ContactProfile),
      );
    }
    yield r'admin_knows_suggested';
    yield serializers.serialize(
      object.adminKnowsSuggested,
      specifiedType: const FullType(bool),
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
    MemberSuggestion object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MemberSuggestionBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'suggester':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactProfile),
          ) as ContactProfile;
          result.suggester.replace(valueDes);
          break;
        case r'suggested_matrix_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.suggestedMatrixId = valueDes;
          break;
        case r'suggested':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ContactProfile),
          ) as ContactProfile?;
          if (valueDes == null) continue;
          result.suggested.replace(valueDes);
          break;
        case r'admin_knows_suggested':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.adminKnowsSuggested = valueDes;
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
  MemberSuggestion deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MemberSuggestionBuilder();
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

