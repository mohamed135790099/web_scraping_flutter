import 'package:flutter/material.dart';
import 'package:web_scraping_flutter/main.dart';
import 'package:web_scraping_flutter/restorable_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'Flutter Demo Home Page'),
          settings: settings, // مهم للحفاظ على حالة الاستعادة
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const RestorableProfileFormWidget(),
          settings: settings, // مهم للحفاظ على حالة الاستعادة
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
         ));
    }
  }
}