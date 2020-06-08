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
      duration: const Duration(milliseconds: 1000),
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
      child: ExtendedImageGesturePageView(
        controller: PageController(
          initialPage: widget.index,
        ),
        children: widget.pics.map((picInfo) {
          final String item = picInfo.picUrl;
          final String heroID = picInfo.heroID;
          Widget image = ExtendedImage.network(
            item,
            enableLoadState: true,
            scale: 1.0,
            fit: BoxFit.contain,
            enableSlideOutPage: true,
            mode: ExtendedImageMode.gesture,
            heroBuilderForSlidingPage: (result) {
              return Hero(
                tag: heroID,
                child: result,
                flightShuttleBuilder: (BuildContext flightContext,
                    Animation<double> animation,
                    HeroFlightDirection flightDirection,
                    BuildContext fromHeroContext,
                    BuildContext toHeroContext) {
                  final Hero hero = (flightDirection == HeroFlightDirection.pop
                      ? fromHeroContext.widget
                      : toHeroContext.widget) as Hero;
                  return hero.child;
                },
              );
            },
            loadStateChanged: (ExtendedImageState state) {
              if (state.extendedImageLoadState == LoadState.completed) {
                print('init gesture image! ____#');
                return ExtendedImageGesture(
                  state,
                  canScaleImage: (_) => true,
                  // imageBuilder: (Widget image) {
                  //   return image;
                  // },
                );
              }
              print('loadStateChanged return NULL!');
              return null;
            },
          );
          // 给 image 添加手势
          image = GestureDetector(
            child: image,
            onTap: () {
              if (_doubleClickAnimation != null &&
                  (_doubleClickAnimation.value > doubleTapScales[0] &&
                      _doubleClickAnimation.value < doubleTapScales[1])) {
                return;
              } else {
                slidePagekey.currentState?.popPage();
                Navigator.pop(context);
              }
            },
            onLongPress: () {
              print('长按应该弹出保存菜单！');
            },
          );

          return image;
        }).toList(),
      ),
    );

    result = ExtendedImageSlidePage(
      key: slidePagekey,
      child: result,
      slidePageBackgroundHandler: (Offset offset, Size size) {
        double opacity = 0.0;
        opacity =
            offset.distance / (Offset(size.width, size.height).distance / 2.0);
        return Colors.black.withOpacity(1 - opacity);
      },
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
