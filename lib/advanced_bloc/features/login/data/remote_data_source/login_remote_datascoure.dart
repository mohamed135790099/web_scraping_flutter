import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> authLogin(String email ,String password);
}
class LoginRemoteSourceImpl extends LoginRemoteDataSource{
  @override
  Future<UserModel> authLogin(String email, String password) async {
    try {
      Dio dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
        ),
      )..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,));
      final response = await dio.post(
        "https://lawyer-secretary.com/api/user/login",
        data: {
          "email": email,
          "password": password,
        },
      );
      if (response.statusCode == 200) {
        // احتمال يكون فيه wrapper للبيانات
        final data = response.data;
        final userData = data["data"];
        // لو فيه wrapper
        return UserModel.fromJson(userData); // أو response.data حسب هيكل الـ API
      } else {
        throw Exception("Failed to login: ${response.statusCode} - ${response.data}");
      }
    } catch (e) {
      throw Exception("Login Error: ${e.toString()}");
    }
  }


}
