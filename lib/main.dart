import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:web_scraping_flutter/logger.dart';
import 'package:web_scraping_flutter/screen_errors.dart';

import 'amazon_web_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // مهم جدًا
  await setupSentry(
      () => runApp(
    SentryWidget(
      child: DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: const MyApp(),
      ),
    ),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
           backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             const Text(
              'You have pushed the button this many times:',
            ),
            ElevatedButton(
              style:ElevatedButton.styleFrom(
                backgroundColor:Colors.green,
                minimumSize:const Size(double.infinity, 43)
              ),
                onPressed:(){
              Navigator.of(context).push(MaterialPageRoute(builder:(context)=>const TestLogger()));
            }, child: Text("logger")),
            const SizedBox(height:20),
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.amberAccent,
                    minimumSize:const Size(double.infinity, 43)
                ),
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>AmazonWebView()));
                }, child: const Text("تصفح امازون ")),
            const SizedBox(height:20),
            const SizedBox(height:20),
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.amberAccent,
                    minimumSize:const Size(double.infinity, 43)
                ),
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>ErrorTestScreen()));
                }, child: const Text("Test Sentry")),
          ],
        ),
      ),
    );
  }
}

Future<void> setupSentry(
    AppRunner appRunner,{

      bool isIntegrationTest = false,
      BeforeSendCallback? beforeSendCallback,
    }) async {
  await SentryFlutter.init(
        (options) {
      options.dsn = "https://8dc6d4219ccd99ffe3efe833a2a330d5@o446190.ingest.us.sentry.io/4508941241483264";
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.reportPackages = false;
      options.addInAppInclude('com.example.web_scraping_flutter');
      options.considerInAppFramesByDefault = false;
      options.attachThreads = true;
      options.enableWindowMetricBreadcrumbs = true;
      options.sendDefaultPii = true;
      options.reportSilentFlutterErrors = true;
      options.attachScreenshot = true;
      options.attachViewHierarchy = true;
      // We can enable Sentry debug logging during development. This is likely
      // going to log too much for your app, but can be useful when figuring out
      // configuration issues, e.g. finding out why your events are not uploaded.
      options.debug = kDebugMode;
      options.spotlight = Spotlight(enabled: true);
      options.enableTimeToFullDisplayTracing = true;
      options.enableSentryJs = true;

      options.maxRequestBodySize = MaxRequestBodySize.always;
      options.maxResponseBodySize = MaxResponseBodySize.always;
      options.navigatorKey = navigatorKey;

      options.experimental.replay.sessionSampleRate = 1.0;
      options.experimental.replay.onErrorSampleRate = 1.0;

      // This has a side-effect of creating the default privacy configuration,
      // thus enabling Screenshot masking. No need to actually change it.
      options.experimental.privacy;

    },
    // Init your App.
    appRunner: appRunner,
  );
}
