//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthResponse {
  /// Returns a new [AuthResponse] instance.
  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'bearer',
    required this.expiresIn,
    this.matrix,
    required this.user,
  });

  String accessToken;

  String refreshToken;

  String tokenType;

  int expiresIn;

  MatrixCredentials? matrix;

  UserProfile user;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthResponse &&
    other.accessToken == accessToken &&
    other.refreshToken == refreshToken &&
    other.tokenType == tokenType &&
    other.expiresIn == expiresIn &&
    other.matrix == matrix &&
    other.user == user;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (accessToken.hashCode) +
    (refreshToken.hashCode) +
    (tokenType.hashCode) +
    (expiresIn.hashCode) +
    (matrix == null ? 0 : matrix!.hashCode) +
    (user.hashCode);

  @override
  String toString() => 'AuthResponse[accessToken=$accessToken, refreshToken=$refreshToken, tokenType=$tokenType, expiresIn=$expiresIn, matrix=$matrix, user=$user]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'access_token'] = this.accessToken;
      json[r'refresh_token'] = this.refreshToken;
      json[r'token_type'] = this.tokenType;
      json[r'expires_in'] = this.expiresIn;
    if (this.matrix != null) {
      json[r'matrix'] = this.matrix;
    } else {
      json[r'matrix'] = null;
    }
      json[r'user'] = this.user;
    return json;
  }

  /// Returns a new [AuthResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AuthResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AuthResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AuthResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AuthResponse(
        accessToken: mapValueOfType<String>(json, r'access_token')!,
        refreshToken: mapValueOfType<String>(json, r'refresh_token')!,
        tokenType: mapValueOfType<String>(json, r'token_type') ?? 'bearer',
        expiresIn: mapValueOfType<int>(json, r'expires_in')!,
        matrix: MatrixCredentials.fromJson(json[r'matrix']),
        user: UserProfile.fromJson(json[r'user'])!,
      );
    }
    return null;
  }

  static List<AuthResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AuthResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AuthResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AuthResponse> mapFromJson(dynamic json) {
    final map = <String, AuthResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AuthResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AuthResponse-objects as value to a dart map
  static Map<String, List<AuthResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AuthResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AuthResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'access_token',
    'refresh_token',
    'expires_in',
    'user',
  };
}

