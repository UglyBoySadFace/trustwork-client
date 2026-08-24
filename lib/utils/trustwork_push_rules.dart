import 'package:matrix/matrix.dart';

/// Trustwork custom room events (`com.trustwork.*`) that middleware bots can
/// post unencrypted into an otherwise-encrypted DM/group room. The homeserver's
/// default push rules only match `m.room.message` / `m.room.encrypted`, so an
/// unencrypted custom-typed event never matches any rule and the server never
/// sends a push for it — the client-side pipeline in push_helper.dart is never
/// even invoked. Provisioning one override rule per type below makes the
/// server notify on these regardless of encryption state.
const _notifiableTrustworkEventTypes = <String>[
  'com.trustwork.contact_request',
  'com.trustwork.data_request',
  'com.trustwork.group_invite',
  'com.trustwork.suggestion_created',
];

/// Ensures an override push rule exists for each Trustwork custom event type
/// so the homeserver actually sends a push for them. Safe to call on every
/// login — skips types that already have a rule (checked against the cached
/// `m.push_rules` account data), and a redundant PUT for a type whose account
/// data hasn't synced yet is a harmless idempotent upsert.
Future<void> ensureTrustworkPushRules(Client client) async {
  if (!client.isLogged()) return;
  final existingRuleIds = client.globalPushRules?.override
          ?.map((rule) => rule.ruleId)
          .toSet() ??
      <String>{};

  for (final type in _notifiableTrustworkEventTypes) {
    if (existingRuleIds.contains(type)) continue;
    try {
      await client.setPushRule(
        PushRuleKind.override,
        type,
        [
          'notify',
          {'set_tweak': 'sound', 'value': 'default'},
        ],
        conditions: [
          PushCondition(kind: 'event_match', key: 'type', pattern: type),
        ],
      );
    } catch (e, s) {
      Logs().w('[PUSH] failed to provision push rule for $type', e, s);
    }
  }
}
