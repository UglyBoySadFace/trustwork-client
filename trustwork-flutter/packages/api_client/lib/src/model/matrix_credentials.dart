//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'matrix_credentials.g.dart';

/// MatrixCredentials
///
/// Properties:
/// * [matrixUserId] 
/// * [matrixAccessToken] 
/// * [matrixPassword] 
@BuiltValue()
abstract class MatrixCredentials implements Built<MatrixCredentials, MatrixCredentialsBuilder> {
  @BuiltValueField(wireName: r'matrix_user_id')
  String get matrixUserId;

  @BuiltValueField(wireName: r'matrix_access_token')
  String get matrixAccessToken;

  @BuiltValueField(wireName: r'matrix_password')
  String get matrixPassword;

  MatrixCredentials._();

  factory MatrixCredentials([void updates(MatrixCredentialsBuilder b)]) = _$MatrixCredentials;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MatrixCredentialsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MatrixCredentials> get serializer => _$MatrixCredentialsSerializer();
}

class _$MatrixCredentialsSerializer implements PrimitiveSerializer<MatrixCredentials> {
  @override
  final Iterable<Type> types = const [MatrixCredentials, _$MatrixCredentials];

  @override
  final String wireName = r'MatrixCredentials';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MatrixCredentials object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'matrix_user_id';
    yield serializers.serialize(
      object.matrixUserId,
      specifiedType: const FullType(String),
    );
    yield r'matrix_access_token';
    yield serializers.serialize(
      object.matrixAccessToken,
      specifiedType: const FullType(String),
    );
    yield r'matrix_password';
    yield serializers.serialize(
      object.matrixPassword,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MatrixCredentials object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MatrixCredentialsBuilder result,
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
        case r'matrix_access_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matrixAccessToken = valueDes;
          break;
        case r'matrix_password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.matrixPassword = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MatrixCredentials deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MatrixCredentialsBuilder();
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

