import './dr_photo_browser_typedef.dart';

class DRGestureConfig {
  DRGestureConfig({
    double minScale,
    double maxScale,
    double speed,
    bool cacheGesture,
    double inertialSpeed,
    double initialScale,
    bool inPageView,
    double animationMinScale,
    double animationMaxScale,
    this.initialAlignment = DRInitialAlignment.center,
  })  : minScale = minScale ??= 0.8,
        maxScale = maxScale ??= 5.0,
        speed = speed ??= 1.0,
        cacheGesture = cacheGesture ?? false,
        inertialSpeed = inertialSpeed ??= 100.0,
        initialScale = initialScale ??= 1.0,
        inPageView = inPageView ?? false,
        animationMinScale = animationMinScale ??= minScale * 0.8,
        animationMaxScale = animationMaxScale ??= maxScale * 1.2,
        assert(minScale <= maxScale),
        assert(animationMinScale <= animationMaxScale),
        assert(animationMinScale <= minScale),
        assert(animationMaxScale >= maxScale),
        assert(minScale <= initialScale && initialScale <= maxScale),
        assert(speed > 0),
        assert(inertialSpeed > 0);
  //the min scale for zooming then animation back to minScale when scale end
  final double animationMinScale;
  //min scale
  final double minScale;

  //the max scale for zooming then animation back to maxScale when scale end
  final double animationMaxScale;
  //max scale
  final double maxScale;

  //speed for zoom/pan
  final double speed;

  ///save Gesture state (for example in page view, so that the state will not change when scroll back),
  ///remember clearGestureDetailsCache  at right time
  final bool cacheGesture;

  ///whether in page view
  final bool inPageView;

  /// final double magnitude = details.velocity.pixelsPerSecond.distance;
  ///final Offset direction = details.velocity.pixelsPerSecond / magnitude * _gestureConfig.inertialSpeed;
  final double inertialSpeed;

  ///initial scale of image
  final double initialScale;

  /// init image rect with alignment when initialScale > 1.0
  /// see https://github.com/fluttercandies/extended_image/issues/66
  final DRInitialAlignment initialAlignment;
}
