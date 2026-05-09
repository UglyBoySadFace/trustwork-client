import 'package:api_client/api_client.dart';

import 'package:fluffychat/l10n/l10n.dart';

/// One of the eight pieces of verified profile data that can be shared during
/// a call invite.
///
/// The wire identifier is the canonical name used by the Trustwork middleware
/// and over the matrix to-device protocol; UI labels and value formatting
/// hang off this enum so adding a ninth field is a single switch arm rather
/// than a sweep across the codebase.
enum ShareableField {
  country('country'),
  state('state'),
  street('street'),
  streetFull('street_full'),
  fullAge('full_age'),
  decadeOfAge('decade_of_age'),
  isAdult('is_adult'),
  nationalities('nationalities');

  const ShareableField(this.wireId);

  final String wireId;

  static ShareableField? fromWire(String id) {
    for (final field in values) {
      if (field.wireId == id) return field;
    }
    return null;
  }

  /// Maps this field to the matching `share_*` flag on a [SharingPreferences]
  /// instance. Returns `false` if the preference is unset.
  bool readPreference(SharingPreferences prefs) => switch (this) {
    ShareableField.country => prefs.shareCountry ?? false,
    ShareableField.state => prefs.shareState ?? false,
    ShareableField.street => prefs.shareStreet ?? false,
    ShareableField.streetFull => prefs.shareStreetFull ?? false,
    ShareableField.fullAge => prefs.shareFullAge ?? false,
    ShareableField.decadeOfAge => prefs.shareDecadeOfAge ?? false,
    ShareableField.isAdult => prefs.shareIsAdult ?? false,
    ShareableField.nationalities => prefs.shareNationalities ?? false,
  };

  /// Builds a new [SharingPreferences] from a `field → enabled` map.
  static SharingPreferences buildPreferences(Map<ShareableField, bool> values) {
    return SharingPreferences(
      (b) => b
        ..shareCountry = values[ShareableField.country] ?? false
        ..shareState = values[ShareableField.state] ?? false
        ..shareStreet = values[ShareableField.street] ?? false
        ..shareStreetFull = values[ShareableField.streetFull] ?? false
        ..shareFullAge = values[ShareableField.fullAge] ?? false
        ..shareDecadeOfAge = values[ShareableField.decadeOfAge] ?? false
        ..shareIsAdult = values[ShareableField.isAdult] ?? false
        ..shareNationalities = values[ShareableField.nationalities] ?? false,
    );
  }

  /// Maps this enum to the OpenAPI-generated [SharableField] enum used by
  /// `DataSharingApproveRequest.approvedFields`.
  SharableField toApiField() => switch (this) {
    ShareableField.country => SharableField.country,
    ShareableField.state => SharableField.state,
    ShareableField.street => SharableField.street,
    ShareableField.streetFull => SharableField.streetFull,
    ShareableField.fullAge => SharableField.fullAge,
    ShareableField.decadeOfAge => SharableField.decadeOfAge,
    ShareableField.isAdult => SharableField.isAdult,
    ShareableField.nationalities => SharableField.nationalities,
  };

  String label(L10n l10n) => switch (this) {
    ShareableField.country => l10n.shareableFieldCountry,
    ShareableField.state => l10n.shareableFieldState,
    ShareableField.street => l10n.shareableFieldStreet,
    ShareableField.streetFull => l10n.shareableFieldStreetFull,
    ShareableField.fullAge => l10n.shareableFieldFullAge,
    ShareableField.decadeOfAge => l10n.shareableFieldDecadeOfAge,
    ShareableField.isAdult => l10n.shareableFieldIsAdult,
    ShareableField.nationalities => l10n.shareableFieldNationalities,
  };

  /// Returns the human-readable value of this field on [data], or `null` if
  /// the caller didn't share it.
  String? formatValue(SharedData data, L10n l10n) => switch (this) {
    ShareableField.country => data.country,
    ShareableField.state => data.state,
    ShareableField.street => data.street,
    ShareableField.streetFull => data.streetFull,
    ShareableField.fullAge => data.fullAge?.toString(),
    ShareableField.decadeOfAge => data.decadeOfAge,
    ShareableField.isAdult => switch (data.isAdult) {
      null => null,
      true => l10n.shareableFieldIsAdultYes,
      false => l10n.shareableFieldIsAdultNo,
    },
    ShareableField.nationalities => data.nationalities?.join(', '),
  };
}
