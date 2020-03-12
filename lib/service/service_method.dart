import 'package:dio/dio.dart';
import '../config/service_url.dart';

//获取首页主题内容
Future request(url, {formData}) async {
  try {
    print('开始获取数据........');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = Headers.formUrlEncodedContentType;
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(
        servicePath[url],
        data: formData,
      );
    }

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常。');
    }
  } catch (e) {
    return print('ERROR:=========>$e');
  }
}
