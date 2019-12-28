import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_yqf/dao/home_dao.dart';
import 'package:flutter_yqf/model/common_model.dart';
import 'package:flutter_yqf/model/grid_nav_model.dart';
import 'dart:convert';

import 'package:flutter_yqf/model/home_model.dart';
import 'package:flutter_yqf/widget/grid_nav.dart';
import 'package:flutter_yqf/widget/local_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    "https://dimg04.c-ctrip.com/images/zg0q1b000001aoz7a2BA8.jpg",
    "https://dimg04.c-ctrip.com/images/zg0s180000014rym6B157.jpg",
    "https://dimg04.c-ctrip.com/images/zg091b000001a3dk5F24B.jpg",
    "https://dimg04.c-ctrip.com/images/zg0d1b000001atnsz7634.jpg"
  ];

  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;
  _onScroll(offset) {
    double alpha = offset/APPBAR_SCROLL_OFFSET;
    if(alpha < 0) {
      alpha = 0;
    } else if(alpha>1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });

  }


  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
//    HomeDao.fetch().then((result){
//      setState(() {
//        resultString = json.encode(result);
//      });
//    }).catchError((e){
//      setState(() {
//        resultString = e.toString();
//      });
//    });

    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
          resultString = json.encode(model);
          localNavList = model.localNavList;
          gridNavModel = model.gridNav;
        });
    } catch (e) {
      setState(() {
        resultString  = e.toString();
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body:Stack(children: <Widget>[
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: NotificationListener(
              // ignore: missing_return
              onNotification: (scrollNotification){
                if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                  _onScroll(scrollNotification.metrics.pixels);
                }
              },
              child:ListView(
                children: <Widget>[
                  Container(
                    height: 160,
                    child:Swiper(itemCount: _imageUrls.length,autoplay: true,itemBuilder: (BuildContext context, int index){
                      return Center(
                        child: Image.network(
                          _imageUrls[index],
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                      pagination: SwiperPagination(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    child: LocalNav(localNavList: localNavList)
                  ),

                  Padding(
                      padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                      child: GridNav(gridNavModel:gridNavModel),
                  ),

                  Container(
                    height: 800,
                    child: ListTile(title: Text(resultString)),
                  )
                ],
              ),
            )
        ),
        Opacity(
          opacity: appBarAlpha,
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('首页'),
              ),
            ),
          ),
        )
      ],
      )
    );
  }

}