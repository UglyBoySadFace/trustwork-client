import 'package:flutter/material.dart';

import 'package:fluffychat/pages/settings_data_sharing/settings_data_sharing_view.dart';
import 'package:fluffychat/pages/settings_data_sharing/view_model/settings_data_sharing_view_model.dart';
import 'package:fluffychat/widgets/matrix.dart';
import 'package:fluffychat/widgets/view_model_builder.dart';

class SettingsDataSharing extends StatelessWidget {
  const SettingsDataSharing({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsDataSharingViewModel>(
      create: () => SettingsDataSharingViewModel(Matrix.of(context).store),
      builder: (context, viewModel, _) => SettingsDataSharingView(viewModel),
    );
  }
}
