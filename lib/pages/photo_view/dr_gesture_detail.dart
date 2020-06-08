import 'package:flutter/material.dart';
import './dr_photo_browser_utils.dart';
import './dr_photo_browser_typedef.dart';

///gesture

class DRGestureDetails {
  DRGestureDetails(
      {this.offset,
      this.totalScale,
      DRGestureDetails gestureDetails,
      this.actionType = DRActionType.pan,
      this.userOffset = true}) {
    if (gestureDetails != null) {
      _computeVerticalBoundary = gestureDetails._computeVerticalBoundary;
      _computeHorizontalBoundary = gestureDetails._computeHorizontalBoundary;
      _center = gestureDetails._center;
      layoutRect = gestureDetails.layoutRect;
      destinationRect = gestureDetails.destinationRect;

      ///zoom end will call twice
      /// zoom end
      /// zoom start
      /// zoom update
      /// zoom end
    }
  }

  ///scale center delta
  Offset offset;

  ///total scale of image
  final double totalScale;

  final DRActionType actionType;

  bool _computeVerticalBoundary = false;
  bool get computeVerticalBoundary => _computeVerticalBoundary;

  bool _computeHorizontalBoundary = false;
  bool get computeHorizontalBoundary => _computeHorizontalBoundary;

  DRBoundary _boundary = DRBoundary();
  DRBoundary get boundary => _boundary;

  //true: user zoom/pan
  //false: animation
  final bool userOffset;

  //pre
  Offset _center;

  Rect layoutRect;
  Rect destinationRect;

  ///from
  Rect rawDestinationRect;

  DRInitialAlignment initialAlignment;

  ///slide page offset
  Offset slidePageOffset;

