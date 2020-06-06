import 'package:flutter/cupertino.dart';

class PicInfoItem {
  PicInfoItem({
    @required this.picUrl,
    @required this.heroID,
    this.des = '',
  });
  final String heroID;
  final String picUrl;
  final String des;
}
