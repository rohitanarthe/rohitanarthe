
import 'package:dio/dio.dart';

import '../constant/api_url_constant/api_url_constant.dart';

class ApiService {
  Future<Response> postDataWithForm(Map<String, dynamic> formData) async {
    final Dio dio = Dio();
    try {
      final response = await dio.post(
        AppConstant.baseUrl,
        data: FormData.fromMap(formData),
        /*options: Options(
          headers: {'Authorization': 'Bearer ${loginController.jwt}'},
        ),*/
      );
      print('Response: ${response.data}');
      return response;
    }
    catch (e) {
      print(e.toString());
      throw Exception();
    }
    // }
  }
}
