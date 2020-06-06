import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class LocalRecommend {
  LocalRecommend({
    this.data,
  });

  factory LocalRecommend.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Data> data = jsonRes['data'] is List ? <Data>[] : null;
    if (data != null) {
      for (final dynamic item in jsonRes['data']) {
        if (item != null) {
          data.add(Data.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return LocalRecommend(
      data: data,
    );
  }

  List<Data> data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Data {
  Data({
    this.userActivity,
  });

  factory Data.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Data(
          userActivity: UserActivity.fromJson(
              asT<Map<String, dynamic>>(jsonRes['userActivity'])),
        );

  UserActivity userActivity;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'userActivity': userActivity,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class UserActivity {
  UserActivity({
    this.id,
    this.pins,
  });

  factory UserActivity.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Pins> pins = jsonRes['pins'] is List ? <Pins>[] : null;
    if (pins != null) {
      for (final dynamic item in jsonRes['pins']) {
        if (item != null) {
          pins.add(Pins.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return UserActivity(
      id: asT<String>(jsonRes['id']),
      pins: pins,
    );
  }

  String id;
  List<Pins> pins;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'pins': pins,
      };
  @override
  String toString() {
    return json.encode(this);
  }

  // MARK: getters

  Pins get firstPin => pins.first;
  // 用户所发送id
  String get activityID => id;
  // pin id
  String get pinID => firstPin.id;
  // 沸点内容
  String get content => firstPin.content;
  // 图片
  List<Pictures> get pictures => firstPin.pictures;
  // 点赞数
  int get likeCount => firstPin.likeCount;
  // 创建时间
  String get createdAt => firstPin.createdAt;
  // 评论数
  int get commentCount => firstPin.commentCount;
  // 是否点赞
  bool get viewerHasLiked => firstPin.viewerHasLiked;
  // 是否标记为话题(eg:#树洞一下, #代码秀)
  bool get hasTopic => firstPin.topic != null;
  // 话题的 id
  String get topicID => firstPin.topic.id;
  // 话题的名称
  String get topicTitle => firstPin.topic.title;
  // 作者id
  String get usreId => firstPin.user.id;
  // 作者姓名
  String get username => firstPin.user.username;
  // 作者的自我描述
  String get selfDescription => firstPin.user.selfDescription != null
      ? firstPin.user.selfDescription
      : '';
  // 作者的头像链接
  String get avatarLarge => firstPin.user.avatarLarge;
  // 作者的工作
  String get jobTitle =>
      firstPin.user.jobTitle != null ? firstPin.user.jobTitle : '';
  // 作者的公司
  String get company =>
      firstPin.user.company != null ? firstPin.user.company : '';
  // 是否正在关注作者
  bool get viewerIsFollowing => firstPin.user.viewerIsFollowing;
}

class Pins {
  Pins({
    this.id,
    this.content,
    this.pictures,
    this.likeCount,
    this.createdAt,
    this.commentCount,
    this.viewerHasLiked,
    this.topic,
    this.user,
  });

  factory Pins.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Pictures> pictures =
        jsonRes['pictures'] is List ? <Pictures>[] : null;
    if (pictures != null) {
      for (final dynamic item in jsonRes['pictures']) {
        if (item != null) {
          pictures.add(Pictures.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return Pins(
      id: asT<String>(jsonRes['id']),
      content: asT<String>(jsonRes['content']),
      pictures: pictures,
      likeCount: asT<int>(jsonRes['likeCount']),
      createdAt: asT<String>(jsonRes['createdAt']),
      commentCount: asT<int>(jsonRes['commentCount']),
      viewerHasLiked: asT<bool>(jsonRes['viewerHasLiked']),
      topic: Topic.fromJson(asT<Map<String, dynamic>>(jsonRes['topic'])),
      user: User.fromJson(asT<Map<String, dynamic>>(jsonRes['user'])),
    );
  }

  String id;
  String content;
  List<Pictures> pictures;
  int likeCount;
  String createdAt;
  int commentCount;
  bool viewerHasLiked;
  Topic topic;
  User user;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'content': content,
        'pictures': pictures,
        'likeCount': likeCount,
        'createdAt': createdAt,
        'commentCount': commentCount,
        'viewerHasLiked': viewerHasLiked,
        'topic': topic,
        'user': user,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Topic {
  Topic({
    this.id,
    this.title,
  });

  factory Topic.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Topic(
          id: asT<String>(jsonRes['id']),
          title: asT<String>(jsonRes['title']),
        );

  String id;
  String title;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class User {
  User({
    this.id,
    this.username,
    this.selfDescription,
    this.avatarLarge,
    this.jobTitle,
    this.company,
    this.viewerIsFollowing,
    this.level,
    this.juejinPower,
  });

  factory User.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : User(
          id: asT<String>(jsonRes['id']),
          username: asT<String>(jsonRes['username']),
          selfDescription: asT<Object>(jsonRes['selfDescription']),
          avatarLarge: asT<String>(jsonRes['avatarLarge']),
          jobTitle: asT<String>(jsonRes['jobTitle']),
          company: asT<String>(jsonRes['company']),
          viewerIsFollowing: asT<bool>(jsonRes['viewerIsFollowing']),
          level: asT<int>(jsonRes['level']),
          juejinPower: asT<int>(jsonRes['juejinPower']),
        );

  String id;
  String username;
  Object selfDescription;
  String avatarLarge;
  String jobTitle;
  String company;
  bool viewerIsFollowing;
  int level;
  int juejinPower;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'selfDescription': selfDescription,
        'avatarLarge': avatarLarge,
        'jobTitle': jobTitle,
        'company': company,
        'viewerIsFollowing': viewerIsFollowing,
        'level': level,
        'juejinPower': juejinPower,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Pictures {
  Pictures({
    this.width,
    this.heihgt,
    this.loaclName,
  });

  factory Pictures.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Pictures(
          width: asT<int>(jsonRes['width']),
          heihgt: asT<int>(jsonRes['heihgt']),
          loaclName: asT<String>(jsonRes['loaclName']),
        );

  int width;
  int heihgt;
  String loaclName;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'width': width,
        'heihgt': heihgt,
        'loaclName': loaclName,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
