//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'contact_profile.g.dart';

/// Minimal public-facing profile of another user.
///
/// Properties:
/// * [matrixUserId] 
/// * [displayName] 
@BuiltValue()
abstract class ContactProfile implements Built<ContactProfile, ContactProfileBuilder> {
  @BuiltValueField(wireName: r'matrix_user_id')
  String? get matrixUserId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  ContactProfile._();

  factory ContactProfile([void updates(ContactProfileBuilder b)]) = _$ContactProfile;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ContactProfileBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ContactProfile> get serializer => _$ContactProfileSerializer();
}

class _$ContactProfileSerializer implements PrimitiveSerializer<ContactProfile> {
  @override
  final Iterable<Type> types = const [ContactProfile, _$ContactProfile];

  @override
  final String wireName = r'ContactProfile';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ContactProfile object, {
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
    ContactProfile object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ContactProfileBuilder result,
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
  ContactProfile deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ContactProfileBuilder();
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

