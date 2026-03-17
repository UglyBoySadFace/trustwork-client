//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'onboarding_token_response.g.dart';

/// OnboardingTokenResponse
///
/// Properties:
/// * [onboardingToken] 
/// * [expiresIn] 
@BuiltValue()
abstract class OnboardingTokenResponse implements Built<OnboardingTokenResponse, OnboardingTokenResponseBuilder> {
  @BuiltValueField(wireName: r'onboarding_token')
  String get onboardingToken;

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  OnboardingTokenResponse._();

  factory OnboardingTokenResponse([void updates(OnboardingTokenResponseBuilder b)]) = _$OnboardingTokenResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OnboardingTokenResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OnboardingTokenResponse> get serializer => _$OnboardingTokenResponseSerializer();
}

class _$OnboardingTokenResponseSerializer implements PrimitiveSerializer<OnboardingTokenResponse> {
  @override
  final Iterable<Type> types = const [OnboardingTokenResponse, _$OnboardingTokenResponse];

  @override
  final String wireName = r'OnboardingTokenResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OnboardingTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'onboarding_token';
    yield serializers.serialize(
      object.onboardingToken,
      specifiedType: const FullType(String),
    );
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OnboardingTokenResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required OnboardingTokenResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'onboarding_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.onboardingToken = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OnboardingTokenResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OnboardingTokenResponseBuilder();
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

