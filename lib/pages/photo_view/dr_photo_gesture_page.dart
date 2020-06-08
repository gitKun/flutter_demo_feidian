import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pagetext/pages/photo_view/dr_photo_gestured_image.dart';
import './dr_photo_browser_typedef.dart';
import './dr_gesture_detail.dart';
import './dr_gesture_animation.dart';
import 'dr_photo_browser_utils.dart';

final PageController _defaultPageController = PageController();
const ScrollPhysics _defaultScrollPhysics = NeverScrollableScrollPhysics();

/// whether we can move to previous/next page only for Image
bool _defaultCanMovePage(DRGestureDetails gestureDetails) => true;

/// whether should scoll page
bool _defaultCanScrollPage(DRGestureDetails gestureDetails) => true;

final PageMetrics _testPageMetrics = PageMetrics(
  axisDirection: AxisDirection.down,
  minScrollExtent: 0,
  maxScrollExtent: 10,
  pixels: 5,
  viewportDimension: 10,
  viewportFraction: 1.0,
);

class DRPhotoGesturePageView extends StatefulWidget {
  DRPhotoGesturePageView.build({
    Key key,
    ScrollPhysics physics,
    this.reverse = false,
    PageController controller,
    @required IndexedWidgetBuilder itemBuilder,
    int itemCount,
    this.scrollDirection = Axis.horizontal,
    CanMovePage canMovePage,
    CanScrollPage canScrollPage,
    this.pageSnapping = true,
    this.onPageChanged,
  })  : controller = controller ?? _defaultPageController,
        physics = physics != null
            ? _defaultScrollPhysics.applyTo(physics)
            : _defaultScrollPhysics,
        childrenDelegate =
            SliverChildBuilderDelegate(itemBuilder, childCount: itemCount),
        canMovePage = canMovePage ?? _defaultCanMovePage,
        canScrollPage = canScrollPage ?? _defaultCanScrollPage,
        super(key: key);

  final ScrollPhysics physics;

  /// Whether the page view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the page view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the page view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  final PageController controller;
  final SliverChildDelegate childrenDelegate;

  /// 滚动方向
  final Axis scrollDirection;

  ///Whether we can scroll page
  final CanScrollPage canScrollPage;

  ///Whether we can move to previous/next page only for Image
  final CanMovePage canMovePage;

  /// Set to false to disable page snapping, useful for custom scroll behavior.
  final bool pageSnapping;

  /// Called whenever the page in the center of the viewport changes.
  final ValueChanged<int> onPageChanged;

  @override
  DRPhotoGesturePageViewState createState() => DRPhotoGesturePageViewState();
}

