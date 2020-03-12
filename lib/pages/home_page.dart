import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;
  List<Map> _hotGoodsList = [];
  GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: request('homePageContent', formData: _formData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              List<Map> _swiperDataList =
                  (data['data']['slides'] as List).cast();
              List<Map> _navgatorDataList =
                  (data['data']['category'] as List).cast();
              String _adPicture =
                  data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String _leaderImage = data['data']['shopInfo']['leaderImage'];
              String _leaderPhone = data['data']['shopInfo']['leaderPhone'];
              List<Map> _recommendList =
                  (data['data']['recommend'] as List).cast();
              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              List<Map> floor2 = (data['data']['floor1'] as List).cast();
              List<Map> floor3 = (data['data']['floor1'] as List).cast();
              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: '',
                  moreInfo: '加载中',
                  loadReadyText: '上拉加载....',
                ),
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList: _swiperDataList), //页面顶部轮播组件
                    TopNavigator(navgatorDataList: _navgatorDataList), //导航组件
                    AdBanner(adPicture: _adPicture),
                    LeaderPhone(
                        leaderImage: _leaderImage,
                        leaderPhone: _leaderPhone), //广告组件
                    Recommend(recommendList: _recommendList),
                    FloorTitle(pictureAddress: floor1Title),
                    FloorContent(floorGoodsList: floor1),
                    FloorTitle(pictureAddress: floor2Title),
                    FloorContent(floorGoodsList: floor2),
                    FloorTitle(pictureAddress: floor3Title),
                    FloorContent(floorGoodsList: floor3),
                    _hotGoods(),
                  ],
                ),
                loadMore: () async {
                  print('开始加载更多');
                  var formPage = {'page': _page};
                  await request('homePageBelowConten', formData: formPage)
                      .then((val) {
                    var data = json.decode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      _hotGoodsList.addAll(newGoodsList);
                      _page++;
                    });
                  });
                },
              );
            } else {
              return Center(
                child: Text('加载中'),
              );
            }
          },
        ));
  }

  Widget _hotTitle() {
    return Container(
      child: Text('火爆专区'),
      alignment: Alignment.center,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(
        top: 10,
      ),
    );
  }

  Widget _wrapList() {
    if (_hotGoodsList.length != 0) {
      List<Widget> _listWidget = _hotGoodsList.map(
        (val) {
          return InkWell(
            onTap: () {},
            child: Container(
              width: ScreenUtil().setWidth(372),
              color: Colors.white,
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.only(
                bottom: 3,
              ),
              child: Column(
                children: <Widget>[
                  Image.network(
                    val['image'],
                    width: ScreenUtil().setWidth(370),
                  ),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: ScreenUtil().setSp(26),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['mallPrice']}'),
                      Text(
                        '￥${val['price']}',
                        style: TextStyle(
                          color: Colors.black26,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ).toList();
      return Wrap(
        spacing: 2,
        children: _listWidget,
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          _hotTitle(),
          _wrapList(),
        ],
      ),
    );
  }
}

// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network("${swiperDataList[index]['image']}",
              fit: BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//导航
class TopNavigator extends StatelessWidget {
  final List navgatorDataList;
  TopNavigator({this.navgatorDataList});
  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Column(
        children: <Widget>[
          Image.network(
            item['image'],
            width: ScreenUtil().setWidth(95),
          ),
          Text(
            item['mallCategoryName'],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (navgatorDataList.length > 10) {
      navgatorDataList.removeRange(10, navgatorDataList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(350),
      padding: EdgeInsets.all(3),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5),
        children: navgatorDataList.map(
          (item) {
            return _gridViewItemUI(context, item);
          },
        ).toList(),
      ),
    );
  }
}

//广告区域
class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({Key key, this.adPicture}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

//店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  LeaderPhone({this.leaderImage, this.leaderPhone});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({this.recommendList});
  //推荐商品标题
  Widget _titleWidget() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text('商品推荐', style: TextStyle(color: Colors.pink)));
  }

  Widget _item(index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.black12),
          ),
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(365),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: recommendList.length,
          itemBuilder: (context, index) {
            return _item(index);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAddress;
  const FloorTitle({Key key, this.pictureAddress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Image.network(pictureAddress),
    );
  }
}

//楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods(),
        ],
      ),
    );
  }

  Widget _firstRow() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[1]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods) {
    return Container(
      width: ScreenUtil().setWidth(350),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
        },
        child: Image.network(
          goods['image'],
        ),
      ),
    );
  }
}

//火爆专区
class HotGoods extends StatefulWidget {
  @override
  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
    request('homePageBelowConten', formData: 1).then((val) {
      print(val);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('11'));
  }
}
