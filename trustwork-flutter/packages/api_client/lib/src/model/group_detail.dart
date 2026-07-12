//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:api_client/src/model/group_member.dart';
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_detail.g.dart';

/// GroupDetail
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [admin] 
/// * [matrixRoomId] 
/// * [myStatus] 
/// * [members] 
@BuiltValue()
abstract class GroupDetail implements Built<GroupDetail, GroupDetailBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'admin')
  ContactProfile get admin;

  @BuiltValueField(wireName: r'matrix_room_id')
  String? get matrixRoomId;

  @BuiltValueField(wireName: r'my_status')
  String get myStatus;

  @BuiltValueField(wireName: r'members')
  BuiltList<GroupMember> get members;

  GroupDetail._();

  factory GroupDetail([void updates(GroupDetailBuilder b)]) = _$GroupDetail;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupDetailBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupDetail> get serializer => _$GroupDetailSerializer();
}

class _$GroupDetailSerializer implements PrimitiveSerializer<GroupDetail> {
  @override
  final Iterable<Type> types = const [GroupDetail, _$GroupDetail];

  @override
  final String wireName = r'GroupDetail';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'admin';
    yield serializers.serialize(
      object.admin,
      specifiedType: const FullType(ContactProfile),
    );
    if (object.matrixRoomId != null) {
      yield r'matrix_room_id';
      yield serializers.serialize(
        object.matrixRoomId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'my_status';
    yield serializers.serialize(
      object.myStatus,
      specifiedType: const FullType(String),
    );
    yield r'members';
    yield serializers.serialize(
      object.members,
      specifiedType: const FullType(BuiltList, [FullType(GroupMember)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupDetail object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupDetailBuilder result,
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
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(ContactProfile),
          ) as ContactProfile;
          result.admin.replace(valueDes);
          break;
        case r'matrix_room_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.matrixRoomId = valueDes;
          break;
        case r'my_status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.myStatus = valueDes;
          break;
        case r'members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(GroupMember)]),
          ) as BuiltList<GroupMember>;
          result.members.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupDetail deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupDetailBuilder();
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

