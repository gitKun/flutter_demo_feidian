// import 'dart:math';

// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:pagetext/model/pic_info_item.dart';
// import 'package:pagetext/pages/photo_view/dr_photo_slide_page.dart';
// import './photo_view/dr_photo_gesture_page.dart';
// import './photo_view/dr_photo_gestured_image.dart';
// import 'photo_view/dr_gesture_config.dart';
// import 'photo_view/dr_photo_browser_typedef.dart';

// class HeroDetailPage extends StatefulWidget {
//   const HeroDetailPage({
//     @required this.infoItems,
//     this.index,
//   });

//   final List<PicInfoItem> infoItems;
//   final int index;
//   @override
//   _HeroDetailPageState createState() => _HeroDetailPageState();
// }

// typedef DoubleClickAnimationListener = void Function();

// class _HeroDetailPageState extends State<HeroDetailPage>
//     with TickerProviderStateMixin {
//   /// State

//   Animation<double> _doubleClickAnimation;
//   AnimationController _doubleClickAnimationController;
//   DoubleClickAnimationListener _doubleClickAnimationListener;
//   List<double> doubleTapScales = <double>[1.0, 2.0];
//   GlobalKey<DRPhotoSlidePageState> slidePagekey =
//       GlobalKey<DRPhotoSlidePageState>();
//   @override
//   void initState() {
//     super.initState();
//     _doubleClickAnimationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     );
//   }

//   @override
//   void dispose() {
//     _doubleClickAnimationController.dispose();
//     clearGestureDetailsCache();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     Widget result = Scaffold(
//       // appBar: AppBar(
//       //   title: Text('Detail'),
//       // ),
//       backgroundColor: Colors.transparent,

//       body: DRPhotoGesturePageView.build(
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(),
//         itemCount: widget.infoItems.length,
//         controller: PageController(
//           initialPage: widget.index,
//         ),
//         itemBuilder: (BuildContext context, int index) {
//           PicInfoItem item = widget.infoItems[index];
//           Widget result = GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: DRPhotoGesturedImage(
//               imageBuilder: (Widget result) {
//                 print('创建image!');
//                 return Image.asset(
//                   item.picUrl,
//                   width: size.width,
//                   height: size.height,
//                   fit: BoxFit.contain,
//                 );
//               },
//               initGestureConfigHandler: () {
//                 double initialScale = 1.0;
//                 return DRGestureConfig(
//                     inPageView: true,
//                     initialScale: initialScale,
//                     maxScale: max(initialScale, 3.0),
//                     animationMaxScale: max(initialScale, 3.0),
//                     initialAlignment: DRInitialAlignment.center,
//                     cacheGesture: false);
//               },
//               onDoubleTap: (DRPhotoGesturedImageState state) {
//                 ///you can use define pointerDownPosition as you can,
//                 ///default value is double tap pointer down postion.
//                 final Offset pointerDownPosition = state.pointerDownPosition;
//                 final double begin = state.gestureDetails.totalScale;
//                 double end;

//                 //remove old
//                 _doubleClickAnimation
//                     ?.removeListener(_doubleClickAnimationListener);

//                 //stop pre
//                 _doubleClickAnimationController.stop();

//                 //reset to use
//                 _doubleClickAnimationController.reset();

//                 if (begin == doubleTapScales[0]) {
//                   end = doubleTapScales[1];
//                 } else {
//                   end = doubleTapScales[0];
//                 }

//                 _doubleClickAnimationListener = () {
//                   //print(_animation.value);
//                   state.handleDoubleTap(
//                       scale: _doubleClickAnimation.value,
//                       doubleTapPosition: pointerDownPosition);
//                 };
//                 _doubleClickAnimation = _doubleClickAnimationController
//                     .drive(Tween<double>(begin: begin, end: end));

//                 _doubleClickAnimation
//                     .addListener(_doubleClickAnimationListener);

//                 _doubleClickAnimationController.forward();
//               },
//             ),
//           );
//           return Hero(
//             tag: item.heroID,
//             child: result,
//             flightShuttleBuilder: (BuildContext flightContext,
//                 Animation<double> animation,
//                 HeroFlightDirection flightDirection,
//                 BuildContext fromHeroContext,
//                 BuildContext toHeroContext) {
//               final Hero hero = (flightDirection == HeroFlightDirection.pop
//                   ? fromHeroContext.widget
//                   : toHeroContext.widget) as Hero;
//               return hero.child;
//             },
//           );
//         },
//       ),
//     );

//     result = DRPhotoSlidePage(
//       key: slidePagekey,
//       child: result,
//       slideAxis: DRSlideAxis.both,
//       slideType: DRSlideType.onlyImage,
//     );

//     return result;
//   }
// }
