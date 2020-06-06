import 'dart:convert' show json;

T asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }

  return null;
}

class Root {
  Root({
    this.data,
  });

  factory Root.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Root(
          data:
              WrappedData.fromJson(asT<Map<String, dynamic>>(jsonRes['data'])),
        );

  WrappedData data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'data': data,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class WrappedData {
  WrappedData({
    this.recommendedActivityFeed,
  });

  factory WrappedData.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : WrappedData(
          recommendedActivityFeed: RecommendedActivityFeed.fromJson(
              asT<Map<String, dynamic>>(jsonRes['recommendedActivityFeed'])),
        );

  RecommendedActivityFeed recommendedActivityFeed;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'recommendedActivityFeed': recommendedActivityFeed,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class RecommendedActivityFeed {
  RecommendedActivityFeed({
    this.newItemCount,
    this.items,
  });

  factory RecommendedActivityFeed.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : RecommendedActivityFeed(
              newItemCount: asT<int>(jsonRes['newItemCount']),
              items:
                  Items.fromJson(asT<Map<String, dynamic>>(jsonRes['items'])),
            );

  int newItemCount;
  Items items;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'newItemCount': newItemCount,
        'items': items,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Items {
  Items({
    this.pageInfo,
    this.positionInfo,
    this.userActivities,
  });

  factory Items.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<UserActivities> userActivities =
        jsonRes['userActivities'] is List ? <UserActivities>[] : null;
    if (userActivities != null) {
      for (final dynamic item in jsonRes['userActivities']) {
        if (item != null) {
          userActivities
              .add(UserActivities.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return Items(
      pageInfo:
          PageInfo.fromJson(asT<Map<String, dynamic>>(jsonRes['pageInfo'])),
      positionInfo: PositionInfo.fromJson(
          asT<Map<String, dynamic>>(jsonRes['positionInfo'])),
      userActivities: userActivities,
    );
  }

  PageInfo pageInfo;
  PositionInfo positionInfo;
  List<UserActivities> userActivities;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'pageInfo': pageInfo,
        'positionInfo': positionInfo,
        'userActivities': userActivities,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class PageInfo {
  PageInfo({
    this.hasNextPage,
    this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  factory PageInfo.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : PageInfo(
          hasNextPage: asT<bool>(jsonRes['hasNextPage']),
          hasPreviousPage: asT<bool>(jsonRes['hasPreviousPage']),
          startCursor: asT<Object>(jsonRes['startCursor']),
          endCursor: asT<String>(jsonRes['endCursor']),
        );

  bool hasNextPage;
  bool hasPreviousPage;
  Object startCursor;
  String endCursor;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'hasNextPage': hasNextPage,
        'hasPreviousPage': hasPreviousPage,
        'startCursor': startCursor,
        'endCursor': endCursor,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class PositionInfo {
  PositionInfo({
    this.maxPosition,
    this.minPosition,
  });

  factory PositionInfo.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : PositionInfo(
          maxPosition: asT<String>(jsonRes['maxPosition']),
          minPosition: asT<String>(jsonRes['minPosition']),
        );

  String maxPosition;
  String minPosition;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'maxPosition': maxPosition,
        'minPosition': minPosition,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class UserActivities {
  UserActivities({
    this.userActivity,
  });

  factory UserActivities.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : UserActivities(
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
    this.action,
    this.users,
    this.entries,
    this.pins,
    this.tags,
    this.actors,
  });

  factory UserActivity.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Object> users = jsonRes['users'] is List ? <Object>[] : null;
    if (users != null) {
      for (final dynamic item in jsonRes['users']) {
        if (item != null) {
          users.add(asT<Object>(item));
        }
      }
    }

    final List<Object> entries = jsonRes['entries'] is List ? <Object>[] : null;
    if (entries != null) {
      for (final dynamic item in jsonRes['entries']) {
        if (item != null) {
          entries.add(asT<Object>(item));
        }
      }
    }

    final List<Pins> pins = jsonRes['pins'] is List ? <Pins>[] : null;
    if (pins != null) {
      for (final dynamic item in jsonRes['pins']) {
        if (item != null) {
          pins.add(Pins.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }

    final List<Object> tags = jsonRes['tags'] is List ? <Object>[] : null;
    if (tags != null) {
      for (final dynamic item in jsonRes['tags']) {
        if (item != null) {
          tags.add(asT<Object>(item));
        }
      }
    }

    final List<Actors> actors = jsonRes['actors'] is List ? <Actors>[] : null;
    if (actors != null) {
      for (final dynamic item in jsonRes['actors']) {
        if (item != null) {
          actors.add(Actors.fromJson(asT<Map<String, dynamic>>(item)));
        }
      }
    }
    return UserActivity(
      id: asT<String>(jsonRes['id']),
      action: asT<String>(jsonRes['action']),
      users: users,
      entries: entries,
      pins: pins,
      tags: tags,
      actors: actors,
    );
  }

  String id;
  String action;
  List<Object> users;
  List<Object> entries;
  List<Pins> pins;
  List<Object> tags;
  List<Actors> actors;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'action': action,
        'users': users,
        'entries': entries,
        'pins': pins,
        'tags': tags,
        'actors': actors,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Pins {
  Pins({
    this.id,
    this.content,
    this.pictures,
    this.url,
    this.urlPic,
    this.urlTitle,
    this.likeCount,
    this.createdAt,
    this.commentCount,
    this.viewerHasLiked,
    this.topic,
  });

  factory Pins.fromJson(Map<String, dynamic> jsonRes) {
    if (jsonRes == null) {
      return null;
    }

    final List<Object> pictures =
        jsonRes['pictures'] is List ? <Object>[] : null;
    if (pictures != null) {
      for (final dynamic item in jsonRes['pictures']) {
        if (item != null) {
          pictures.add(asT<Object>(item));
        }
      }
    }
    return Pins(
      id: asT<String>(jsonRes['id']),
      content: asT<String>(jsonRes['content']),
      pictures: pictures,
      url: asT<String>(jsonRes['url']),
      urlPic: asT<String>(jsonRes['urlPic']),
      urlTitle: asT<String>(jsonRes['urlTitle']),
      likeCount: asT<int>(jsonRes['likeCount']),
      createdAt: asT<String>(jsonRes['createdAt']),
      commentCount: asT<int>(jsonRes['commentCount']),
      viewerHasLiked: asT<bool>(jsonRes['viewerHasLiked']),
      topic: Topic.fromJson(asT<Map<String, dynamic>>(jsonRes['topic'])),
    );
  }

  String id;
  String content;
  List<Object> pictures;
  String url;
  String urlPic;
  String urlTitle;
  int likeCount;
  String createdAt;
  int commentCount;
  bool viewerHasLiked;
  Topic topic;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'content': content,
        'pictures': pictures,
        'url': url,
        'urlPic': urlPic,
        'urlTitle': urlTitle,
        'likeCount': likeCount,
        'createdAt': createdAt,
        'commentCount': commentCount,
        'viewerHasLiked': viewerHasLiked,
        'topic': topic,
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

class Actors {
  Actors({
    this.id,
    this.username,
    this.selfDescription,
    this.avatarLarge,
    this.jobTitle,
    this.company,
    this.viewerIsFollowing,
    this.level,
    this.juejinPower,
    this.roles,
  });

  factory Actors.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Actors(
          id: asT<String>(jsonRes['id']),
          username: asT<String>(jsonRes['username']),
          selfDescription: asT<String>(jsonRes['selfDescription']),
          avatarLarge: asT<String>(jsonRes['avatarLarge']),
          jobTitle: asT<String>(jsonRes['jobTitle']),
          company: asT<String>(jsonRes['company']),
          viewerIsFollowing: asT<bool>(jsonRes['viewerIsFollowing']),
          level: asT<int>(jsonRes['level']),
          juejinPower: asT<int>(jsonRes['juejinPower']),
          roles: Roles.fromJson(asT<Map<String, dynamic>>(jsonRes['roles'])),
        );

  String id;
  String username;
  String selfDescription;
  String avatarLarge;
  String jobTitle;
  String company;
  bool viewerIsFollowing;
  int level;
  int juejinPower;
  Roles roles;

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
        'roles': roles,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Roles {
  Roles({
    this.builder,
    this.favorableAuthor,
    this.bookAuthor,
  });

  factory Roles.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Roles(
          builder:
              Builder.fromJson(asT<Map<String, dynamic>>(jsonRes['builder'])),
          favorableAuthor: FavorableAuthor.fromJson(
              asT<Map<String, dynamic>>(jsonRes['favorableAuthor'])),
          bookAuthor: BookAuthor.fromJson(
              asT<Map<String, dynamic>>(jsonRes['bookAuthor'])),
        );

  Builder builder;
  FavorableAuthor favorableAuthor;
  BookAuthor bookAuthor;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'builder': builder,
        'favorableAuthor': favorableAuthor,
        'bookAuthor': bookAuthor,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class Builder {
  Builder({
    this.isGranted,
  });

  factory Builder.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : Builder(
          isGranted: asT<bool>(jsonRes['isGranted']),
        );

  bool isGranted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isGranted': isGranted,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class FavorableAuthor {
  FavorableAuthor({
    this.isGranted,
  });

  factory FavorableAuthor.fromJson(Map<String, dynamic> jsonRes) =>
      jsonRes == null
          ? null
          : FavorableAuthor(
              isGranted: asT<bool>(jsonRes['isGranted']),
            );

  bool isGranted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isGranted': isGranted,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

class BookAuthor {
  BookAuthor({
    this.isGranted,
  });

  factory BookAuthor.fromJson(Map<String, dynamic> jsonRes) => jsonRes == null
      ? null
      : BookAuthor(
          isGranted: asT<bool>(jsonRes['isGranted']),
        );

  bool isGranted;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isGranted': isGranted,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}
