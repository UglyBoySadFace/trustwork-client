// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AuthResponse.serializer)
      ..add(ContactsScanRequest.serializer)
      ..add(ContactsScanResponse.serializer)
      ..add(EmailStartRequest.serializer)
      ..add(EmailStartResponse.serializer)
      ..add(EmailVerifyRequest.serializer)
      ..add(HTTPValidationError.serializer)
      ..add(LocationInner.serializer)
      ..add(MatchedContact.serializer)
      ..add(MatrixCredentials.serializer)
      ..add(PhoneCheckResponse.serializer)
      ..add(RefreshRequest.serializer)
      ..add(TokenResponse.serializer)
      ..add(UserProfile.serializer)
      ..add(ValidationError.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(LocationInner)]),
          () => ListBuilder<LocationInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(MatchedContact)]),
          () => ListBuilder<MatchedContact>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(ValidationError)]),
          () => ListBuilder<ValidationError>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
