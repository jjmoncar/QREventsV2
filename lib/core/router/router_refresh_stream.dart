import 'dart:async';
import 'package:flutter/material.dart';

/// Helper class to convert a [Stream] into a [Listenable] for GoRouter.
/// This allows GoRouter to refresh its routes whenever the stream emits a value.
class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
