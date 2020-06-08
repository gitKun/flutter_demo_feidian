import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:pagetext/pages/photo_view/dr_photo_gestured_image.dart';
import 'package:pagetext/pages/photo_view/dr_photo_slide_page.dart';
import './dr_gesture_detail.dart';
import 'dr_gesture_config.dart';

enum DRSlideAxis {
  both,
  horizontal,
  vertical,
}

enum DRSlideType {
  wholePage,
  onlyImage,
}

enum DRActionType {
  ///zoom in/ zoom out
  zoom,

  /// horizontal and vertical move
  pan,

  ///flip,rotate
  edit,
}

enum DRInitialAlignment {
  /// The top left corner.
  topLeft,

  /// The center point along the top edge.
  topCenter,

  /// The top right corner.
  topRight,

  /// The center point along the left edge.
  centerLeft,

  /// The center point, both horizontally and vertically.
  center,

  /// The center point along the right edge.
  centerRight,

  /// The bottom left corner.
  bottomLeft,

  /// The center point along the bottom edge.
  bottomCenter,

  /// The bottom right corner.
  bottomRight,
}

//enum InPageView {
//  ///image is not in pageview
//  none,
//
//  ///image is in horizontal pageview
//  horizontal,
//
//  ///image is in vertical pageview
//  vertical
//}

///whether we can move to previous/next page only for Image
typedef CanMovePage = bool Function(DRGestureDetails gestureDetails);

///whether we can scroll page
typedef CanScrollPage = bool Function(DRGestureDetails gestureDetails);

/// animation call back for inertia drag
typedef GestureOffsetAnimationCallBack = void Function(Offset offset);

/// animation call back for scale
typedef GestureScaleAnimationCallBack = void Function(double scale);

///build Gesture Image
typedef BuildGestureImage = Widget Function(DRGestureDetails gestureDetails);

///build image for gesture, we can handle custom Widget about gesture
typedef ImageBuilderForGesture = Widget Function(Widget image);

///whether should scale image
typedef CanScaleImage = bool Function(DRGestureDetails details);

///init GestureConfig when image is ready.
typedef InitGestureConfigHandler = DRGestureConfig Function();

/// double tap call back
typedef DoubleTap = void Function(DRPhotoGesturedImageState state);

///build Hero only for sliding page
///the transform of sliding page must be working on Hero
///so that Hero animation wouldn't be strange when pop page
typedef HeroBuilderForSlidingPage = Widget Function(Widget widget);

/// build page background when slide page
typedef SlidePageBackgroundHandler = Color Function(
    Offset offset, Size pageSize);

///customize scale of page when slide page
typedef SlideScaleHandler = double Function(
  Offset offset, {
  DRPhotoSlidePageState state,
});

/// customize offset of page when slide page
typedef SlideOffsetHandler = Offset Function(
  Offset offset, {
  DRPhotoSlidePageState state,
});

///if return true ,pop page
///else reset page state
typedef SlideEndHandler = bool Function(
  Offset offset, {
  DRPhotoSlidePageState state,
  ScaleEndDetails details,
});

///on sliding page
typedef OnSlidingPage = void Function(DRPhotoSlidePageState state);

/////// render_painter

typedef AfterPaintImage = void Function(
    Canvas canvas, Rect rect, ui.Image image, Paint paint);

///[rect] is render size
///if return true, it will not paint original image,
typedef BeforePaintImage = bool Function(
    Canvas canvas, Rect rect, ui.Image image, Paint paint);
