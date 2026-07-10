//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'outgoing_contact_request.g.dart';

/// A request the current user sent.  `target` is only populated once the request is accepted — until then the target stays anonymous (the requester only knows the Matrix ID they sent to).
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [targetMatrixId] 
/// * [createdAt] 
/// * [respondedAt] 
/// * [target] 
/// * [matrixRoomId] 
@BuiltValue()
abstract class OutgoingContactRequest implements Built<OutgoingContactRequest, OutgoingContactRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'target_matrix_id')
  String get targetMatrixId;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'responded_at')
  DateTime? get respondedAt;

  @BuiltValueField(wireName: r'target')
  ContactProfile? get target;

  @BuiltValueField(wireName: r'matrix_room_id')
  String? get matrixRoomId;

  OutgoingContactRequest._();

  factory OutgoingContactRequest([void updates(OutgoingContactRequestBuilder b)]) = _$OutgoingContactRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OutgoingContactRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OutgoingContactRequest> get serializer => _$OutgoingContactRequestSerializer();
}

class _$OutgoingContactRequestSerializer implements PrimitiveSerializer<OutgoingContactRequest> {
  @override
  final Iterable<Type> types = const [OutgoingContactRequest, _$OutgoingContactRequest];

  @override
  final String wireName = r'OutgoingContactRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OutgoingContactRequest object, {
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
    yield r'target_matrix_id';
    yield serializers.serialize(
      object.targetMatrixId,
      specifiedType: const FullType(String),
    );
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.respondedAt != null) {
      yield r'responded_at';
      yield serializers.serialize(
        object.respondedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    if (object.target != null) {
      yield r'target';
      yield serializers.serialize(
        object.target,
        specifiedType: const FullType.nullable(ContactProfile),
      );
    }
    if (object.matrixRoomId != null) {
      yield r'matrix_room_id';
      yield serializers.serialize(
        object.matrixRoomId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    OutgoingContactRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OutgoingContactRequestBuilder result,
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
        case r'target_matrix_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.targetMatrixId = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'responded_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.respondedAt = valueDes;
          break;
        case r'target':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ContactProfile),
          ) as ContactProfile?;
          if (valueDes == null) continue;
          result.target.replace(valueDes);
          break;
        case r'matrix_room_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.matrixRoomId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OutgoingContactRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OutgoingContactRequestBuilder();
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

