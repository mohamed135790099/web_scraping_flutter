
import 'package:flutter/material.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/form.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/int_double_page.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/string_date_page.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/tab_page.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/text_bool_page.dart';


class MyRestorableApp extends StatelessWidget {
  const MyRestorableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'root',
      debugShowCheckedModeBanner: false,
      title: 'Restorable Widgets Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restorable Widgets Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text(' Text Form'),
            onTap: () => Navigator.of(context).restorablePush(_formRoute),
          ),
          ListTile(
            title: const Text('Restorable Text & Bool'),
            onTap: () => Navigator.of(context).restorablePush(_textBoolRoute),
          ),
          ListTile(
            title: const Text('Restorable Int & Double'),
            onTap: () => Navigator.of(context).restorablePush(_intDoubleRoute),
          ),
          ListTile(
            title: const Text('Restorable String & DateTime'),
            onTap: () => Navigator.of(context).restorablePush(_stringDateRoute),
          ),
          ListTile(
            title: const Text('Restorable TabController'),
            onTap: () => Navigator.of(context).restorablePush(_tabRoute),
          ),
        ],
      ),
    );
  }
}

Route<Object?> _textBoolRoute(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (_) => const RestorableTextBoolPage());
}

Route<Object?> _formRoute(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (_) => const MyForm());
}

Route<Object?> _intDoubleRoute(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (_) => const RestorableIntDoublePage());
}

Route<Object?> _stringDateRoute(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (_) => const RestorableStringDatePage());
}

Route<Object?> _tabRoute(BuildContext context, Object? arguments) {
  return MaterialPageRoute(builder: (_) => const RestorableTabPage());
}
