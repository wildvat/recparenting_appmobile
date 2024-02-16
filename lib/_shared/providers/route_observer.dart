import 'package:flutter/material.dart';

class RouteObserverRec extends RouteObserver<PageRoute<dynamic>> {
  List<Route> _history = [];
  final int _maxSize = 10;

  List<Route> get history => _history;

  set history(List<Route> value) {
    _history = value;
    _checkHistoryMaxLength();
  }

  _checkHistoryMaxLength() async {
    if (_history.length == _maxSize) {
      /// remove in order to solve error _debugLocked or route._navigator == this
      /// for now its impossible to limit the stack limit
      /// super.navigator?.removeRoute(history.first);
      _history.removeAt(0);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null) {
      _history.add(route);
      _checkHistoryMaxLength();
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null && _history.isNotEmpty) {
      _history.removeLast();
      _history.add(newRoute);
    }

    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route.settings.name != null && _history.isNotEmpty) {
      _history.removeLast();
    }
    super.didPop(route, previousRoute);
  }
}

final RouteObserverRec routeObserverRec = RouteObserverRec();
