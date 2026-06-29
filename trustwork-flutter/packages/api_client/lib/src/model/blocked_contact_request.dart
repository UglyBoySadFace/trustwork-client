//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'blocked_contact_request.g.dart';

/// A request the current user blocked — used to surface an Unblock action.
///
/// Properties:
/// * [id] 
/// * [requester] 
/// * [blockedAt] 
@BuiltValue()
abstract class BlockedContactRequest implements Built<BlockedContactRequest, BlockedContactRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'requester')
  ContactProfile get requester;

  @BuiltValueField(wireName: r'blocked_at')
  DateTime? get blockedAt;

  BlockedContactRequest._();

  factory BlockedContactRequest([void updates(BlockedContactRequestBuilder b)]) = _$BlockedContactRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BlockedContactRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BlockedContactRequest> get serializer => _$BlockedContactRequestSerializer();
}

class _$BlockedContactRequestSerializer implements PrimitiveSerializer<BlockedContactRequest> {
  @override
  final Iterable<Type> types = const [BlockedContactRequest, _$BlockedContactRequest];

  @override
  final String wireName = r'BlockedContactRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BlockedContactRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'requester';
    yield serializers.serialize(
      object.requester,
      specifiedType: const FullType(ContactProfile),
    );
    if (object.blockedAt != null) {
      yield r'blocked_at';
      yield serializers.serialize(
        object.blockedAt,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BlockedContactRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BlockedContactRequestBuilder result,
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
        case r'requester':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactProfile),
          ) as ContactProfile;
          result.requester.replace(valueDes);
          break;
        case r'blocked_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.blockedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BlockedContactRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BlockedContactRequestBuilder();
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

