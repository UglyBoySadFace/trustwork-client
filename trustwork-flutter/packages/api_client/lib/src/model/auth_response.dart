//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:api_client/src/model/matrix_credentials.dart';
import 'package:api_client/src/model/user_profile.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_response.g.dart';

/// AuthResponse
///
/// Properties:
/// * [accessToken] 
/// * [refreshToken] 
/// * [tokenType] 
/// * [expiresIn] 
/// * [loginToken] 
/// * [matrixDeviceId] 
/// * [matrix] 
/// * [user] 
@BuiltValue()
abstract class AuthResponse implements Built<AuthResponse, AuthResponseBuilder> {
  @BuiltValueField(wireName: r'access_token')
  String get accessToken;

  @BuiltValueField(wireName: r'refresh_token')
  String get refreshToken;

  @BuiltValueField(wireName: r'token_type')
  String? get tokenType;

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  @BuiltValueField(wireName: r'login_token')
  String? get loginToken;

  @BuiltValueField(wireName: r'matrix_device_id')
  String? get matrixDeviceId;

  @BuiltValueField(wireName: r'matrix')
  MatrixCredentials? get matrix;

  @BuiltValueField(wireName: r'user')
  UserProfile get user;

  AuthResponse._();

  factory AuthResponse([void updates(AuthResponseBuilder b)]) = _$AuthResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthResponseBuilder b) => b
      ..tokenType = 'bearer';

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthResponse> get serializer => _$AuthResponseSerializer();
}

class _$AuthResponseSerializer implements PrimitiveSerializer<AuthResponse> {
  @override
  final Iterable<Type> types = const [AuthResponse, _$AuthResponse];

  @override
  final String wireName = r'AuthResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'access_token';
    yield serializers.serialize(
      object.accessToken,
      specifiedType: const FullType(String),
    );
    yield r'refresh_token';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
    if (object.tokenType != null) {
      yield r'token_type';
      yield serializers.serialize(
        object.tokenType,
        specifiedType: const FullType(String),
      );
    }
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    if (object.loginToken != null) {
      yield r'login_token';
      yield serializers.serialize(
        object.loginToken,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.matrixDeviceId != null) {
      yield r'matrix_device_id';
      yield serializers.serialize(
        object.matrixDeviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.matrix != null) {
      yield r'matrix';
      yield serializers.serialize(
        object.matrix,
        specifiedType: const FullType.nullable(MatrixCredentials),
      );
    }
    yield r'user';
    yield serializers.serialize(
      object.user,
      specifiedType: const FullType(UserProfile),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'access_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accessToken = valueDes;
          break;
        case r'refresh_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        case r'token_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.tokenType = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'login_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.loginToken = valueDes;
          break;
        case r'matrix_device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.matrixDeviceId = valueDes;
          break;
        case r'matrix':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MatrixCredentials),
          ) as MatrixCredentials?;
          if (valueDes == null) continue;
          result.matrix.replace(valueDes);
          break;
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(UserProfile),
          ) as UserProfile;
          result.user.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthResponseBuilder();
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

