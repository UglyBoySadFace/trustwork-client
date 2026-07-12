//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_member.g.dart';

/// A member of a group, from the perspective of a joined member.  Identity is visible because joining a group makes co-members contacts.
///
/// Properties:
/// * [matrixUserId] 
/// * [displayName] 
/// * [status] 
/// * [isAdmin] 
@BuiltValue()
abstract class GroupMember implements Built<GroupMember, GroupMemberBuilder> {
  @BuiltValueField(wireName: r'matrix_user_id')
  String? get matrixUserId;

  @BuiltValueField(wireName: r'display_name')
  String get displayName;

  @BuiltValueField(wireName: r'status')
  String get status;

  @BuiltValueField(wireName: r'is_admin')
  bool? get isAdmin;

  GroupMember._();

  factory GroupMember([void updates(GroupMemberBuilder b)]) = _$GroupMember;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupMemberBuilder b) => b
      ..isAdmin = false;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupMember> get serializer => _$GroupMemberSerializer();
}

class _$GroupMemberSerializer implements PrimitiveSerializer<GroupMember> {
  @override
  final Iterable<Type> types = const [GroupMember, _$GroupMember];

  @override
  final String wireName = r'GroupMember';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupMember object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(String),
    );
    if (object.isAdmin != null) {
      yield r'is_admin';
      yield serializers.serialize(
        object.isAdmin,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupMemberBuilder result,
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
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.status = valueDes;
          break;
        case r'is_admin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isAdmin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupMember deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupMemberBuilder();
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

