import 'package:flutter/material.dart';

import './dr_photo_browser_typedef.dart';

const double minMagnitude = 400.0;
const double velocity = minMagnitude / 1000.0;
const double minGesturePageDelta = 5.0;

class DRGestureAnimation {
  DRGestureAnimation(TickerProvider vsync,
      {GestureOffsetAnimationCallBack offsetCallBack,
      GestureScaleAnimationCallBack scaleCallBack}) {
    if (offsetCallBack != null) {
      _offsetController = AnimationController(vsync: vsync);
      _offsetController.addListener(() {
        //print(_animation.value);
        offsetCallBack(_offsetAnimation.value);
      });
    }

    if (scaleCallBack != null) {
      _scaleController = AnimationController(vsync: vsync);
      _scaleController.addListener(() {
        scaleCallBack(_scaleAnimation.value);
      });
    }
  }

  AnimationController _offsetController;
  Animation<Offset> _offsetAnimation;

  AnimationController _scaleController;
  Animation<double> _scaleAnimation;

  void animationOffset(Offset begin, Offset end) {
    if (_offsetController == null) {
      return;
    }
    _offsetAnimation =
        _offsetController.drive(Tween<Offset>(begin: begin, end: end));
    _offsetController
      ..value = 0.0
      ..fling(velocity: velocity);
  }

  void animationScale(double begin, double end, double velocity) {
    if (_scaleController == null) {
      return;
    }
    _scaleAnimation =
        _scaleController.drive(Tween<double>(begin: begin, end: end));
    _scaleController
      ..value = 0.0
      ..fling(velocity: velocity);
  }

  void dispose() {
    _offsetController?.dispose();
    _offsetController = null;

    _scaleController?.dispose();
    _scaleController = null;
  }

  void stop() {
    _offsetController?.stop();
    _scaleController?.stop();
  }
}
