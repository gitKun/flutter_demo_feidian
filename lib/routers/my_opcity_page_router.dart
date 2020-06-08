import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyOpacityPageRouter<T> extends TransparentMaterialPageRoute<T> {
  /// Construct a MaterialPageRoute whose contents are defined by [builder].
  ///
  /// The values of [builder], [maintainState], and [fullScreenDialog] must not
  /// be null.
  MyOpacityPageRouter({
    @required this.builder,
    this.transion,
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        //assert(opaque),
        super(
            settings: settings,
            fullscreenDialog: fullscreenDialog,
            builder: builder);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;
  final Widget Function(Widget child, Animation<double> animation) transion;
  @override
  final bool maintainState;

  @override
  // transparent background
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    if (nextRoute is MyOpacityPageRouter && !nextRoute.fullscreenDialog) {
      return true;
    }
    return super.canTransitionTo(nextRoute);
  }

  @override
  bool canTransitionFrom(TransitionRoute previousRoute) {
    if (previousRoute is MyOpacityPageRouter) {
      return true;
    }
    return super.canTransitionFrom(previousRoute);
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError(
            'The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transion != null) {
      return transion(child, animation);
    } else {
      final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
      return theme.buildTransitions<T>(
          this, context, animation, secondaryAnimation, child);
    }
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
