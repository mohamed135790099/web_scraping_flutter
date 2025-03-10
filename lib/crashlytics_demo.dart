import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsDemo extends StatelessWidget {
  // دالة ترسل استثناء يدويًا إلى Firebase
  void sendCustomError() {
    try {
      throw Exception("خطأ مخصص من التطبيق! 🚀🔥");
    } catch (e, s) {
      FirebaseCrashlytics.instance.recordError(e, s);
    }
  }

  // دالة تؤدي إلى كراش فوري
  void crashApp() {
    FirebaseCrashlytics.instance.crash(); // هتعمل كراش فوري للتطبيق
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firebase Crashlytics Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: sendCustomError,
              child: const Text("إرسال خطأ إلى Firebase"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: crashApp,
              child: const Text("عمل كراش للتطبيق!"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
