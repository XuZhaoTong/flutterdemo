import 'package:dio/dio.dart';
import '../config/service_url.dart';

//获取首页主题内容
Future getHomePageContent() async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    response = await dio.post(
      servicePath['homePageContent'],
      data: formData,
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('ERROR:=========>$e');
  }
}

//获取热卖商品
Future getHomePageBelowContent() async {
  try {
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    int page = 1;
    response = await dio.post(
      servicePath['homePageBelowContent'],
      data: page,
    );
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('ERROR:=========>$e');
  }
}
