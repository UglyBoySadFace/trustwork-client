//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_admin_transfer.g.dart';

/// Hand the group to another *joined* member.
///
/// Properties:
/// * [matrixUserId] 
@BuiltValue()
abstract class GroupAdminTransfer implements Built<GroupAdminTransfer, GroupAdminTransferBuilder> {
  @BuiltValueField(wireName: r'matrix_user_id')
  String get matrixUserId;

  GroupAdminTransfer._();

  factory GroupAdminTransfer([void updates(GroupAdminTransferBuilder b)]) = _$GroupAdminTransfer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupAdminTransferBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupAdminTransfer> get serializer => _$GroupAdminTransferSerializer();
}

class _$GroupAdminTransferSerializer implements PrimitiveSerializer<GroupAdminTransfer> {
  @override
  final Iterable<Type> types = const [GroupAdminTransfer, _$GroupAdminTransfer];

  @override
  final String wireName = r'GroupAdminTransfer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupAdminTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matrix_user_id';
    yield serializers.serialize(
      object.matrixUserId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupAdminTransfer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupAdminTransferBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'matrix_user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  GroupAdminTransfer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupAdminTransferBuilder();
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

