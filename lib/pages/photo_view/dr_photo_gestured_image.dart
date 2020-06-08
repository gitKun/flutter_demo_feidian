import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:pagetext/pages/photo_view/dr_photo_gesture_page.dart';
import 'package:pagetext/pages/photo_view/dr_photo_raw_image.dart';
import 'package:pagetext/pages/photo_view/dr_photo_slide_page.dart';
import './dr_photo_browser_typedef.dart';
import 'dr_gesture_animation.dart';
import 'dr_gesture_config.dart';
import 'dr_gesture_detail.dart';
import 'dr_photo_browser_utils.dart';

bool _defaultCanScaleImage(DRGestureDetails details) => true;

Map<Object, DRGestureDetails> _gestureDetailsCache =
    <Object, DRGestureDetails>{};

///clear the gesture details
void clearGestureDetailsCache() {
  _gestureDetailsCache.clear();
}

class DRPhotoGesturedImage extends StatefulWidget {
  const DRPhotoGesturedImage({
    @required this.imageBuilder,
    @required this.uiImage,
    CanScaleImage canScaleImage,
    this.initGestureConfigHandler,
    this.onDoubleTap,
    this.heroBuilderForSlidingPage,
    Key key,
  })  : canScaleImage = canScaleImage ?? _defaultCanScaleImage,
        super(key: key);

  final ImageBuilderForGesture imageBuilder;
  final CanScaleImage canScaleImage;
  final InitGestureConfigHandler initGestureConfigHandler;
  final DoubleTap onDoubleTap;
  final HeroBuilderForSlidingPage heroBuilderForSlidingPage;
  final ui.Image uiImage;
  @override
  DRPhotoGesturedImageState createState() => DRPhotoGesturedImageState();
}

