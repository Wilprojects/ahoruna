import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/settings/presentation/controllers/settings_controller.dart';

final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, void>(SettingsController.new);
