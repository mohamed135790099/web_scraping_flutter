import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../utils/api_constant.dart';
import '../model/base_response.dart';

class DioHelper {
  static const String _baseUrl = ApiConstant.baseUrl;
  static final DioHelper _instance = DioHelper._internal();
  static final Dio _dio =
  Dio(BaseOptions(
    baseUrl: _baseUrl,
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(milliseconds: 30 * 1000),
    sendTimeout: const Duration(milliseconds: 30 * 1000),
    receiveTimeout: const Duration(milliseconds: 120 * 1000),
  ))
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,));

  // 👇 Private constructor
  DioHelper._internal();

  factory DioHelper() {
    return _instance;
  }

  Dio get dio => _dio;

  /// get
   Future<ResponseModel> get(
      {required String endPoint,
        Map<String, dynamic>? query,
        Map<String, dynamic> data = const {},
        bool showErrorMessage = true,
        String? token,
        ProgressCallback? onReceiveProgress}) async {
    try {
      _dio.options.headers = {
        'Authorization': "Bearer $token",
      };
      final response = await _dio.get(endPoint,
          data: jsonEncode(data),
          queryParameters: query,
          onReceiveProgress: onReceiveProgress);

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error.message);
    } on SocketException {
      throw Exception('No Internet connection');
    } on FormatException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// post
   Future<ResponseModel> post(
      {required String endPoint,
        bool showErrorMessage = true,
        Map<String, dynamic> data = const {},
        bool isFormData = false,
        Map<String, dynamic>? query,
        String? token,
        ProgressCallback? onSendProgress}) async {
    try {
      _dio.options.headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        'Authorization': "Bearer $token",
      };

      final response = await _dio.post(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
      );

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    } on SocketException {
      throw Exception('No Internet connection');
    } on FormatException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ResponseModel> patch(
      {required String endPoint,
        bool showErrorMessage = true,
        Map<String, dynamic> data = const {},
        bool isFormData = false,
        Map<String, dynamic>? query,
        String? token,
        ProgressCallback? onSendProgress}) async {
    try {
      _dio.options.headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
        'Authorization': "Bearer $token",
      };

      final response = await _dio.patch(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
      );

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    } on SocketException {
      throw Exception('No Internet connection');
    } on FormatException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ResponseModel> put(
      {required String endPoint,
        bool showErrorMessage = true,
        Map<String, dynamic> data = const {},
        bool isFormData = false,
        Map<String, dynamic>? query,
        ProgressCallback? onSendProgress}) async {
    try {
      _dio.options.headers = {
        'Content-Type': isFormData ? 'multipart/form-data' : 'application/json',
      };

      final response = await _dio.put(
        endPoint,
        data: isFormData ? FormData.fromMap(data) : jsonEncode(data),
        queryParameters: query,
        onSendProgress: onSendProgress,
      );

      return ResponseModel.fromJson(response.data);
    } on DioException catch (error) {
      throw Exception(error);
    } on SocketException {
      throw Exception('No Internet connection');
    } on FormatException catch (e) {
      throw Exception(e.toString());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