class DRPhotoGesturePageViewState extends State<DRPhotoGesturePageView>
    with SingleTickerProviderStateMixin {
  Map<Type, GestureRecognizerFactory> _gestureRecognizers =
      const <Type, GestureRecognizerFactory>{};
  DRGestureAnimation _gestureAnimation;
  ScrollPosition get position => pageController.position;
  PageController get pageController => widget.controller;

  DRPhotoGesturedImageState gesturedImageState;

  @override
  void initState() {
    super.initState();
    _gestureAnimation = DRGestureAnimation(
      this,
      offsetCallBack: (Offset value) {
        final DRGestureDetails gestureDetails =
            gesturedImageState?.gestureDetails;
        if (gestureDetails != null) {
          gesturedImageState?.gestureDetails = DRGestureDetails(
            offset: value,
            totalScale: gestureDetails.totalScale,
            gestureDetails: gestureDetails,
          );
        }
      },
    );
    _initGestureRecognizers();
  }

  void _initGestureRecognizers({DRPhotoGesturePageView oldWidget}) {
    if (oldWidget == null ||
        oldWidget.scrollDirection != widget.scrollDirection ||
        oldWidget.physics.parent != widget.physics.parent) {
      bool canMove = true;

      ///user's physics
      if (widget.physics.parent != null) {
        canMove =
            widget.physics.parent.shouldAcceptUserOffset(_testPageMetrics);
      }
      if (canMove) {
        switch (widget.scrollDirection) {
          case Axis.vertical:
            _gestureRecognizers = <Type, GestureRecognizerFactory>{
              VerticalDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer(),
                (VerticalDragGestureRecognizer instance) {
                  instance
                    ..onDown = _handleDragDown
                    ..onStart = _handleDragStart
                    ..onUpdate = _handleDragUpdate
                    ..onEnd = _handleDragEnd
                    ..onCancel = _handleDragCancel
                    ..minFlingDistance = widget.physics?.minFlingDistance
                    ..minFlingVelocity = widget.physics?.minFlingVelocity
                    ..maxFlingVelocity = widget.physics?.maxFlingVelocity;
                },
              ),
            };
            break;
          case Axis.horizontal:
            _gestureRecognizers = <Type, GestureRecognizerFactory>{
              HorizontalDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                      HorizontalDragGestureRecognizer>(
                () => HorizontalDragGestureRecognizer(),
                (HorizontalDragGestureRecognizer instance) {
                  instance
                    ..onDown = _handleDragDown
                    ..onStart = _handleDragStart
                    ..onUpdate = _handleDragUpdate
                    ..onEnd = _handleDragEnd
                    ..onCancel = _handleDragCancel
                    ..minFlingDistance = widget.physics?.minFlingDistance
                    ..minFlingVelocity = widget.physics?.minFlingVelocity
                    ..maxFlingVelocity = widget.physics?.maxFlingVelocity;
                },
              ),
            };
            break;
        }
      }
    }
  }

  Drag _drag;
  ScrollHoldController _hold;

  void _handleDragDown(DragDownDetails details) {
    //print(details);
    _gestureAnimation.stop();
    assert(_drag == null);
    assert(_hold == null);
    _hold = position.hold(_disposeHold);
  }

  void _handleDragStart(DragStartDetails details) {
    // It's possible for _hold to become null between _handleDragDown and
    // _handleDragStart, for example if some user code calls jumpTo or otherwise
    // triggers a new activity to begin.
    assert(_drag == null);
    _drag = position.drag(details, _disposeDrag);
    assert(_drag != null);
    assert(_hold == null);
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    final Offset delta = details.delta;
    if (!widget.canScrollPage(gesturedImageState?.gestureDetails)) {
      return;
    }

    if (gesturedImageState != null) {
      final DRGestureDetails gestureDetails = gesturedImageState.gestureDetails;
      if (gestureDetails != null) {
        final int currentPage = pageController.page.round();

        if ((gestureDetails.movePage(delta) ||
                (currentPage != pageController.page)) &&
            widget.canMovePage(gestureDetails)) {
          _drag?.update(details);
        } else {
          if (currentPage == pageController.page) {
            gesturedImageState.gestureDetails = DRGestureDetails(
                offset: gestureDetails.offset +
                    delta * gesturedImageState.imageGestureConfig.speed,
                totalScale: gestureDetails.totalScale,
                gestureDetails: gestureDetails);
          }
        }
      } else {
        _drag?.update(details);
      }
    } else {
      _drag?.update(details);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    if (!widget.canScrollPage(gesturedImageState?.gestureDetails)) {
      _drag.end(DragEndDetails(primaryVelocity: 0.0));
      return;
    }
    DragEndDetails temp = details;
    if (gesturedImageState != null) {
      final DRGestureDetails gestureDetails = gesturedImageState.gestureDetails;
      final int currentPage = pageController.page.round();
      final bool movePage = pageController.page != currentPage;

      if (!widget.canMovePage(gestureDetails)) {
        //stop
        temp = DragEndDetails(primaryVelocity: 0.0);
      }

      /// stop when zoom in, so that it will not move to next/previous page
      if (!movePage &&
          gestureDetails != null &&
          gestureDetails.totalScale > 1.0 &&
          (gestureDetails.computeHorizontalBoundary ||
              gestureDetails.computeVerticalBoundary)) {
        //stop
        temp = DragEndDetails(primaryVelocity: 0.0);

        // get magnitude from gesture velocity
        final double magnitude = details.velocity.pixelsPerSecond.distance;

        // do a significant magnitude
        if (doubleCompare(magnitude, minMagnitude) >= 0) {
          Offset direction = details.velocity.pixelsPerSecond /
              magnitude *
              (gesturedImageState.imageGestureConfig.inertialSpeed);

          if (widget.scrollDirection == Axis.horizontal) {
            direction = Offset(direction.dx, 0.0);
          } else {
            direction = Offset(0.0, direction.dy);
          }

          _gestureAnimation.animationOffset(
              gestureDetails.offset, gestureDetails.offset + direction);
        }
      }
    }

    _drag.end(temp);

    assert(_drag == null);
  }

  void _handleDragCancel() {
    // _hold might be null if the drag started.
    // _drag might be null if the drag activity ended and called _disposeDrag.
    assert(_hold == null || _drag == null);
    _hold?.cancel();
    _drag?.cancel();
    assert(_hold == null);
    assert(_drag == null);
  }

  void _disposeHold() {
    _hold = null;
  }

  void _disposeDrag() {
    _drag = null;
  }

  @override
  void didUpdateWidget(DRPhotoGesturePageView oldWidget) {
    _initGestureRecognizers(oldWidget: oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _gestureAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = PageView.custom(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      childrenDelegate: widget.childrenDelegate,
      pageSnapping: widget.pageSnapping,
      physics: widget.physics,
      onPageChanged: widget.onPageChanged,
      key: widget.key,
    );

    if (widget.physics.parent == null ||
        widget.physics.parent.shouldAcceptUserOffset(_testPageMetrics)) {
      result = RawGestureDetector(
        gestures: _gestureRecognizers,
        behavior: HitTestBehavior.opaque,
        child: result,
      );
    }

    return result;
  }
}
