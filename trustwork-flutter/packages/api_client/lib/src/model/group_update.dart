//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_update.g.dart';

/// Rename a group. Admin only; mirrored to the Matrix room name.
///
/// Properties:
/// * [name] 
@BuiltValue()
abstract class GroupUpdate implements Built<GroupUpdate, GroupUpdateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  GroupUpdate._();

  factory GroupUpdate([void updates(GroupUpdateBuilder b)]) = _$GroupUpdate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupUpdateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupUpdate> get serializer => _$GroupUpdateSerializer();
}

class _$GroupUpdateSerializer implements PrimitiveSerializer<GroupUpdate> {
  @override
  final Iterable<Type> types = const [GroupUpdate, _$GroupUpdate];

  @override
  final String wireName = r'GroupUpdate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupUpdate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupUpdateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupUpdate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupUpdateBuilder();
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

