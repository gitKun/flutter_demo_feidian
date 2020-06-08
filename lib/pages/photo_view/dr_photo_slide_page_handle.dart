import 'package:flutter/material.dart';
import './dr_photo_slide_page.dart';
import './dr_gesture_animation.dart';
import './dr_photo_browser_typedef.dart';
import './dr_photo_browser_utils.dart';

class DRPhotoSlidePageHandler extends StatefulWidget {
  const DRPhotoSlidePageHandler(this.child, this.slidePageState);
  final Widget child;
  final DRPhotoSlidePageState slidePageState;
  @override
  DRPhotoSlidePageHandlerState createState() => DRPhotoSlidePageHandlerState();
}

class DRPhotoSlidePageHandlerState extends State<DRPhotoSlidePageHandler> {
  Offset _startingOffset;
  @override
  Widget build(BuildContext context) {
    Widget result = GestureDetector(
      onScaleStart: _handleScaleStart,
      onScaleUpdate: _handleScaleUpdate,
      onScaleEnd: _handleScaleEnd,
      child: widget.child,
      behavior: HitTestBehavior.translucent,
    );

    if (widget.slidePageState != null &&
        widget.slidePageState.widget.slideType == DRSlideType.onlyImage) {
      final DRPhotoSlidePageState slidePageState = widget.slidePageState;
      result = Transform.translate(
        offset: slidePageState.offset,
        child: Transform.scale(
          scale: slidePageState.scale,
          child: result,
        ),
      );
    }
    return result;
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _startingOffset = details.focalPoint;
  }

  Offset _updateSlidePagePreOffset;
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    ///whether gesture page
    if (widget.slidePageState != null && details.scale == 1.0) {
      //var offsetDelta = (details.focalPoint - _startingOffset);

      final double delta = (details.focalPoint - _startingOffset).distance;

      if (doubleCompare(delta, minGesturePageDelta) > 0) {
        _updateSlidePagePreOffset ??= details.focalPoint;
        widget.slidePageState.slide(
          details.focalPoint - _updateSlidePagePreOffset,
          slidePageHandlerState: this,
        );
        _updateSlidePagePreOffset = details.focalPoint;
      }
    }
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    if (widget.slidePageState != null && widget.slidePageState.isSliding) {
      _updateSlidePagePreOffset = null;
      widget.slidePageState.endSlide(details);
      return;
    }
  }

  void slide() {
    if (mounted) {
      setState(() {});
    }
  }
}
