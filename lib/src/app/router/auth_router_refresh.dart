import 'dart:async';

import 'package:flutter/foundation.dart';

class AuthRouterRefresh<T> extends ChangeNotifier {
  AuthRouterRefresh(Stream<T> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<T> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
