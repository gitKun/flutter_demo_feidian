import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class TestAssiceImagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget result = Center(
      child: Container(
        color: Colors.red[100],
        width: 300,
        height: 300,
        child: ExtendedImage.asset(
          'images/act_activity_pin_5.png',
          heroBuilderForSlidingPage: (result) {
            print('简历Hero动画!');
            return Hero(
              tag: 'HeroID',
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
        ),
      ),
    );
    result = GestureDetector(
      child: result,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
    result = Hero(
      tag: 'HeroID',
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
    return result;
  }
}
