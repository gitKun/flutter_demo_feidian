import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pagetext/model/recommend_local.dart';

import 'cell/recommend_cell.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: '沸点'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UserActivity> activities = [];
  @override
  initState() {
    super.initState();
    getLocalData().then((data) {
      setState(() {
        this.activities = data;
      });
    });
  }

  // 获取网络数据
  Future<Response> getNetData() async {
    final Dio dio = Dio();
    Map<String, dynamic> params = {
      "variables": {"after": "", "afterPosition": ""},
      "extensions": {
        "query": {"id": "d2d1b7655286050c2ae9362872447126"}
      }
    };
    dio.options.headers = {
      "X-Agent": "iPhone/iPhone11,8 iOS/13.4 Juejin/iOS/5.7.10"
    };
    Response response = await dio.post(
      'https://ios-api.juejin.im/graphql',
      data: json.encode(params),
    );
    print(response.data);
    return response;
  }

  // 获取本地数据
  Future<List<UserActivity>> getLocalData() async {
    String localPath = 'json_data/local.json';
    String data = await DefaultAssetBundle.of(context).loadString(localPath);
    List<UserActivity> list = LocalRecommend.fromJson(json.decode(data))
        .data
        .map((e) => e.userActivity)
        .toList();
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            //fontFamily: 'NoteSansSC',
            fontWeight: FontWeight.w500,
            letterSpacing: 3,
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    if (activities.length == 0) {
      return SizedBox();
    }
    return ListView(
      //shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: activities
          .map<RecommendCell>((e) => RecommendCell(model: e))
          .toList(),
    );
  }
}