  @override
  int get hashCode => hashValues(
      offset,
      totalScale,
      computeVerticalBoundary,
      computeHorizontalBoundary,
      boundary,
      actionType,
      userOffset,
      layoutRect,
      destinationRect,
      _center);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is DRGestureDetails &&
        offset == other.offset &&
        totalScale == other.totalScale &&
        computeVerticalBoundary == other.computeVerticalBoundary &&
        computeHorizontalBoundary == other.computeHorizontalBoundary &&
        boundary == other.boundary &&
        actionType == other.actionType &&
        userOffset == other.userOffset &&
        layoutRect == other.layoutRect &&
        destinationRect == other.destinationRect &&
        _center == other._center;
  }

  Offset _getCenter(Rect destinationRect) {
    if (!userOffset && _center != null) {
      return _center;
    }
    //var offset = editAction.paintOffset(this.offset);
    if (totalScale > 1.0) {
      if (_computeHorizontalBoundary && _computeVerticalBoundary) {
        return destinationRect.center * totalScale + offset;
      } else if (_computeHorizontalBoundary) {
        //only scale Horizontal
        return Offset(destinationRect.center.dx * totalScale,
                destinationRect.center.dy) +
            Offset(offset.dx, 0.0);
      } else if (_computeVerticalBoundary) {
        //only scale Vertical
        return Offset(destinationRect.center.dx,
                destinationRect.center.dy * totalScale) +
            Offset(0.0, offset.dy);
      } else {
        return destinationRect.center;
      }
    } else {
      return destinationRect.center;
    }
  }

  Offset _getFixedOffset(Rect destinationRect, Offset center) {
    if (totalScale > 1.0) {
      if (_computeHorizontalBoundary && _computeVerticalBoundary) {
        return center - destinationRect.center * totalScale;
      } else if (_computeHorizontalBoundary) {
        //only scale Horizontal
        return center -
            Offset(destinationRect.center.dx * totalScale,
                destinationRect.center.dy);
      } else if (_computeVerticalBoundary) {
        //only scale Vertical
        return center -
            Offset(destinationRect.center.dx,
                destinationRect.center.dy * totalScale);
      } else {
        return center - destinationRect.center;
      }
    } else {
      return center - destinationRect.center;
    }
  }

  Rect _getDestinationRect(Rect destinationRect, Offset center) {
    final double width = destinationRect.width * totalScale;
    final double height = destinationRect.height * totalScale;
    return Rect.fromLTWH(
        center.dx - width / 2.0, center.dy - height / 2.0, width, height);
  }

  Rect calculateFinalDestinationRect(Rect layoutRect, Rect destinationRect) {
    final bool destinationRectChanged = rawDestinationRect != destinationRect;

    rawDestinationRect = destinationRect;

    final Offset temp = offset;
    _innerCalculateFinalDestinationRect(layoutRect, destinationRect);
    offset = temp;
    Rect result =
        _innerCalculateFinalDestinationRect(layoutRect, destinationRect);

    ///first call,initial image rect with alignment
    if (totalScale > 1.0 &&
        destinationRectChanged &&
        initialAlignment != null) {
      offset = _getFixedOffset(destinationRect,
          result.center + _getCenterDif(result, layoutRect, initialAlignment));
      result = _innerCalculateFinalDestinationRect(layoutRect, destinationRect);
      //initialAlignment = null;
    }
    this.destinationRect = result;
    this.layoutRect = layoutRect;
    return result;
  }

  Offset _getCenterDif(Rect result, Rect layout, DRInitialAlignment alignment) {
    switch (alignment) {
      case DRInitialAlignment.topLeft:
        return layout.topLeft - result.topLeft;
      case DRInitialAlignment.topCenter:
        return layout.topCenter - result.topCenter;
      case DRInitialAlignment.topRight:
        return layout.topRight - result.topRight;
      case DRInitialAlignment.centerLeft:
        return layout.centerLeft - result.centerLeft;
      case DRInitialAlignment.center:
        return layout.center - result.center;
      case DRInitialAlignment.centerRight:
        return layout.centerRight - result.centerRight;
      case DRInitialAlignment.bottomLeft:
        return layout.bottomLeft - result.bottomLeft;
      case DRInitialAlignment.bottomCenter:
        return layout.bottomCenter - result.bottomCenter;
      case DRInitialAlignment.bottomRight:
        return layout.bottomRight - result.bottomRight;
      default:
        return Offset.zero;
    }
  }

  Rect _innerCalculateFinalDestinationRect(
      Rect layoutRect, Rect destinationRect) {
    _boundary = DRBoundary();
    final Offset center = _getCenter(destinationRect);
    Rect result = _getDestinationRect(destinationRect, center);

    if (_computeHorizontalBoundary) {
      //move right
      if (doubleCompare(result.left, layoutRect.left) >= 0) {
        result = Rect.fromLTWH(
            layoutRect.left, result.top, result.width, result.height);
        _boundary.left = true;
      }

      ///move left
      if (doubleCompare(result.right, layoutRect.right) <= 0) {
        result = Rect.fromLTWH(layoutRect.right - result.width, result.top,
            result.width, result.height);
        _boundary.right = true;
      }
    }

    if (_computeVerticalBoundary) {
      //move down
      if (doubleCompare(result.bottom, layoutRect.bottom) <= 0) {
        result = Rect.fromLTWH(result.left, layoutRect.bottom - result.height,
            result.width, result.height);
        _boundary.bottom = true;
      }

      //move up
      if (doubleCompare(result.top, layoutRect.top) >= 0) {
        result = Rect.fromLTWH(
            result.left, layoutRect.top, result.width, result.height);
        _boundary.top = true;
      }
    }

    _computeHorizontalBoundary =
        doubleCompare(result.left, layoutRect.left) <= 0 &&
            doubleCompare(result.right, layoutRect.right) >= 0;

    _computeVerticalBoundary = doubleCompare(result.top, layoutRect.top) <= 0 &&
        doubleCompare(result.bottom, layoutRect.bottom) >= 0;

    offset = _getFixedOffset(destinationRect, result.center);
    _center = result.center;

    return result;
  }

  bool movePage(Offset delta) {
    final bool canMoveHorizontal = delta.dx != 0 &&
        ((delta.dx < 0 && boundary.right) ||
            (delta.dx > 0 && boundary.left) ||
            !_computeHorizontalBoundary);

    final bool canMoveVertical = delta.dy != 0 &&
        ((delta.dy < 0 && boundary.bottom) ||
            (delta.dy > 0 && boundary.top) ||
            !_computeVerticalBoundary);

    return canMoveHorizontal || canMoveVertical || totalScale <= 1.0;
  }
}

class DRBoundary {
  DRBoundary({
    this.left = false,
    this.right = false,
    this.top = false,
    this.bottom = false,
  });

  bool left;
  bool right;
  bool bottom;
  bool top;

  @override
  String toString() {
    return 'left:$left,right:$right,top:$top,bottom:$bottom';
  }

  @override
  int get hashCode => hashValues(left, right, top, bottom);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is DRBoundary &&
        left == other.left &&
        right == other.right &&
        top == other.top &&
        bottom == other.bottom;
  }
}
