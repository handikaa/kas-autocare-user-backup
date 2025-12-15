import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
}

// class AuthEventBus {
//   static final _unauthorizedController = StreamController<void>.broadcast();

//   static Stream<void> get unauthorized => _unauthorizedController.stream;

//   static void triggerUnauthorized() {
//     _unauthorizedController.add(null);
//   }
// }
