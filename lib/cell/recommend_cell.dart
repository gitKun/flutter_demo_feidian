import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:fbutton/fbutton.dart';
import 'package:flutter/material.dart';
import 'package:pagetext/model/pic_info_item.dart';
import 'package:pagetext/model/recommend_local.dart';
import 'package:pagetext/pages/pic_wrapped.dart';
import 'package:pagetext/routers/ct_material_page_route.dart';

class RecommendCell extends StatefulWidget {
  final UserActivity model;
  RecommendCell({Key key, this.model})
      : assert(model != null),
        super(key: key);
  @override
  _RecommendCellState createState() => _RecommendCellState();
}

class _RecommendCellState extends State<RecommendCell> {
  UserActivity model;

  @override
  void initState() {
    super.initState();
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFEEF1F5),
      padding: EdgeInsets.only(top: 10),
      child: Container(
        color: Color(0xFFFFFFFF),
        padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _headerInfo(),
            _contentContaine(),
            _imagesContainer(),
            _topicContainer(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Divider(
                color: Color(0xFFEEF1F5),
                height: 1,
              ),
            ),
            _bottonButtonsContainer(),
          ],
        ),
      ),
    );
  }

  // Mark: UI

  Widget _headerInfo() {
    return GestureDetector(
      onTap: _userInfoAction,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'images/${model.avatarLarge}',
            fit: BoxFit.cover,
            width: 38,
            height: 38,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF2E3135),
                    ),
                  ),
                  Text(
                    _userInfo(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A9AA9),
                    ),
                  ),
                ],
              ),
            ),
          ),
          FButton(
            padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
            fontSize: 14,
            text: '+ 关注',
            textColor: Color(0xFF6CBD45),
            color: Colors.transparent,
            corner: FButtonCorner.all(4),
            cornerStyle: FButtonCornerStyle.round,
            strokeWidth: 1,
            strokeColor: Color(0xFF6CBD45),
            onPressed: _flowAction,
          ),
          SizedBox(
            width: 32,
            child: FlatButton(
              padding: EdgeInsets.all(0),
              child: Icon(
                Icons.more_horiz,
                color: Color(0xFF909EAD),
              ),
              onPressed: _moreAction,
            ),
          ),
        ],
      ),
    );
  }

  String _userInfo() {
    String result = model.jobTitle;
    if (model.company != null && model.company.length > 1) {
      result += ' @ ' + model.company;
    }
    if (result.length > 1) {
      result += ' • ' + model.createdAt.substring(5, 10);
    } else {
      result = model.createdAt.substring(5, 10);
    }
    return result;
  }

  Widget _contentContaine() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        model.content,
        textAlign: TextAlign.left,
        style: TextStyle(
          letterSpacing: 0.5,
          color: Color(0xFF17181A),
          height: 1,
          fontSize: 16,
        ),
        strutStyle: StrutStyle(
          fontSize: 19,
        ),
      ),
    );
  }

  Widget _imagesContainer() {
    int picCount = model.pictures.length;
    if (picCount == 0) {
      return SizedBox();
    }
    if (picCount == 1) {
      String name = model.pictures[0].loaclName;
      double width = model.pictures[0].width * 1.0;
      double height = model.pictures[0].heihgt * 1.0;
      double radio = width / height;
      if (radio > 1) {
        width = min(215, width);
        height = width / radio;
      } else {
        height = min(215, height);
        width = height * radio;
      }
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: GestureDetector(
          onTap: () {
            _imageAction(index: 0, contex: context);
          },
          child: Hero(
            tag: name,
            child: Image.asset(
              'images/act_$name',
              width: width,
              height: height,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 8),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: picCount,
          itemBuilder: (context, index) {
            String name = model.pictures[index].loaclName;
            return GestureDetector(
              onTap: () {
                _imageAction(index: index);
              },
              child: Hero(
                tag: name,
                child: Image.asset(
                  'images/act_$name',
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      );
    }
  }

  Widget _topicContainer() {
    if (!model.hasTopic) {
      return SizedBox();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: FButton(
            padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
            fontSize: 13,
            text: model.topicTitle,
            textColor: Color(0xFF007FFF),
            color: Colors.transparent,
            corner: FButtonCorner.all(16),
            cornerStyle: FButtonCornerStyle.round,
            strokeWidth: 1,
            strokeColor: Color(0xFF007FFF),
            onPressed: _topicAction,
          ),
        ),
      ],
    );
  }

  Widget _bottonButtonsContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 7,
      ),
      child: SizedBox(
        height: 26,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: _bottomButtonsList(),
        ),
      ),
    );
  }

  List<Widget> _bottomButtonsList() {
    return [
      _bottomButton(
        content: model.likeCount > 0 ? '${model.likeCount}' : '赞',
      ),
      _bottomButton(
        imageName: 'images/icons/comment_15.png',
        content: model.commentCount > 0 ? '${model.commentCount}' : '评论',
        action: _commentAction,
      ),
      _bottomButton(
        imageName: 'images/icons/share_15.png',
        content: '分享',
        action: _shareAction,
      ),
    ];
  }

  Widget _bottomButton({
    String imageName,
    String content,
    VoidCallback action,
  }) {
    if (content == null) {
      content = '赞';
    }
    if (imageName == null) {
      imageName = 'images/icons/zan_15.png';
    }
    if (action == null) {
      action = _zanAction;
    }
    return FButton(
      padding: EdgeInsets.all(0),
      text: content,
      fontSize: 15,
      textColor: Color(0xFF969696),
      color: Colors.transparent,
      onPressed: action,
      clickEffect: false,
      image: Image.asset(
        imageName,
        width: 15,
        height: 15,
      ),
      imageMargin: 3,
    );
  }

  void _zanAction() {
    print('👍被点击！');
  }

  void _commentAction() {
    print('评论被点击！');
  }

  void _shareAction() {
    print('分享被点击！');
  }

  void _topicAction() {
    print('话题按钮被点击！');
  }

  void _flowAction() {
    print('关注按钮被点击！');
  }

  void _moreAction() {
    print('更多操作被点击!');
  }

  void _userInfoAction() {
    // TODO: 跳转到作者详情页！
    print('跳转到作者详情页！');
  }

  void _imageAction({int index = 0, BuildContext contex}) {
    print('image selected at $index');
    List<PicInfoItem> items = model.pictures.map((Pictures e) {
      return PicInfoItem(
        picUrl: 'images/act_${e.loaclName}',
        heroID: e.loaclName,
      );
    }).toList();

    // final TargetPlatform platform = Theme.of(context).platform;
    // Navigator.push(
    //   context,
    //   platform == TargetPlatform.iOS
    //       ? TransparentCupertinoPageRoute<void>(builder: (context) {
    //           return PicWrapped(
    //             index: index,
    //             pics: items,
    //           );
    //         })
    //       : TransparentMaterialPageRoute<void>(builder: (context) {
    //           return PicWrapped(
    //             index: index,
    //             pics: items,
    //           );
    //         }),
    // );

    Navigator.push(
      context,
      CTMaterialPageRoute(
        transion: (child, animation) {
          return Align(
            alignment: Alignment.center,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        builder: (context) {
          return PicWrapped(
            index: index,
            pics: items,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }
}
