//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/contact_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'group_invite_preview.g.dart';

/// What an invitee needs to render the join prompt *before* joining.  Only counts are exposed — identities of members the invitee doesn't already know stay hidden until they join (joining is the consent that reveals them).
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [admin] 
/// * [totalMembers] 
/// * [knownCount] 
/// * [unknownCount] 
/// * [suggestedBy] 
@BuiltValue()
abstract class GroupInvitePreview implements Built<GroupInvitePreview, GroupInvitePreviewBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'admin')
  ContactProfile get admin;

  @BuiltValueField(wireName: r'total_members')
  int get totalMembers;

  @BuiltValueField(wireName: r'known_count')
  int get knownCount;

  @BuiltValueField(wireName: r'unknown_count')
  int get unknownCount;

  @BuiltValueField(wireName: r'suggested_by')
  ContactProfile? get suggestedBy;

  GroupInvitePreview._();

  factory GroupInvitePreview([void updates(GroupInvitePreviewBuilder b)]) = _$GroupInvitePreview;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GroupInvitePreviewBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GroupInvitePreview> get serializer => _$GroupInvitePreviewSerializer();
}

class _$GroupInvitePreviewSerializer implements PrimitiveSerializer<GroupInvitePreview> {
  @override
  final Iterable<Type> types = const [GroupInvitePreview, _$GroupInvitePreview];

  @override
  final String wireName = r'GroupInvitePreview';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GroupInvitePreview object, {
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
    yield r'total_members';
    yield serializers.serialize(
      object.totalMembers,
      specifiedType: const FullType(int),
    );
    yield r'known_count';
    yield serializers.serialize(
      object.knownCount,
      specifiedType: const FullType(int),
    );
    yield r'unknown_count';
    yield serializers.serialize(
      object.unknownCount,
      specifiedType: const FullType(int),
    );
    if (object.suggestedBy != null) {
      yield r'suggested_by';
      yield serializers.serialize(
        object.suggestedBy,
        specifiedType: const FullType.nullable(ContactProfile),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    GroupInvitePreview object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GroupInvitePreviewBuilder result,
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
        case r'total_members':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.totalMembers = valueDes;
          break;
        case r'known_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.knownCount = valueDes;
          break;
        case r'unknown_count':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.unknownCount = valueDes;
          break;
        case r'suggested_by':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(ContactProfile),
          ) as ContactProfile?;
          if (valueDes == null) continue;
          result.suggestedBy.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  GroupInvitePreview deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GroupInvitePreviewBuilder();
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

