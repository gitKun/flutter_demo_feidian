import 'dart:math';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import './dr_photo_browser_typedef.dart';

///get type from T
Type typeOf<T>() => T;

double clampScale(double scale, double min, double max) {
  return scale.clamp(min, max) as double;
}

/// Returns a value indicating whether two instances of Double represent the same value.
///
/// [value] equal to [other] will return `true`, otherwise, `false`.
///
/// If [value] or [other] is not finite (`NaN` or infinity), throws an [UnsupportedError].
bool doubleEqual(double value, double other) {
  return doubleCompare(value, other) == 0;
}

/// Compare two double-precision values.
/// Returns an integer that indicates whether [value] is less than, equal to, or greater than [other].
///
/// [value] less than [other] will return `-1`
/// [value] equal to [other] will return `0`
/// [value] greater than [other] will return `1`
///
/// If [value] or [other] is not finite (`NaN` or infinity), throws an [UnsupportedError].
int doubleCompare(double value, double other,
    {double precision = precisionErrorTolerance}) {
  if (value.isNaN || other.isNaN) {
    throw UnsupportedError('Compared with Infinity or NaN');
  }
  final double n = value - other;
  if (n.abs() < precision) {
    return 0;
  }
  return n < 0 ? -1 : 1;
}

///whether gesture rect is out size
bool outRect(Rect rect, Rect destinationRect) {
  return doubleCompare(destinationRect.top, rect.top) < 0 ||
      doubleCompare(destinationRect.left, rect.left) < 0 ||
      doubleCompare(destinationRect.right, rect.right) > 0 ||
      doubleCompare(destinationRect.bottom, rect.bottom) > 0;
}

double roundAfter(double number, int position) {
  final double shift = pow(10, position).toDouble();
  return (number * shift).roundToDouble() / shift;
}

///ExtendedImageGesturePage-start

Color defaultSlidePageBackgroundHandler(
    {Offset offset, Size pageSize, Color color, DRSlideAxis pageGestureAxis}) {
  double opacity = 0.0;
  if (pageGestureAxis == DRSlideAxis.both) {
    opacity = offset.distance /
        (Offset(pageSize.width, pageSize.height).distance / 2.0);
  } else if (pageGestureAxis == DRSlideAxis.horizontal) {
    opacity = offset.dx.abs() / (pageSize.width / 2.0);
  } else if (pageGestureAxis == DRSlideAxis.vertical) {
    opacity = offset.dy.abs() / (pageSize.height / 2.0);
  }
  return color.withOpacity(min(1.0, max(1.0 - opacity, 0.0)));
}

bool defaultSlideEndHandler(
    {Offset offset, Size pageSize, DRSlideAxis pageGestureAxis}) {
  const int parameter = 6;
  if (pageGestureAxis == DRSlideAxis.both) {
    return doubleCompare(offset.distance,
            Offset(pageSize.width, pageSize.height).distance / parameter) >
        0;
  } else if (pageGestureAxis == DRSlideAxis.horizontal) {
    return doubleCompare(offset.dx.abs(), pageSize.width / parameter) > 0;
  } else if (pageGestureAxis == DRSlideAxis.vertical) {
    return doubleCompare(offset.dy.abs(), pageSize.height / parameter) > 0;
  }
  return true;
}

double defaultSlideScaleHandler(
    {Offset offset, Size pageSize, DRSlideAxis pageGestureAxis}) {
  double scale = 0.0;
  if (pageGestureAxis == DRSlideAxis.both) {
    scale = offset.distance / Offset(pageSize.width, pageSize.height).distance;
  } else if (pageGestureAxis == DRSlideAxis.horizontal) {
    scale = offset.dx.abs() / (pageSize.width / 2.0);
  } else if (pageGestureAxis == DRSlideAxis.vertical) {
    scale = offset.dy.abs() / (pageSize.height / 2.0);
  }
  return max(1.0 - scale, 0.8);
}

///ExtendedImageGesturePage-end
