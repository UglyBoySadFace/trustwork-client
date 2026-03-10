//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MatrixCredentials {
  /// Returns a new [MatrixCredentials] instance.
  MatrixCredentials({
    required this.matrixUserId,
    required this.matrixAccessToken,
  });

  String matrixUserId;

  String matrixAccessToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MatrixCredentials &&
    other.matrixUserId == matrixUserId &&
    other.matrixAccessToken == matrixAccessToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (matrixUserId.hashCode) +
    (matrixAccessToken.hashCode);

  @override
  String toString() => 'MatrixCredentials[matrixUserId=$matrixUserId, matrixAccessToken=$matrixAccessToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'matrix_user_id'] = this.matrixUserId;
      json[r'matrix_access_token'] = this.matrixAccessToken;
    return json;
  }

  /// Returns a new [MatrixCredentials] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MatrixCredentials? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MatrixCredentials[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MatrixCredentials[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MatrixCredentials(
        matrixUserId: mapValueOfType<String>(json, r'matrix_user_id')!,
        matrixAccessToken: mapValueOfType<String>(json, r'matrix_access_token')!,
      );
    }
    return null;
  }

  static List<MatrixCredentials> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MatrixCredentials>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MatrixCredentials.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MatrixCredentials> mapFromJson(dynamic json) {
    final map = <String, MatrixCredentials>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MatrixCredentials.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MatrixCredentials-objects as value to a dart map
  static Map<String, List<MatrixCredentials>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MatrixCredentials>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MatrixCredentials.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'matrix_user_id',
    'matrix_access_token',
  };
}

