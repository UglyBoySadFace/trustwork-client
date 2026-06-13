//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/sharing_preferences.dart';
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'incoming_contact_request.g.dart';

/// A pending/responded request the current user received.  The requester's identity and sharing preferences are disclosed because the requester consented by initiating contact.
///
/// Properties:
/// * [id] 
/// * [status] 
/// * [createdAt] 
/// * [requester] 
/// * [requesterSharingPreferences] 
@BuiltValue()
abstract class IncomingContactRequest implements Built<IncomingContactRequest, IncomingContactRequestBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'requester')
  ContactProfile get requester;

  @BuiltValueField(wireName: r'requester_sharing_preferences')
  SharingPreferences get requesterSharingPreferences;

  IncomingContactRequest._();

  factory IncomingContactRequest([void updates(IncomingContactRequestBuilder b)]) = _$IncomingContactRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(IncomingContactRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<IncomingContactRequest> get serializer => _$IncomingContactRequestSerializer();
}

class _$IncomingContactRequestSerializer implements PrimitiveSerializer<IncomingContactRequest> {
  @override
  final Iterable<Type> types = const [IncomingContactRequest, _$IncomingContactRequest];

  @override
  final String wireName = r'IncomingContactRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    IncomingContactRequest object, {
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
    yield r'requester';
    yield serializers.serialize(
      object.requester,
      specifiedType: const FullType(ContactProfile),
    );
    yield r'requester_sharing_preferences';
    yield serializers.serialize(
      object.requesterSharingPreferences,
      specifiedType: const FullType(SharingPreferences),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    IncomingContactRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required IncomingContactRequestBuilder result,
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
        case r'requester':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactProfile),
          ) as ContactProfile;
          result.requester.replace(valueDes);
          break;
        case r'requester_sharing_preferences':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SharingPreferences),
          ) as SharingPreferences;
          result.requesterSharingPreferences.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  IncomingContactRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = IncomingContactRequestBuilder();
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

