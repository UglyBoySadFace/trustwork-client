//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:api_client/src/date_serializer.dart';
import 'package:api_client/src/model/date.dart';

import 'package:api_client/src/model/auth_response.dart';
import 'package:api_client/src/model/contacts_scan_request.dart';
import 'package:api_client/src/model/contacts_scan_response.dart';
import 'package:api_client/src/model/email_start_request.dart';
import 'package:api_client/src/model/email_start_response.dart';
import 'package:api_client/src/model/email_verify_request.dart';
import 'package:api_client/src/model/http_validation_error.dart';
import 'package:api_client/src/model/location_inner.dart';
import 'package:api_client/src/model/matched_contact.dart';
import 'package:api_client/src/model/matrix_credentials.dart';
import 'package:api_client/src/model/matrix_password_response.dart';
import 'package:api_client/src/model/phone_check_response.dart';
import 'package:api_client/src/model/refresh_request.dart';
import 'package:api_client/src/model/token_response.dart';
import 'package:api_client/src/model/user_profile.dart';
import 'package:api_client/src/model/validation_error.dart';

part 'serializers.g.dart';

@SerializersFor([
  AuthResponse,
  ContactsScanRequest,
  ContactsScanResponse,
  EmailStartRequest,
  EmailStartResponse,
  EmailVerifyRequest,
  HTTPValidationError,
  LocationInner,
  MatchedContact,
  MatrixCredentials,
  MatrixPasswordResponse,
  PhoneCheckResponse,
  RefreshRequest,
  TokenResponse,
  UserProfile,
  ValidationError,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltMap, [FullType(String), FullType(JsonObject)]),
        () => MapBuilder<String, JsonObject>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
