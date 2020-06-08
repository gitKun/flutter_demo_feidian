import 'package:flutter/material.dart';
import 'package:pagetext/pages/photo_view/dr_photo_slide_page_handle.dart';
import './dr_photo_gestured_image.dart';
import './dr_photo_browser_utils.dart';
import './dr_photo_browser_typedef.dart';

class DRPhotoSlidePage extends StatefulWidget {
  const DRPhotoSlidePage({
    this.child,
    this.slidePageBackgroundHandler,
    this.slideScaleHandler,
    this.slideOffsetHandler,
    this.slideEndHandler,
    this.slideAxis = DRSlideAxis.both,
    this.resetPageDuration = const Duration(milliseconds: 500),
    this.slideType = DRSlideType.onlyImage,
    this.onSlidingPage,
    Key key,
  }) : super(key: key);

  ///The [child] contained by the DRPhotoGesturedImage.
  final Widget child;

  ///builder background when slide page
  final SlidePageBackgroundHandler slidePageBackgroundHandler;

  ///customize scale of page when slide page
  final SlideScaleHandler slideScaleHandler;

  ///customize offset when slide page
  final SlideOffsetHandler slideOffsetHandler;

  ///call back of slide end
  ///decide whether pop page
  final SlideEndHandler slideEndHandler;

  ///axis of slide
  ///both,horizontal,vertical
  final DRSlideAxis slideAxis;

  ///reset page position when slide end(not pop page)
  final Duration resetPageDuration;

  /// slide whole page or only image
  final DRSlideType slideType;

  /// on sliding page
  final OnSlidingPage onSlidingPage;

  @override
  DRPhotoSlidePageState createState() => DRPhotoSlidePageState();
}

class DRPhotoSlidePageState extends State<DRPhotoSlidePage>
    with SingleTickerProviderStateMixin {
  bool _isSliding = false;

  ///whether is sliding page
  bool get isSliding => _isSliding;

  Size _pageSize;
  Size get pageSize => _pageSize ?? context.size;

  AnimationController _backAnimationController;
  AnimationController get backAnimationController => _backAnimationController;
  Animation<Offset> _backOffsetAnimation;
  Animation<Offset> get backOffsetAnimation => _backOffsetAnimation;
  Animation<double> _backScaleAnimation;
  Animation<double> get backScaleAnimation => _backScaleAnimation;
  Offset _offset = Offset.zero;
  Offset get offset => _backAnimationController.isAnimating
      ? _backOffsetAnimation.value
      : _offset;
  double _scale = 1.0;
  double get scale =>
      _backAnimationController.isAnimating ? backScaleAnimation.value : _scale;
  bool _popping = false;

  @override
  void initState() {
    super.initState();
    _backAnimationController =
        AnimationController(vsync: this, duration: widget.resetPageDuration);
    _backAnimationController.addListener(_backAnimation);
  }

  @override
  void didUpdateWidget(DRPhotoSlidePage oldWidget) {
    if (oldWidget.resetPageDuration != widget.resetPageDuration) {
      _backAnimationController.stop();
      _backAnimationController.dispose();
      _backAnimationController =
          AnimationController(vsync: this, duration: widget.resetPageDuration);
    }
    super.didUpdateWidget(oldWidget);
  }

  DRPhotoGesturedImageState _gesturedImageState;
  DRPhotoGesturedImageState get imageGestureState => _gesturedImageState;
  DRPhotoSlidePageHandlerState _sliderPageHandlerState;

  void _backAnimation() {
    if (mounted) {
      setState(() {
        if (_backAnimationController.isCompleted) {
          _isSliding = false;
        }
      });
    }
    if (widget.slideType == DRSlideType.onlyImage) {
      _gesturedImageState?.slide();
      _sliderPageHandlerState?.slide();
    }
    widget.onSlidingPage?.call(this);
  }

  @override
  void dispose() {
    super.dispose();
    _backAnimationController.removeListener(_backAnimation);
    _backAnimationController.dispose();
  }

  void slide(Offset value,
      {DRPhotoGesturedImageState gesturedImageState,
      DRPhotoSlidePageHandlerState slidePageHandlerState}) {
    if (_backAnimationController.isAnimating) {
      return;
    }
    _gesturedImageState = gesturedImageState;
    _sliderPageHandlerState = slidePageHandlerState;
    _offset += value;
    if (widget.slideAxis == DRSlideAxis.horizontal) {
      _offset += Offset(value.dx, 0.0);
    } else if (widget.slideAxis == DRSlideAxis.vertical) {
      _offset += Offset(0.0, value.dy);
    }
    _offset = widget.slideOffsetHandler?.call(
          _offset,
          state: this,
        ) ??
        _offset;

    _scale = widget.slideScaleHandler?.call(
          _offset,
          state: this,
        ) ??
        defaultSlideScaleHandler(
            offset: _offset,
            pageSize: pageSize,
            pageGestureAxis: widget.slideAxis);

    //if (_scale != 1.0 || _offset != Offset.zero)
    {
      _isSliding = true;
      if (widget.slideType == DRSlideType.onlyImage) {
        _gesturedImageState?.slide();
        _sliderPageHandlerState?.slide();
      }

      if (mounted) {
        setState(() {});
      }
      widget.onSlidingPage?.call(this);
    }
  }

  void endSlide(ScaleEndDetails details) {
    if (mounted && _isSliding) {
      final bool popPage = widget.slideEndHandler?.call(
            _offset,
            state: this,
            details: details,
          ) ??
          defaultSlideEndHandler(
              offset: _offset,
              pageSize: _pageSize,
              pageGestureAxis: widget.slideAxis);

      if (popPage) {
        setState(() {
          _popping = true;
          _isSliding = false;
        });
        Navigator.pop(context);
      } else {
        //_isSliding=false;
        if (_offset != Offset.zero || _scale != 1.0) {
          _backOffsetAnimation = _backAnimationController
              .drive(Tween<Offset>(begin: _offset, end: Offset.zero));
          _backScaleAnimation = _backAnimationController
              .drive(Tween<double>(begin: _scale, end: 1.0));
          _offset = Offset.zero;
          _scale = 1.0;
          _backAnimationController.reset();
          _backAnimationController.forward();
        } else {
          setState(() {
            _isSliding = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _pageSize = MediaQuery.of(context).size;
    final Color pageColor =
        widget.slidePageBackgroundHandler?.call(offset, pageSize) ??
            defaultSlidePageBackgroundHandler(
                offset: offset,
                pageSize: pageSize,
                color: Theme.of(context).dialogBackgroundColor,
                pageGestureAxis: widget.slideAxis);

    Widget result = widget.child;
    if (widget.slideType == DRSlideType.wholePage) {
      result = Transform.translate(
        offset: offset,
        child: Transform.scale(
          scale: scale,
          child: result,
        ),
      );
    }

    result = Container(
      color: _popping ? Colors.transparent : pageColor,
      child: result,
    );

//    result = IgnorePointer(
//      ignoring: _isSliding,
//      child: result,
//    );

    return result;
  }

  void popPage() {
    setState(() {
      _popping = true;
    });
  }
}
