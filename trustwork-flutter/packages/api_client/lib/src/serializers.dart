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
import 'package:api_client/src/model/blocked_contact_request.dart';
import 'package:api_client/src/model/contact_profile.dart';
import 'package:api_client/src/model/contact_request_create.dart';
import 'package:api_client/src/model/contact_summary.dart';
import 'package:api_client/src/model/contacts_scan_request.dart';
import 'package:api_client/src/model/contacts_scan_response.dart';
import 'package:api_client/src/model/data_sharing_approve_request.dart';
import 'package:api_client/src/model/data_sharing_approve_response.dart';
import 'package:api_client/src/model/email_start_request.dart';
import 'package:api_client/src/model/email_start_response.dart';
import 'package:api_client/src/model/email_verify_request.dart';
import 'package:api_client/src/model/group_create.dart';
import 'package:api_client/src/model/group_detail.dart';
import 'package:api_client/src/model/group_invite_preview.dart';
import 'package:api_client/src/model/group_member.dart';
import 'package:api_client/src/model/group_summary.dart';
import 'package:api_client/src/model/http_validation_error.dart';
import 'package:api_client/src/model/incoming_contact_request.dart';
import 'package:api_client/src/model/location_inner.dart';
import 'package:api_client/src/model/matched_contact.dart';
import 'package:api_client/src/model/matrix_credentials.dart';
import 'package:api_client/src/model/matrix_password_response.dart';
import 'package:api_client/src/model/member_suggestion.dart';
import 'package:api_client/src/model/member_suggestion_create.dart';
import 'package:api_client/src/model/outgoing_contact_request.dart';
import 'package:api_client/src/model/phone_check_response.dart';
import 'package:api_client/src/model/refresh_request.dart';
import 'package:api_client/src/model/sharable_field.dart';
import 'package:api_client/src/model/shared_data.dart';
import 'package:api_client/src/model/sharing_preferences.dart';
import 'package:api_client/src/model/token_response.dart';
import 'package:api_client/src/model/user_profile.dart';
import 'package:api_client/src/model/validation_error.dart';

part 'serializers.g.dart';

@SerializersFor([
  AuthResponse,
  BlockedContactRequest,
  ContactProfile,
  ContactRequestCreate,
  ContactSummary,
  ContactsScanRequest,
  ContactsScanResponse,
  DataSharingApproveRequest,
  DataSharingApproveResponse,
  EmailStartRequest,
  EmailStartResponse,
  EmailVerifyRequest,
  GroupCreate,
  GroupDetail,
  GroupInvitePreview,
  GroupMember,
  GroupSummary,
  HTTPValidationError,
  IncomingContactRequest,
  LocationInner,
  MatchedContact,
  MatrixCredentials,
  MatrixPasswordResponse,
  MemberSuggestion,
  MemberSuggestionCreate,
  OutgoingContactRequest,
  PhoneCheckResponse,
  RefreshRequest,
  SharableField,
  SharedData,
  SharingPreferences,
  TokenResponse,
  UserProfile,
  ValidationError,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(IncomingContactRequest)]),
        () => ListBuilder<IncomingContactRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(GroupSummary)]),
        () => ListBuilder<GroupSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(OutgoingContactRequest)]),
        () => ListBuilder<OutgoingContactRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(BlockedContactRequest)]),
        () => ListBuilder<BlockedContactRequest>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(ContactSummary)]),
        () => ListBuilder<ContactSummary>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(MemberSuggestion)]),
        () => ListBuilder<MemberSuggestion>(),
      )
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
