//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class EmailStartResponse {
  /// Returns a new [EmailStartResponse] instance.
  EmailStartResponse({
    required this.message,
    required this.expiresIn,
  });

  String message;

  int expiresIn;

  @override
  bool operator ==(Object other) => identical(this, other) || other is EmailStartResponse &&
    other.message == message &&
    other.expiresIn == expiresIn;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (message.hashCode) +
    (expiresIn.hashCode);

  @override
  String toString() => 'EmailStartResponse[message=$message, expiresIn=$expiresIn]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'message'] = this.message;
      json[r'expires_in'] = this.expiresIn;
    return json;
  }

  /// Returns a new [EmailStartResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static EmailStartResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "EmailStartResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "EmailStartResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return EmailStartResponse(
        message: mapValueOfType<String>(json, r'message')!,
        expiresIn: mapValueOfType<int>(json, r'expires_in')!,
      );
    }
    return null;
  }

  static List<EmailStartResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmailStartResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmailStartResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, EmailStartResponse> mapFromJson(dynamic json) {
    final map = <String, EmailStartResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = EmailStartResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of EmailStartResponse-objects as value to a dart map
  static Map<String, List<EmailStartResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<EmailStartResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = EmailStartResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'message',
    'expires_in',
  };
}

