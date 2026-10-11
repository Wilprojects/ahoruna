import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ahoruna/src/features/profile/presentation/controllers/profile_controller.dart';

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, void>(ProfileController.new);
