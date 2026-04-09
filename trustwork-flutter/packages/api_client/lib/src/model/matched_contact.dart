//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matched_contact.g.dart';

/// MatchedContact
///
/// Properties:
/// * [phoneHash] 
/// * [displayName] 
/// * [matrixUserId] 
@BuiltValue()
abstract class MatchedContact implements Built<MatchedContact, MatchedContactBuilder> {
  @BuiltValueField(wireName: r'phone_hash')
  String get phoneHash;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'matrix_user_id')
  String? get matrixUserId;

  MatchedContact._();

  factory MatchedContact([void updates(MatchedContactBuilder b)]) = _$MatchedContact;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatchedContactBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatchedContact> get serializer => _$MatchedContactSerializer();
}

class _$MatchedContactSerializer implements PrimitiveSerializer<MatchedContact> {
  @override
  final Iterable<Type> types = const [MatchedContact, _$MatchedContact];

  @override
  final String wireName = r'MatchedContact';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatchedContact object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone_hash';
    yield serializers.serialize(
      object.phoneHash,
      specifiedType: const FullType(String),
    );
    yield r'display_name';
    yield serializers.serialize(
      object.displayName,
      specifiedType: const FullType(String),
    );
    if (object.matrixUserId != null) {
      yield r'matrix_user_id';
      yield serializers.serialize(
        object.matrixUserId,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    MatchedContact object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatchedContactBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.phoneHash = valueDes;
          break;
        case r'display_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.displayName = valueDes;
          break;
        case r'matrix_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.matrixUserId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatchedContact deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatchedContactBuilder();
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

