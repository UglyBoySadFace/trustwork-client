import 'package:flutter/material.dart';

import 'package:fluffychat/l10n/l10n.dart';
import 'package:fluffychat/pages/contact_requests/contacts_tab.dart';
import 'package:fluffychat/pages/contact_requests/incoming_requests_tab.dart';
import 'package:fluffychat/pages/contact_requests/outgoing_requests_tab.dart';

class ContactRequestsPage extends StatelessWidget {
  const ContactRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Text(L10n.of(context).contactRequests),
          bottom: TabBar(
            tabs: [
              Tab(text: L10n.of(context).contacts),
              Tab(text: L10n.of(context).incomingRequests),
              Tab(text: L10n.of(context).outgoingRequests),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ContactsTab(),
            IncomingRequestsTab(),
            OutgoingRequestsTab(),
          ],
        ),
      ),
    );
  }
}
