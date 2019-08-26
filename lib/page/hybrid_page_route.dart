import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

typedef Widget PageBuilder(String route, Map params, String uniqueID);

class HybridPageRoute<T> extends MaterialPageRoute<T> {
  final String routeName;
  final Map params;
  final String uniqueID;
  final bool animated;
  final WidgetBuilder builder;
  final RouteSettings settings;

  final Set<VoidCallback> backPressedListeners = Set<VoidCallback>();

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  HybridPageRoute(
      {Key stubKey,
      this.routeName,
      this.params,
      this.uniqueID,
      this.animated,
      this.builder,
      this.settings})
      : super(
            builder: (BuildContext context) => Stub(stubKey, builder(context)),
            settings: settings);

  static HybridPageRoute<T> of<T>(BuildContext context) {
    final Route<T> route = ModalRoute.of(context);
    if (route != null && route is HybridPageRoute<T>) {
      return route;
    } else {
      throw Exception('Not in a HybridPageRoute');
    }
  }

  static HybridPageRoute<T> tryOf<T>(BuildContext context) {
    final Route<T> route = ModalRoute.of(context);
    if (route != null && route is HybridPageRoute<T>) {
      return route;
    } else {
      return null;
    }
  }
}

@immutable
class Stub extends StatefulWidget {
  final Widget child;

  const Stub(Key key, this.child) : super(key: key);

  @override
  _StubState createState() => _StubState();
}

class _StubState extends State<Stub> {
  @override
  Widget build(BuildContext context) => widget.child;
}
