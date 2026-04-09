//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contacts_scan_request.g.dart';

/// Client sends SHA-256 hashes of phone numbers (hex-encoded, lowercased).
///
/// Properties:
/// * [phoneHashes] 
@BuiltValue()
abstract class ContactsScanRequest implements Built<ContactsScanRequest, ContactsScanRequestBuilder> {
  @BuiltValueField(wireName: r'phone_hashes')
  BuiltList<String> get phoneHashes;

  ContactsScanRequest._();

  factory ContactsScanRequest([void updates(ContactsScanRequestBuilder b)]) = _$ContactsScanRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactsScanRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactsScanRequest> get serializer => _$ContactsScanRequestSerializer();
}

class _$ContactsScanRequestSerializer implements PrimitiveSerializer<ContactsScanRequest> {
  @override
  final Iterable<Type> types = const [ContactsScanRequest, _$ContactsScanRequest];

  @override
  final String wireName = r'ContactsScanRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactsScanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone_hashes';
    yield serializers.serialize(
      object.phoneHashes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactsScanRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactsScanRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone_hashes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.phoneHashes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactsScanRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactsScanRequestBuilder();
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

