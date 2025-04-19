import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:root_checker_plus/root_checker_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:web_scraping_flutter/app_routes.dart';
import 'package:web_scraping_flutter/google_drive/drive_example_screen.dart';
import 'package:web_scraping_flutter/logger.dart';
import 'package:web_scraping_flutter/restorable_page.dart';
import 'package:web_scraping_flutter/restorable_widgets_project/lib/main.dart';
import 'package:web_scraping_flutter/screen_errors.dart';
import 'package:app_links/app_links.dart';

import 'amazon_web_view.dart';
import 'crashlytics_demo.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // مهم جدًا

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // تفعيل تسجيل الأخطاء
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const MyApp());

  /*
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

  */

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>  with RestorationMixin {

  final RestorableString _lastRoute = RestorableString(AppRoutes.home);
  //Initial Android root checker in set false value
  bool rootedCheck = false;

  //Initial iOS jailbreak detection in set false value
  bool jailbreak = false;

  //Initial Android Developer mode checker in set false value
  bool devMode = false;


  @override
  String get restorationId => 'app_root';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_lastRoute, 'last_route');
  }

  @override
  void initState() {
    super.initState();
    checkJailBreakAndRootedCheck();
  }

  checkJailBreakAndRootedCheck(){
    //Android initState check status on root check and developer mode checking
    if (Platform.isAndroid) {
      androidRootChecker();
      developerMode();
    }

    //Android initState check status on jailbreak detection checking
    if (Platform.isIOS) {
      iosJailbreak();
    }
  }

  Future<void> androidRootChecker() async {
    try {
      rootedCheck = (await RootCheckerPlus.isRootChecker())!;
    } on PlatformException {
      rootedCheck = false;
    }
    if (!mounted) return;
    setState(() {
      rootedCheck = rootedCheck;
    });
  }

  Future<void> developerMode() async {
    try {
      devMode = (await RootCheckerPlus.isDeveloperMode())!;
    } on PlatformException {
      devMode = false;
    }
    if (!mounted) return;
    setState(() {
      devMode = devMode;
    });
  }

  Future<void> iosJailbreak() async {
    try {
      jailbreak = (await RootCheckerPlus.isJailbreak())!;  // return iOS jailbreak status is true or false
    } on PlatformException {
      jailbreak = false;
    }
    if (!mounted) return;
    setState(() {
      jailbreak = jailbreak;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      restorationScopeId: "root",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        _lastRoute.value = settings.name ?? AppRoutes.home;
        return AppRoutes.generateRoute(settings);
      },
      initialRoute: rootedCheck?AppRoutes.profile:_lastRoute.value,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  late final AppLinks _appLinks;

  static Route<Object?> formRouteBuilder(BuildContext context, Object? arguments) {
    return MaterialPageRoute(
      builder: (_) => const RestorableProfileFormWidget(),
      settings: const RouteSettings(name:AppRoutes.profile),
    );
  }
  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _setupDeepLinkHandler();
  }

  void _setupDeepLinkHandler() async {
    // Handle incoming deep links
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (kDebugMode) {
          print('Deep link received: $uri');
        }
        _handleDeepLink(uri);
      }
    });

    // Handle initial deep link
    final Uri? initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      if (kDebugMode) {
        print('Initial deep link: $initialLink');
      }
      _handleDeepLink(initialLink);
    }
  }

  void _handleDeepLink(Uri uri) {
    if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'get-one-service') {
      final productId = uri.pathSegments.last;
      if (productId.isNotEmpty) {
        Navigator.of(context).push(
            MaterialPageRoute(builder:(context)=>AmazonWebView()));
      }
    }
  }

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
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.cyan,
                    minimumSize:const Size(double.infinity, 43)
                ),
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>ErrorTestScreen()));
                }, child: const Text("Test Sentry")),
            const SizedBox(height:20),
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.cyan,
                    minimumSize:const Size(double.infinity, 43)
                ),
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>const DriveScreen()));
                }, child: const Text("Google Drive")),
            const SizedBox(height:20),
            ElevatedButton(
                style:ElevatedButton.styleFrom(
                    backgroundColor:Colors.teal,
                    minimumSize:const Size(double.infinity, 43)
                ),
                onPressed:(){
                  Navigator.of(context).push(
                      MaterialPageRoute(builder:(context)=>CrashlyticsDemo()));
                }, child: const Text("Test Crashlytics")),
            const SizedBox(height:20),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size(double.infinity, 43)
                ),
                onPressed: () {
                  Navigator.restorablePush(context, formRouteBuilder);
                 // Navigator.of(context).pushNamed(AppRoutes.profile);
                },
                child: const Text("Restorable Page")
            ),


          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
