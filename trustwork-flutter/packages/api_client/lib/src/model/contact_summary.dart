//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_summary.g.dart';

/// An accepted, two-way contact.
///
/// Properties:
/// * [matrixUserId] 
/// * [displayName] 
@BuiltValue()
abstract class ContactSummary implements Built<ContactSummary, ContactSummaryBuilder> {
  @BuiltValueField(wireName: r'matrix_user_id')
  String? get matrixUserId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  ContactSummary._();

  factory ContactSummary([void updates(ContactSummaryBuilder b)]) = _$ContactSummary;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactSummaryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactSummary> get serializer => _$ContactSummarySerializer();
}

class _$ContactSummarySerializer implements PrimitiveSerializer<ContactSummary> {
  @override
  final Iterable<Type> types = const [ContactSummary, _$ContactSummary];

  @override
  final String wireName = r'ContactSummary';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.matrixUserId != null) {
      yield r'matrix_user_id';
      yield serializers.serialize(
        object.matrixUserId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ContactSummary object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactSummaryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matrix_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.matrixUserId = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ContactSummary deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactSummaryBuilder();
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

