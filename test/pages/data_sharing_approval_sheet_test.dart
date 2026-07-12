import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/data_sharing/data_sharing_approval_sheet.dart';
import 'package:fluffychat/utils/data_sharing/shareable_field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp({
    required List<ShareableField> fields,
    Map<ShareableField, bool> defaults = const {},
    required Future<String?> Function(Set<ShareableField>) onShare,
    Future<void> Function()? onDecline,
  }) => MaterialApp(
    localizationsDelegates: L10n.localizationsDelegates,
    supportedLocales: L10n.supportedLocales,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isDismissible: false,
              builder: (_) => DataSharingApprovalSheet(
                requesterDisplayName: 'Alice',
                fields: fields,
                defaults: defaults,
                onShare: onShare,
                onDecline: onDecline ?? () async {},
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );

  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the requester, fields and defaults', (tester) async {
    await tester.pumpWidget(
      buildApp(
        fields: [ShareableField.country, ShareableField.isAdult],
        defaults: {ShareableField.country: true},
        onShare: (_) async => null,
      ),
    );
    await openSheet(tester);

    expect(
      find.text('Alice wants to share verification details'),
      findsOneWidget,
    );
    final tiles = tester
        .widgetList<CheckboxListTile>(find.byType(CheckboxListTile))
        .toList();
    expect(tiles.length, 2);
    expect(tiles.first.value, isTrue); // country default
    expect(tiles.last.value, isFalse); // is_adult unset -> false
  });

  testWidgets('share is disabled until at least one field is selected', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        fields: [ShareableField.country],
        onShare: (_) async => null,
      ),
    );
    await openSheet(tester);

    FilledButton shareButton() =>
        tester.widget<FilledButton>(find.byType(FilledButton));
    expect(shareButton().onPressed, isNull);

    await tester.tap(find.byType(CheckboxListTile));
    await tester.pump();
    expect(shareButton().onPressed, isNotNull);
  });

  testWidgets('share passes the selected fields and closes the sheet', (
    tester,
  ) async {
    Set<ShareableField>? shared;
    await tester.pumpWidget(
      buildApp(
        fields: [ShareableField.country, ShareableField.isAdult],
        defaults: {ShareableField.country: true},
        onShare: (selected) async {
          shared = selected;
          return null;
        },
      ),
    );
    await openSheet(tester);

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    expect(shared, {ShareableField.country});
    expect(find.byType(DataSharingApprovalSheet), findsNothing);
  });

  testWidgets('a share error keeps the sheet open and shows the message', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildApp(
        fields: [ShareableField.country],
        defaults: {ShareableField.country: true},
        onShare: (_) async => 'sharing failed',
      ),
    );
    await openSheet(tester);

    await tester.tap(find.text('Share'));
    await tester.pumpAndSettle();

    expect(find.byType(DataSharingApprovalSheet), findsOneWidget);
    expect(find.text('sharing failed'), findsOneWidget);
  });

  testWidgets('decline invokes the callback and closes the sheet', (
    tester,
  ) async {
    var declined = false;
    await tester.pumpWidget(
      buildApp(
        fields: [ShareableField.country],
        onShare: (_) async => null,
        onDecline: () async => declined = true,
      ),
    );
    await openSheet(tester);

    await tester.tap(find.text('Decline'));
    await tester.pumpAndSettle();

    expect(declined, isTrue);
    expect(find.byType(DataSharingApprovalSheet), findsNothing);
  });
}
