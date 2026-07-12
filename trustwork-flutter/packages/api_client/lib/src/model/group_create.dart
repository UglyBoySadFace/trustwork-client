//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_create.g.dart';

/// GroupCreate
///
/// Properties:
/// * [name] 
/// * [memberMatrixIds] 
@BuiltValue()
abstract class GroupCreate implements Built<GroupCreate, GroupCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'member_matrix_ids')
  BuiltList<String> get memberMatrixIds;

  GroupCreate._();

  factory GroupCreate([void updates(GroupCreateBuilder b)]) = _$GroupCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupCreate> get serializer => _$GroupCreateSerializer();
}

class _$GroupCreateSerializer implements PrimitiveSerializer<GroupCreate> {
  @override
  final Iterable<Type> types = const [GroupCreate, _$GroupCreate];

  @override
  final String wireName = r'GroupCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'member_matrix_ids';
    yield serializers.serialize(
      object.memberMatrixIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupCreateBuilder result,
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
        case r'member_matrix_ids':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.memberMatrixIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupCreateBuilder();
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

