import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:fluffychat/config/app_config.dart';

class TrustworkApiService {
  static const _keyAccessToken = 'tw_access_token';
  static const _keyRefreshToken = 'tw_refresh_token';
  static const _keyMatrixPassword = 'tw_matrix_password';

  static final instance = TrustworkApiService._();
  TrustworkApiService._();

  final _authExpiredController = StreamController<void>.broadcast();

  /// Fires when the Trustwork session is definitively expired — the refresh
  /// token itself returned 401, meaning re-authentication is required.
  /// Tokens are cleared before the event is emitted.
  Stream<void> get onAuthExpired => _authExpiredController.stream;

  final _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.trustworkApiBaseUrl,
      connectTimeout: const Duration(milliseconds: 5000),
      receiveTimeout: const Duration(milliseconds: 10000),
    ),
  )..interceptors.add(_RedactingLogInterceptor());

  /// Test-only access to the underlying [Dio] instance (e.g. for swapping
  /// `httpClientAdapter` with a mock).
  @visibleForTesting
  Dio get dio => _dio;

  late final _apiClient = ApiClient(dio: _dio);
  final _storage = const FlutterSecureStorage();

  PhoneAuthApi get phoneAuth => _apiClient.getPhoneAuthApi();
  EmailAuthApi get emailAuth => _apiClient.getEmailAuthApi();
  TokenApi get token => _apiClient.getTokenApi();
  SharingApi get sharing => _apiClient.getSharingApi();
  ContactsApi get contacts => _apiClient.getContactsApi();
  GroupsApi get groups => _apiClient.getGroupsApi();

  Map<String, String> _authHeader(String token) =>
      <String, String>{'Authorization': 'Bearer $token'};

  /// Sends a contact request to the user behind [targetMatrixId].
  /// [initialMessage] is an optional greeting (max 2000 chars) shown to the
  /// recipient before they decide. Stored plaintext, not E2EE.
  Future<OutgoingContactRequest> createContactRequest(
    String targetMatrixId, {
    String? initialMessage,
  }) async {
    final response = await authedRequest(
      (token) => contacts.createContactRequestContactsRequestsPost(
        contactRequestCreate: ContactRequestCreate(
          (b) => b
            ..targetMatrixId = targetMatrixId
            ..initialMessage = initialMessage,
        ),
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Requests sent to me, awaiting my decision.
  Future<BuiltList<IncomingContactRequest>> getIncomingContactRequests() async {
    final response = await authedRequest(
      (token) => contacts.listIncomingRequestsContactsRequestsIncomingGet(
        headers: _authHeader(token),
      ),
    );
    return response.data ?? BuiltList();
  }

  /// Requests I sent, with their current status.
  Future<BuiltList<OutgoingContactRequest>> getOutgoingContactRequests() async {
    final response = await authedRequest(
      (token) => contacts.listOutgoingRequestsContactsRequestsOutgoingGet(
        headers: _authHeader(token),
      ),
    );
    return response.data ?? BuiltList();
  }

  /// Accepts a pending incoming contact request, revealing my identity to
  /// the requester and opening messaging.
  Future<ContactSummary> acceptContactRequest(int requestId) async {
    final response = await authedRequest(
      (token) => contacts.acceptContactRequestContactsRequestsRequestIdAcceptPost(
        requestId: requestId,
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Declines a pending incoming contact request.
  Future<void> declineContactRequest(int requestId) => authedRequest(
    (token) => contacts.declineContactRequestContactsRequestsRequestIdDeclinePost(
      requestId: requestId,
      headers: _authHeader(token),
    ),
  );

  /// Blocks the requester of a pending incoming contact request.
  Future<void> blockContactRequest(int requestId) => authedRequest(
    (token) => contacts.blockContactRequestContactsRequestsRequestIdBlockPost(
      requestId: requestId,
      headers: _authHeader(token),
    ),
  );

  /// Resets a blocked request back to pending (only the blocker may call this).
  Future<void> unblockContactRequest(int requestId) => authedRequest(
    (token) =>
        contacts.unblockContactRequestContactsRequestsRequestIdUnblockPost(
      requestId: requestId,
      headers: _authHeader(token),
    ),
  );

  /// Removes an accepted two-way contact.
  Future<void> removeContact(String matrixUserId) => authedRequest(
    (token) => contacts.removeContactContactsMatrixUserIdDelete(
      matrixUserId: matrixUserId,
      headers: _authHeader(token),
    ),
  );

  /// Current user's Trustwork profile (includes BankID display name).
  Future<UserProfile> getMe() async {
    final response = await authedRequest(
      (accessToken) => token.getMeMeGet(headers: _authHeader(accessToken)),
    );
    return response.data!;
  }

  /// Accepted, two-way contacts.
  Future<BuiltList<ContactSummary>> getContacts() async {
    final response = await authedRequest(
      (token) => contacts.listContactsContactsGet(
        headers: _authHeader(token),
      ),
    );
    return response.data ?? BuiltList();
  }

  /// Groups I belong to or am invited to.
  Future<BuiltList<GroupSummary>> listGroups() async {
    final response = await authedRequest(
      (token) => groups.listGroupsGroupsGet(headers: _authHeader(token)),
    );
    return response.data ?? BuiltList();
  }

  /// Creates a group and invites [memberMxids]. The caller becomes admin.
  Future<GroupDetail> createGroup(String name, List<String> memberMxids) async {
    final response = await authedRequest(
      (token) => groups.createGroupGroupsPost(
        groupCreate: GroupCreate(
          (b) => b
            ..name = name
            ..memberMatrixIds = ListBuilder(memberMxids),
        ),
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Preview shown to an invitee before joining (group name, admin, members).
  Future<GroupInvitePreview> getGroupInvitePreview(int groupId) async {
    final response = await authedRequest(
      (token) => groups.invitePreviewGroupsGroupIdInvitePreviewGet(
        groupId: groupId,
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Accepts a group invite.
  Future<GroupDetail> joinGroup(int groupId) async {
    final response = await authedRequest(
      (token) => groups.joinGroupGroupsGroupIdJoinPost(
        groupId: groupId,
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Declines a group invite.
  Future<void> declineGroup(int groupId) => authedRequest(
    (token) => groups.declineGroupGroupsGroupIdDeclinePost(
      groupId: groupId,
      headers: _authHeader(token),
    ),
  );

  /// Leaves a group I'm a member of.
  Future<void> leaveGroup(int groupId) => authedRequest(
    (token) => groups.leaveGroupGroupsGroupIdLeavePost(
      groupId: groupId,
      headers: _authHeader(token),
    ),
  );

  /// Directly invites [mxid] into the group (admin only).
  Future<GroupDetail> addMember(int groupId, String mxid) async {
    final response = await authedRequest(
      (token) => groups.addMemberGroupsGroupIdMembersPost(
        groupId: groupId,
        memberSuggestionCreate: MemberSuggestionCreate(
          (b) => b..suggestedMatrixId = mxid,
        ),
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Removes a member from the group (admin only).
  Future<void> removeMember(int groupId, String mxid) => authedRequest(
    (token) => groups.removeMemberGroupsGroupIdMembersMatrixUserIdDelete(
      groupId: groupId,
      matrixUserId: mxid,
      headers: _authHeader(token),
    ),
  );

  /// Pending member suggestions for the group (admin only).
  Future<BuiltList<MemberSuggestion>> listSuggestions(int groupId) async {
    final response = await authedRequest(
      (token) => groups.listSuggestionsGroupsGroupIdSuggestionsGet(
        groupId: groupId,
        headers: _authHeader(token),
      ),
    );
    return response.data ?? BuiltList();
  }

  /// Suggests [mxid] as a new member, for the admin to approve.
  Future<MemberSuggestion> suggestMember(
    int groupId,
    String mxid, {
    String? message,
  }) async {
    final response = await authedRequest(
      (token) => groups.suggestMemberGroupsGroupIdSuggestionsPost(
        groupId: groupId,
        memberSuggestionCreate: MemberSuggestionCreate(
          (b) => b
            ..suggestedMatrixId = mxid
            ..message = message,
        ),
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Approves a suggestion and invites the suggested user (admin only).
  Future<GroupDetail> inviteSuggestion(int groupId, int suggestionId) async {
    final response = await authedRequest(
      (token) =>
          groups.inviteSuggestedGroupsGroupIdSuggestionsSuggestionIdInvitePost(
        groupId: groupId,
        suggestionId: suggestionId,
        headers: _authHeader(token),
      ),
    );
    return response.data!;
  }

  /// Dismisses a suggestion without inviting (admin only).
  Future<void> dismissSuggestion(int groupId, int suggestionId) =>
      authedRequest(
        (token) => groups
            .dismissSuggestionGroupsGroupIdSuggestionsSuggestionIdDismissPost(
          groupId: groupId,
          suggestionId: suggestionId,
          headers: _authHeader(token),
        ),
      );

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);
  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyMatrixPassword),
    ]);
  }

  Future<void> saveMatrixPassword(String password) =>
      _storage.write(key: _keyMatrixPassword, value: password);

  Future<String?> getMatrixPassword() async {
    final stored = await _storage.read(key: _keyMatrixPassword);
    if (stored != null) return stored;
    return _fetchAndCacheMatrixPassword();
  }

  Future<String?> _fetchAndCacheMatrixPassword() async {
    try {
      final response = await authedRequest(
        (token) => _dio.get<Map<String, dynamic>>(
          '/me/matrix-password',
          options: Options(
            headers: <String, String>{'Authorization': 'Bearer $token'},
          ),
        ),
      );
      final password = response.data?['matrix_password'] as String?;
      if (password != null) await saveMatrixPassword(password);
      return password;
    } catch (_) {
      return null;
    }
  }

  /// Runs [call] with the current access token and retries once on 401 after
  /// refreshing. Throws [StateError] if the user is not authenticated and
  /// rethrows the original [DioException] if refresh fails or the retry still
  /// fails.
  Future<T> authedRequest<T>(Future<T> Function(String token) call) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      _authExpiredController.add(null);
      throw StateError('Not authenticated');
    }
    try {
      return await call(accessToken);
    } on DioException catch (e) {
      if (e.response?.statusCode != 401) rethrow;
      final refreshed = await _refreshAccessToken();
      if (refreshed == null) rethrow;
      return await call(refreshed);
    }
  }

  /// Validates stored tokens at app start.
  ///
  /// If the access token is absent and [requireAuth] is true (user has
  /// previously onboarded), fires [onAuthExpired] so the app redirects to
  /// re-authentication. If the access token exists but is expired, silently
  /// attempts a refresh — which fires [onAuthExpired] on its own if the refresh
  /// token is also rejected by the server.
  Future<void> checkAuthOnStartup({bool requireAuth = false}) async {
    final accessToken = await getAccessToken();
    if (accessToken == null) {
      if (requireAuth) _authExpiredController.add(null);
      return;
    }
    if (_isJwtExpired(accessToken)) {
      await _refreshAccessToken();
    }
  }

  bool _isJwtExpired(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;
      final payload = base64Url.decode(base64Url.normalize(parts[1]));
      final claims =
          jsonDecode(utf8.decode(payload)) as Map<String, dynamic>;
      final exp = claims['exp'];
      if (exp is! int) return false;
      return DateTime.fromMillisecondsSinceEpoch(exp * 1000)
          .isBefore(DateTime.now());
    } catch (_) {
      return false;
    }
  }

  // Deduplicates concurrent refresh calls so only one hits the server at a
  // time. Rotating refresh tokens mean a second concurrent call with the old
  // token would be rejected — both callers share the same Future instead.
  Future<String?>? _refreshFuture;

  Future<String?> _refreshAccessToken() {
    return _refreshFuture ??= _doRefresh().whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<String?> _doRefresh() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        _authExpiredController.add(null);
        return null;
      }
      final response = await token.refreshTokenAuthRefreshPost(
        refreshRequest: RefreshRequest((b) => b..refreshToken = refreshToken),
      );
      final tokens = response.data;
      if (tokens == null) return null;
      await saveTokens(tokens.accessToken, tokens.refreshToken);
      debugPrint('[TW-API] Access token refreshed');
      return tokens.accessToken;
    } on DioException catch (e) {
      debugPrint(
        '[TW-API] Refresh failed (${e.response?.statusCode}): ${e.message}',
      );
      if (e.response?.statusCode == 401) {
        await clearTokens();
        _authExpiredController.add(null);
      }
      return null;
    } catch (e) {
      debugPrint('[TW-API] Refresh failed: $e');
      return null;
    }
  }

  AuthApi get auth => _apiClient.getAuthApi();

  /// Calls POST /auth/email/verify. Extracts the AuthResponse plus the Matrix
  /// access token (login_token) and device ID (matrix_device_id).
  Future<({AuthResponse authResponse, String? loginToken, String? deviceId})>
  emailVerify({
    required String email,
    required String code,
    String? phone,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/email/verify',
      data: <String, dynamic>{
        'email': email,
        'code': code,
        'phone': ?phone,
      },
    );
    final data = response.data!;
    final authResponse = standardSerializers.deserialize(
      data,
      specifiedType: const FullType(AuthResponse),
    ) as AuthResponse;
    final loginToken = data['login_token'] as String?;
    final deviceId = data['matrix_device_id'] as String?;
    return (authResponse: authResponse, loginToken: loginToken, deviceId: deviceId);
  }

  /// Calls POST /auth/email/login. Extracts the AuthResponse plus the Matrix
  /// access token (login_token) and device ID (matrix_device_id).
  Future<({AuthResponse authResponse, String? loginToken, String? deviceId})>
  emailLogin({
    required String email,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/email/login',
      data: <String, dynamic>{'email': email, 'code': code},
    );
    final data = response.data!;
    final authResponse = standardSerializers.deserialize(
      data,
      specifiedType: const FullType(AuthResponse),
    ) as AuthResponse;
    final loginToken = data['login_token'] as String?;
    final deviceId = data['matrix_device_id'] as String?;
    return (authResponse: authResponse, loginToken: loginToken, deviceId: deviceId);
  }

  /// Calls GET /auth/bankid/start with the stored access token.
  /// Returns the authorization_url to open in the browser.
  Future<({String authorizationUrl, String state})> bankIdStart() async {
    final accessToken = await getAccessToken();
    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/bankid/start',
      options: Options(
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
      ),
    );
    final data = response.data!;
    return (
      authorizationUrl: data['authorization_url'] as String,
      state: data['state'] as String,
    );
  }

  /// Calls GET /auth/bankid/callback?code=...&state=... and returns AuthResponse.
  Future<AuthResponse> bankIdCallback({
    required String code,
    required String state,
  }) async {
    final response = await _dio.get<Object>(
      '/auth/bankid/callback',
      queryParameters: <String, String>{'code': code, 'state': state},
    );
    return standardSerializers.deserialize(
          response.data,
          specifiedType: const FullType(AuthResponse),
        ) as AuthResponse;
  }

  /// Extracts a user-friendly message from a DioException and logs the full
  /// details so the complete response body is visible in Logcat.
  static String friendlyError(DioException e) {
    final isRedacted = _RedactingLogInterceptor._isRedacted(
      e.requestOptions.uri,
    );
    debugPrint('[TW-API] ERROR ${e.response?.statusCode}: ${e.message}');
    if (isRedacted) {
      debugPrint('[TW-API] Response body: <redacted>');
    } else {
      debugPrint('[TW-API] Response body: ${e.response?.data}');
    }
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail is String) return detail;
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map) return first['msg']?.toString() ?? e.message ?? 'Error';
      }
    }
    return e.message ?? 'Something went wrong. Please try again.';
  }
}

/// Drop-in for [LogInterceptor] that redacts request/response bodies for
/// `/data-sharing/*` paths. The approve endpoint mints a short-lived fetch
/// token and the fetch endpoint returns verified personal data — neither
/// should land in logcat verbatim. URL, method, and status code are still
/// logged so failures stay diagnosable.
class _RedactingLogInterceptor extends Interceptor {
  static const _prefix = '[TW-API]';
  static const _redactedPaths = ['/data-sharing/'];

  static bool _isRedacted(Uri uri) {
    final path = uri.path;
    for (final p in _redactedPaths) {
      if (path.contains(p)) return true;
    }
    return false;
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final redacted = _isRedacted(options.uri);
    debugPrint('$_prefix *** Request ***');
    debugPrint('$_prefix uri: ${options.uri}');
    debugPrint('$_prefix method: ${options.method}');
    if (options.data != null) {
      if (redacted) {
        debugPrint('$_prefix data: <redacted>');
      } else {
        debugPrint('$_prefix data: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final redacted = _isRedacted(response.requestOptions.uri);
    debugPrint('$_prefix *** Response ***');
    debugPrint('$_prefix uri: ${response.realUri}');
    debugPrint('$_prefix statusCode: ${response.statusCode}');
    if (redacted) {
      debugPrint('$_prefix body: <redacted>');
    } else {
      debugPrint('$_prefix body: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final redacted = _isRedacted(err.requestOptions.uri);
    debugPrint('$_prefix *** DioException ***');
    debugPrint('$_prefix uri: ${err.requestOptions.uri}');
    debugPrint('$_prefix message: ${err.message}');
    if (err.response != null) {
      debugPrint('$_prefix statusCode: ${err.response!.statusCode}');
      if (redacted) {
        debugPrint('$_prefix body: <redacted>');
      } else {
        debugPrint('$_prefix body: ${err.response!.data}');
      }
    }
    handler.next(err);
  }
}
