import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';

/// Bottom sheet for declining an incoming call with a text message, like
/// WhatsApp and native dialers offer: a few premade quick replies plus a
/// custom message field. Pops with the chosen message, or null on dismiss.
class DeclineWithMessageSheet extends StatefulWidget {
  const DeclineWithMessageSheet({super.key});

  @override
  State<DeclineWithMessageSheet> createState() =>
      _DeclineWithMessageSheetState();
}

class _DeclineWithMessageSheetState extends State<DeclineWithMessageSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) setState(() => _hasText = hasText);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendCustom() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    Navigator.of(context).pop(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final premade = <String>[
      l10n.declineMessageCantTalk,
      l10n.declineMessageCallRightBack,
      l10n.declineMessageCallLater,
      l10n.declineMessageCantTalkCallLater,
    ];
    return SafeArea(
      child: Padding(
        // Keep the custom-message field above the keyboard.
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                l10n.declineWithMessage,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final message in premade)
              ListTile(
                leading: const Icon(Icons.chat_bubble_outline),
                title: Text(message),
                onTap: () => Navigator.of(context).pop(message),
              ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendCustom(),
                      decoration: InputDecoration(
                        hintText: l10n.declineMessageCustomHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _hasText ? _sendCustom : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
