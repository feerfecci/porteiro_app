import 'package:app_porteiro/repositories/theme_modals/theme_modals.dart';
import 'package:app_porteiro/repositories/theme_modals/themes_provider.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.setSemanticsEnabled(true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          title: 'Flutter Demo',
          theme: themeLight(context),
          darkTheme: themeDark(context),
          home: SplashScreen(),
          initialRoute: '/splashScreen',
          routes: {
            '/splashScreen': (context) => SplashScreen(),
            '/homePage': (context) => HomePage(),
          },
        );
      },
    );
  }
}