class DRPhotoGesturedImageState extends State<DRPhotoGesturedImage>
    with TickerProviderStateMixin {
  DRGestureDetails _gestureDetails;
  Offset _normalizedOffset;
  double _startingScale;
  Offset _startingOffset;
  Offset _pointerDownPosition;
  DRGestureAnimation _gestureAnimation;
  DRGestureConfig _gestureConfig;
  DRPhotoGesturePageViewState _pageViewState;

  DRPhotoSlidePageState photoSlidePageState;

  /// 解决报错添加

  final String imageGestureCacheKey = 'CacheKey';

  @override
  void initState() {
    _initGestureConfig();
    super.initState();
  }

  void _initGestureConfig() {
    final double initialScale = _gestureConfig?.initialScale;
    final DRInitialAlignment initialAlignment =
        _gestureConfig?.initialAlignment;
    _gestureConfig =
        widget.initGestureConfigHandler?.call() ?? DRGestureConfig();

    if (_gestureDetails == null ||
        initialScale != _gestureConfig.initialScale ||
        initialAlignment != _gestureConfig.initialAlignment) {
      _gestureDetails = DRGestureDetails(
        totalScale: _gestureConfig.initialScale,
        offset: Offset.zero,
      )..initialAlignment = _gestureConfig.initialAlignment;
    }

    if (_gestureConfig.cacheGesture) {
      final DRGestureDetails cache = _gestureDetailsCache[imageGestureCacheKey];
      if (cache != null) {
        _gestureDetails = cache;
      }
    }
    _gestureDetails ??= DRGestureDetails(
      totalScale: _gestureConfig.initialScale,
      offset: Offset.zero,
    );

    _gestureAnimation =
        DRGestureAnimation(this, offsetCallBack: (Offset value) {
      if (mounted) {
        setState(() {
          _gestureDetails = DRGestureDetails(
              offset: value,
              totalScale: _gestureDetails.totalScale,
              gestureDetails: _gestureDetails);
        });
      }
    }, scaleCallBack: (double scale) {
      if (mounted) {
        setState(() {
          _gestureDetails = DRGestureDetails(
              offset: _gestureDetails.offset,
              totalScale: scale,
              gestureDetails: _gestureDetails,
              actionType: DRActionType.zoom,
              userOffset: false);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    _pageViewState = null;
    photoSlidePageState = null;
    if (_gestureConfig.inPageView) {
      _pageViewState =
          context.findAncestorStateOfType<DRPhotoGesturePageViewState>();
      photoSlidePageState =
          context.findAncestorStateOfType<DRPhotoSlidePageState>();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(DRPhotoGesturedImage oldWidget) {
    _initGestureConfig();
    _pageViewState = null;
    photoSlidePageState = null;
    if (_gestureConfig.inPageView) {
      _pageViewState =
          context.findAncestorStateOfType<DRPhotoGesturePageViewState>();
      photoSlidePageState =
          context.findAncestorStateOfType<DRPhotoSlidePageState>();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _gestureAnimation?.stop();
    _gestureAnimation?.dispose();
    super.dispose();
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _gestureAnimation.stop();
    _normalizedOffset = (details.focalPoint - _gestureDetails.offset) /
        _gestureDetails.totalScale;
    _startingScale = _gestureDetails.totalScale;
    _startingOffset = details.focalPoint;
  }

  Offset _updateSlidePagePreOffset;

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    ///whether gesture page
    if (photoSlidePageState != null &&
        details.scale == 1.0 &&
        _gestureDetails.userOffset &&
        _gestureDetails.actionType == DRActionType.pan) {
      final Offset offsetDelta = details.focalPoint - _startingOffset;
      //print(offsetDelta);
      bool updateGesture = false;
      if (!photoSlidePageState.isSliding) {
        if (offsetDelta.dx != 0 &&
            doubleCompare(offsetDelta.dx.abs(), offsetDelta.dy.abs()) > 0) {
          if (_gestureDetails.computeHorizontalBoundary) {
            if (offsetDelta.dx > 0) {
              updateGesture = _gestureDetails.boundary.left;
            } else {
              updateGesture = _gestureDetails.boundary.right;
            }
          } else {
            updateGesture = true;
          }
        }
        if (offsetDelta.dy != 0 &&
            doubleCompare(offsetDelta.dy.abs(), offsetDelta.dx.abs()) > 0) {
          if (_gestureDetails.computeVerticalBoundary) {
            if (offsetDelta.dy < 0) {
              updateGesture = _gestureDetails.boundary.bottom;
            } else {
              updateGesture = _gestureDetails.boundary.top;
            }
          } else {
            updateGesture = true;
          }
        }
      } else {
        updateGesture = true;
      }

      final double delta = (details.focalPoint - _startingOffset).distance;

      if (doubleCompare(delta, minGesturePageDelta) > 0 && updateGesture) {
        _updateSlidePagePreOffset ??= details.focalPoint;
        photoSlidePageState.slide(
            details.focalPoint - _updateSlidePagePreOffset,
            gesturedImageState: this);
        _updateSlidePagePreOffset = details.focalPoint;
      }
    }

    if (photoSlidePageState != null && photoSlidePageState.isSliding) {
      return;
    }

    final double scale = widget.canScaleImage(_gestureDetails)
        ? clampScale(_startingScale * details.scale * _gestureConfig.speed,
            _gestureConfig.animationMinScale, _gestureConfig.animationMaxScale)
        : _gestureDetails.totalScale;

    //Round the scale to three points after comma to prevent shaking
    //scale = roundAfter(scale, 3);
    //no more zoom
    if (details.scale != 1.0 &&
        ((doubleEqual(_gestureDetails.totalScale,
                    _gestureConfig.animationMinScale) &&
                doubleCompare(scale, _gestureDetails.totalScale) <= 0) ||
            (doubleEqual(_gestureDetails.totalScale,
                    _gestureConfig.animationMaxScale) &&
                doubleCompare(scale, _gestureDetails.totalScale) >= 0))) {
      return;
    }

    final Offset offset =
        (details.scale == 1.0 ? details.focalPoint : _startingOffset) -
            _normalizedOffset * scale;

    if (mounted &&
        (offset != _gestureDetails.offset ||
            scale != _gestureDetails.totalScale)) {
      setState(() {
        _gestureDetails = DRGestureDetails(
            offset: offset,
            totalScale: scale,
            gestureDetails: _gestureDetails,
            actionType:
                details.scale != 1.0 ? DRActionType.zoom : DRActionType.pan);
      });
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (photoSlidePageState != null && photoSlidePageState.isSliding) {
      _updateSlidePagePreOffset = null;
      // _updateSlidePageImageStartingOffset = null;
      photoSlidePageState.endSlide(details);
      return;
    }
    //animate back to maxScale if gesture exceeded the maxScale specified
    if (doubleCompare(_gestureDetails.totalScale, _gestureConfig.maxScale) >
        0) {
      final double velocity =
          (_gestureDetails.totalScale - _gestureConfig.maxScale) /
              _gestureConfig.maxScale;

      _gestureAnimation.animationScale(
          _gestureDetails.totalScale, _gestureConfig.maxScale, velocity);
      return;
    }

    //animate back to minScale if gesture fell smaller than the minScale specified
    if (doubleCompare(_gestureDetails.totalScale, _gestureConfig.minScale) <
        0) {
      final double velocity =
          (_gestureConfig.minScale - _gestureDetails.totalScale) /
              _gestureConfig.minScale;

      _gestureAnimation.animationScale(
          _gestureDetails.totalScale, _gestureConfig.minScale, velocity);
      return;
    }

    if (_gestureDetails.actionType == DRActionType.pan) {
      // get magnitude from gesture velocity
      final double magnitude = details.velocity.pixelsPerSecond.distance;

      // do a significant magnitude
      if (doubleCompare(magnitude, minMagnitude) >= 0) {
        final Offset direction = details.velocity.pixelsPerSecond /
            magnitude *
            _gestureConfig.inertialSpeed;

        _gestureAnimation.animationOffset(
            _gestureDetails.offset, _gestureDetails.offset + direction);
      }
    }
  }

  void _handleDoubleTap() {
    if (widget.onDoubleTap != null) {
      widget.onDoubleTap(this);
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _gestureDetails = DRGestureDetails(
        offset: Offset.zero,
        totalScale: _gestureConfig.initialScale,
      );
    });
  }

  void _handlePointerDown(PointerDownEvent pointerDownEvent) {
    _pointerDownPosition = pointerDownEvent.position;

    _gestureAnimation.stop();

    _pageViewState?.gesturedImageState = this;
  }

  @override
  Widget build(BuildContext context) {
    if (_gestureConfig.cacheGesture) {
      _gestureDetailsCache[imageGestureCacheKey] = _gestureDetails;
    }

    Widget image = DRPhotoRawImage(
      image: widget.uiImage,
      scale: 1.0,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      repeat: ImageRepeat.noRepeat,
      matchTextDirection: false,
      filterQuality: FilterQuality.low,
      gestureDetails: _gestureDetails,
    );

    image = widget.imageBuilder(image);
    image = widget.heroBuilderForSlidingPage?.call(image) ?? image;

    if (photoSlidePageState != null) {
      if (photoSlidePageState.widget.slideType == DRSlideType.onlyImage) {
        image = Transform.translate(
          offset: photoSlidePageState.offset,
          child: Transform.scale(
            scale: photoSlidePageState.scale,
            child: image,
          ),
        );
      }
    }

    image = GestureDetector(
      child: image,
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      onDoubleTap: _handleDoubleTap,
    );

    image = Listener(
      child: image,
      onPointerDown: _handlePointerDown,
    );

    return image;
  }

  DRGestureDetails get gestureDetails => _gestureDetails;
  set gestureDetails(DRGestureDetails value) {
    if (mounted) {
      setState(() {
        _gestureDetails = value;
      });
    }
  }

  DRGestureConfig get imageGestureConfig => _gestureConfig;

  void handleDoubleTap({double scale, Offset doubleTapPosition}) {
    doubleTapPosition ??= _pointerDownPosition;
    scale ??= _gestureConfig.initialScale;
    //scale = scale.clamp(_gestureConfig.minScale, _gestureConfig.maxScale);
    _handleScaleStart(ScaleStartDetails(focalPoint: doubleTapPosition));
    _handleScaleUpdate(ScaleUpdateDetails(
        focalPoint: doubleTapPosition, scale: scale / _startingScale));
    if (scale < _gestureConfig.minScale || scale > _gestureConfig.maxScale) {
      _handleScaleEnd(ScaleEndDetails());
    }
  }

  Offset get pointerDownPosition => _pointerDownPosition;

  void slide() {
    if (mounted) {
      setState(() {
        _gestureDetails.slidePageOffset = photoSlidePageState?.offset;
      });
    }
  }

  void reset() {
    if (mounted) {
      setState(() {
        _gestureConfig =
            widget.initGestureConfigHandler?.call() ?? DRGestureConfig();
        _gestureDetails = DRGestureDetails(
          totalScale: _gestureConfig.initialScale,
          offset: Offset.zero,
        )..initialAlignment = _gestureConfig.initialAlignment;
      });
    }
  }
}
