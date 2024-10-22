import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:login/firebase_options.dart';
import 'package:login/src/features/authentication/controllers/dashboard_controller.dart';
import 'package:login/src/features/authentication/controllers/splash_screen_controllers.dart';
import 'package:login/src/features/authentication/screens/splash_screen/splash_screen.dart';
import 'package:login/src/repository/authentication_repository/fauthentication_repository.dart';
import 'package:login/src/repository/user_repository/user_repository.dart';
import 'package:login/src/utils/helper/network_manager.dart';
import 'package:login/src/utils/theme/widget_themes/text_theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Activate Firebase App Check first
  FirebaseAppCheck.instance.activate();

  // Initialize FAuthenticationRepository first
  Get.put(FAuthenticationRepository());

  // Initialize FOTPController
  // Initialize dashboard

  // Initialize other repositories and controllers
  Get.put(CustomerRepository());
  Get.put(SplashScreenController());
  Get.put(HomeController());
  runApp(const MyApp());


  // Wait until the app is fully loaded before accessing FarmerSignUpController and FOTPController
  Future.delayed(Duration.zero, () {
    // Determine if the user is a farmer


    // Initialize FarmerSignUpController for farmer-related operations


    // Initialize FOTPController for farmer-related operations if needed


  }
  );
}

class SignUpController {
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NetworkManager());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmFusion Exchange',
      theme: ThemeData(
        textTheme: TTextTheme.lightTextTheme,
      ),
      darkTheme: ThemeData(
        textTheme: TTextTheme.darkTextTheme,
      ),
      home: SplashScreen(),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}