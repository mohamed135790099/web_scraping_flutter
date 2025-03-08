import 'dart:io';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class TestLogger extends StatefulWidget {
  const TestLogger({super.key});

  @override
  State<TestLogger> createState() => _TestLoggerState();
}

class _TestLoggerState extends State<TestLogger> {
  late Logger logger;
  String logFilePath = '';

  @override
  void initState() {
    super.initState();
    setupLogger().then((logInfo) {
      setState(() {
        logger = logInfo.$1;  // Logger instance
        logFilePath = logInfo.$2;  // File path
      });
    });
  }

  void logAllLevels() {
    logger.v("Verbose Log - تفاصيل كاملة");
    logger.d("Debug Log - للمطور");
    logger.i("Info Log - معلومة عادية");
    logger.w("Warning Log - تحذير");
    logger.e("Error Log - خطأ");
    logger.wtf("WTF Log - كارثة كبيرة");
  }

  void simulateError() {
    try {
      throw Exception("Test Exception - خطأ تجريبي");
    } catch (e, stackTrace) {
      logger.e("Exception Caught!", error: e, stackTrace: stackTrace);
    }
  }

  void printLogFilePath() {
    logger.i("Log file location: $logFilePath");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Logger Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: logAllLevels,
              child: const Text("Log All Levels"),
            ),
            ElevatedButton(
              onPressed: simulateError,
              child: const Text("Simulate Error"),
            ),
            ElevatedButton(
              onPressed: printLogFilePath,
              child: const Text("Show Log File Path"),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------- FileOutput (عشان يحفظ في الملف) ----------------
class FileOutput extends LogOutput {
  final File logFile;

  FileOutput(this.logFile);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      logFile.writeAsStringSync('$line\n', mode: FileMode.append);
    }
  }
}

// --------------- إعداد اللوجر ----------------
Future<(Logger, String)> setupLogger() async {
  final directory = await getApplicationDocumentsDirectory();
  final logsDir = Directory('${directory.path}/logs');

  if (!logsDir.existsSync()) {
    logsDir.createSync(recursive: true);
  }

  final logFilePath = '${logsDir.path}/app_logs.txt';
  final logFile = File(logFilePath);

  if (!logFile.existsSync()) {
    logFile.createSync();
  }

  final logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    output: MultiOutput([
      ConsoleOutput(),
      FileOutput(logFile),
    ]),
  );

  logger.i("Logger initialized - Logs saved to: $logFilePath");

  return (logger, logFilePath);  // بنرجع اللوجر والمسار
}
