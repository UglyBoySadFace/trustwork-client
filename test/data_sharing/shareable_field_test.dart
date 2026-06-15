import 'package:api_client/api_client.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/l10n/l10n_en.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

void main() {
  group('ShareableField wireId round-trip', () {
    test('every value round-trips through fromWire', () {
      for (final field in ShareableField.values) {
        expect(ShareableField.fromWire(field.wireId), field);
      }
    });

    test('unknown wireId returns null', () {
      expect(ShareableField.fromWire('not_a_field'), isNull);
      expect(ShareableField.fromWire(''), isNull);
    });

    test('wireIds match the spec strings', () {
      expect(ShareableField.country.wireId, 'country');
      expect(ShareableField.state.wireId, 'state');
      expect(ShareableField.street.wireId, 'street');
      expect(ShareableField.streetFull.wireId, 'street_full');
      expect(ShareableField.fullAge.wireId, 'full_age');
      expect(ShareableField.decadeOfAge.wireId, 'decade_of_age');
      expect(ShareableField.isAdult.wireId, 'is_adult');
      expect(ShareableField.nationalities.wireId, 'nationalities');
    });
  });

  group('ShareableField.label', () {
    final l10n = L10nEn();

    test('every value returns a non-empty label', () {
      for (final field in ShareableField.values) {
        expect(field.label(l10n), isNotEmpty);
      }
    });
  });

  group('ShareableField.formatValue', () {
    final l10n = L10nEn();

    SharedData buildAll() => SharedData(
      (b) => b
        ..country = 'CZ'
        ..state = 'Praha'
        ..street = 'Wenceslas Square'
        ..streetFull = 'Wenceslas Square 1, 110 00 Praha'
        ..fullAge = 34
        ..decadeOfAge = '30s'
        ..isAdult = true
        ..nationalities = ListBuilder<String>(<String>['CZ', 'SK']),
    );

    test('returns formatted string for each populated field', () {
      final data = buildAll();
      expect(ShareableField.country.formatValue(data, l10n), 'CZ');
      expect(ShareableField.state.formatValue(data, l10n), 'Praha');
      expect(ShareableField.street.formatValue(data, l10n), 'Wenceslas Square');
      expect(
        ShareableField.streetFull.formatValue(data, l10n),
        'Wenceslas Square 1, 110 00 Praha',
      );
      expect(ShareableField.fullAge.formatValue(data, l10n), '34');
      expect(ShareableField.decadeOfAge.formatValue(data, l10n), '30s');
      expect(
        ShareableField.isAdult.formatValue(data, l10n),
        l10n.shareableFieldIsAdultYes,
      );
      expect(
        ShareableField.nationalities.formatValue(data, l10n),
        'CZ, SK',
      );
    });

    test('returns null for fields the caller did not share', () {
      final empty = SharedData((b) => b);
      for (final field in ShareableField.values) {
        expect(
          field.formatValue(empty, l10n),
          isNull,
          reason: 'expected null for ${field.wireId}',
        );
      }
    });

    test('isAdult false formats to localized "no"', () {
      final data = SharedData((b) => b..isAdult = false);
      expect(
        ShareableField.isAdult.formatValue(data, l10n),
        l10n.shareableFieldIsAdultNo,
      );
    });
  });

  group('ShareableField.toApiField', () {
    test('every value maps to a unique SharableField', () {
      final mapped = <SharableField>{
        for (final f in ShareableField.values) f.toApiField(),
      };
      expect(mapped.length, ShareableField.values.length);
    });
  });

  group('ShareableField preferences round-trip', () {
    test('buildPreferences ↔ readPreference round-trips', () {
      final input = <ShareableField, bool>{
        for (final f in ShareableField.values) f: false,
      }
        ..[ShareableField.country] = true
        ..[ShareableField.isAdult] = true;

      final prefs = ShareableField.buildPreferences(input);

      for (final field in ShareableField.values) {
        expect(
          field.readPreference(prefs),
          input[field],
          reason: field.wireId,
        );
      }
    });
  });
}
