import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ErrorTestScreen extends StatefulWidget {
  @override
  _ErrorTestScreenState createState() => _ErrorTestScreenState();
}

class _ErrorTestScreenState extends State<ErrorTestScreen> {
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _dio.interceptors.add(SentryDioInterceptor());
  }

  Future<void> triggerDartError() async {
    try {
      List<int> list = [1, 2, 3];
      print(list[5]); // Index out of range error
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> triggerHttpError() async {
    try {
      await _dio.get('https://wrongurl.typicode.com/posts');
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> triggerCustomError() async {
    try {
      throw Exception("This is a custom error");
    } catch (e, stackTrace) {
      await Sentry.captureException(e, stackTrace: stackTrace);
    }
  }

  Future<void> saveErrorToFile(String errorMessage) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/error_logs.txt');
    await file.writeAsString('$errorMessage\n', mode: FileMode.append);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sentry + Dio Test")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: triggerDartError,
              child: const Text("Trigger Dart Error"),
            ),
            ElevatedButton(
              onPressed: triggerHttpError,
              child: const Text("Trigger HTTP Error"),
            ),
            ElevatedButton(
              onPressed: triggerCustomError,
              child: const Text("Trigger Custom Error"),
            ),
          ],
        ),
      ),
    );
  }
}

class SentryDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Sentry.captureException(err, stackTrace: err.stackTrace);
    super.onError(err, handler);
  }
}
