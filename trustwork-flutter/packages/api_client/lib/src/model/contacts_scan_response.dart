//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/matched_contact.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contacts_scan_response.g.dart';

/// ContactsScanResponse
///
/// Properties:
/// * [matched] 
@BuiltValue()
abstract class ContactsScanResponse implements Built<ContactsScanResponse, ContactsScanResponseBuilder> {
  @BuiltValueField(wireName: r'matched')
  BuiltList<MatchedContact> get matched;

  ContactsScanResponse._();

  factory ContactsScanResponse([void updates(ContactsScanResponseBuilder b)]) = _$ContactsScanResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactsScanResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactsScanResponse> get serializer => _$ContactsScanResponseSerializer();
}

class _$ContactsScanResponseSerializer implements PrimitiveSerializer<ContactsScanResponse> {
  @override
  final Iterable<Type> types = const [ContactsScanResponse, _$ContactsScanResponse];

  @override
  final String wireName = r'ContactsScanResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactsScanResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matched';
    yield serializers.serialize(
      object.matched,
      specifiedType: const FullType(BuiltList, [FullType(MatchedContact)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactsScanResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactsScanResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matched':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MatchedContact)]),
          ) as BuiltList<MatchedContact>;
          result.matched.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactsScanResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactsScanResponseBuilder();
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

