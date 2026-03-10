//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PhoneVerifyRequest {
  /// Returns a new [PhoneVerifyRequest] instance.
  PhoneVerifyRequest({
    required this.phone,
    required this.code,
  });

  String phone;

  String code;

  @override
  bool operator ==(Object other) => identical(this, other) || other is PhoneVerifyRequest &&
    other.phone == phone &&
    other.code == code;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (phone.hashCode) +
    (code.hashCode);

  @override
  String toString() => 'PhoneVerifyRequest[phone=$phone, code=$code]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'phone'] = this.phone;
      json[r'code'] = this.code;
    return json;
  }

  /// Returns a new [PhoneVerifyRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PhoneVerifyRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "PhoneVerifyRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "PhoneVerifyRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PhoneVerifyRequest(
        phone: mapValueOfType<String>(json, r'phone')!,
        code: mapValueOfType<String>(json, r'code')!,
      );
    }
    return null;
  }

  static List<PhoneVerifyRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <PhoneVerifyRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PhoneVerifyRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PhoneVerifyRequest> mapFromJson(dynamic json) {
    final map = <String, PhoneVerifyRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PhoneVerifyRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PhoneVerifyRequest-objects as value to a dart map
  static Map<String, List<PhoneVerifyRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<PhoneVerifyRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PhoneVerifyRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'phone',
    'code',
  };
}

