import 'dart:math';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:pagetext/model/pic_info_item.dart';

class PicWrapped extends StatefulWidget {
  const PicWrapped({
    this.index,
    this.pics,
  });

  final int index;
  final List<PicInfoItem> pics;

  @override
  _PicWrappedState createState() => _PicWrappedState();
}

typedef DoubleClickAnimationListener = void Function();

class _PicWrappedState extends State<PicWrapped> with TickerProviderStateMixin {
  GlobalKey<ExtendedImageSlidePageState> slidePagekey =
      GlobalKey<ExtendedImageSlidePageState>();
  List<double> doubleTapScales = <double>[1.0, 2.0];
  Animation<double> _doubleClickAnimation;
  AnimationController _doubleClickAnimationController;
  DoubleClickAnimationListener _doubleClickAnimationListener;
  Rect imageDRect;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.index;
    _doubleClickAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _doubleClickAnimationController.dispose();
    clearGestureDetailsCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    imageDRect = Offset.zero & size;
    Widget result = Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ExtendedImageGesturePageView.builder(
            controller: PageController(
              initialPage: widget.index,
            ),
            itemBuilder: (BuildContext context, int index) {
              final String item = widget.pics[index].picUrl;
              final String heroID = widget.pics[index].heroID;
              Widget image = ExtendedImage.asset(
                item,
                fit: BoxFit.contain,
                enableSlideOutPage: true,
                mode: ExtendedImageMode.gesture,
                // hero 动画？
                heroBuilderForSlidingPage: (Widget result) {
                  if (index < min(9, widget.pics.length)) {
                    return Hero(
                      tag: heroID,
                      child: result,
                      flightShuttleBuilder: (BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext) {
                        final Hero hero =
                            (flightDirection == HeroFlightDirection.pop
                                ? fromHeroContext.widget
                                : toHeroContext.widget) as Hero;
                        return hero;
                      },
                    );
                  } else {
                    return result;
                  }
                },
                initGestureConfigHandler: (ExtendedImageState state) {
                  double initialScale = 1.0;
                  // if (state.extendedImageInfo != null &&
                  //     state.extendedImageInfo.image != null) {
                  //   initialScale = initScale(
                  //     size: size,
                  //     initialScale: initialScale,
                  //     imageSize: Size(
                  //       state.extendedImageInfo.image.width.toDouble(),
                  //       state.extendedImageInfo.image.height.toDouble(),
                  //     ),
                  //   );
                  //   print('iniitialScale = $initialScale');
                  // }
                  return GestureConfig(
                    inPageView: true,
                    initialScale: initialScale,
                    maxScale: max(initialScale, 3),
                    animationMaxScale: max(initialScale, 3),
                    initialAlignment: InitialAlignment.center,
                    cacheGesture: false,
                  );
                },
                // 双击放大或缩小
                onDoubleTap: (ExtendedImageGestureState state) {
                  final Offset pointerDownPosition = state.pointerDownPosition;
                  final double begin = state.gestureDetails.totalScale;
                  double end;
                  // 判断
                  if (_doubleClickAnimationController.isAnimating) {
                    return null;
                  }
                  // 移旧
                  _doubleClickAnimation
                      ?.removeListener(_doubleClickAnimationListener);
                  // 停前
                  _doubleClickAnimationController.stop();
                  // 从头
                  _doubleClickAnimationController.reset();
                  if (begin == doubleTapScales[0]) {
                    end = doubleTapScales[1];
                  } else {
                    end = doubleTapScales[0];
                  }
                  _doubleClickAnimationListener = () {
                    state.handleDoubleTap(
                      scale: _doubleClickAnimation.value,
                      doubleTapPosition: pointerDownPosition,
                    );
                  };
                  _doubleClickAnimation =
                      _doubleClickAnimationController.drive(Tween<double>(
                    begin: begin,
                    end: end,
                  ));
                  _doubleClickAnimation
                      .addListener(_doubleClickAnimationListener);
                  _doubleClickAnimationController.forward();
                },
              );
              // 给 image 添加手势
              image = GestureDetector(
                child: image,
                onTap: () {
                  slidePagekey.currentState.popPage();
                  Navigator.pop(context);
                },
                onLongPress: () {
                  print('长按应该弹出保存菜单！');
                },
              );
              return image;
            },
            itemCount: widget.pics.length,
            // image index 改变
            onPageChanged: (int index) {
              _currentIndex = index;
            },
            // 滚动方向
            scrollDirection: Axis.horizontal,
            // 设置回弹
            physics: const BouncingScrollPhysics(),
          ),
        ],
      ),
    );

    result = ExtendedImageSlidePage(
      key: slidePagekey,
      child: result,
      // slidePageBackgroundHandler: (Offset offset, Size size) {
      //   double opacity = 0.0;
      //   opacity =
      //       offset.distance / (Offset(size.width, size.height).distance / 2.0);
      //   return Colors.black.withOpacity(1 - opacity);
      // },
      // 允许 上下左右拖动
      slideAxis: SlideAxis.both,
      // 仅拖动 image
      slideType: SlideType.onlyImage,
      //
      slideScaleHandler: (Offset offset, {ExtendedImageSlidePageState state}) {
        return null;
      },
    );
    return result;
  }
}
