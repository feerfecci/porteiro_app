import 'package:app_porteiro/repositories/theme_modals/theme_modals.dart';
import 'package:app_porteiro/repositories/theme_modals/themes_provider.dart';
import 'package:app_porteiro/screens/home/home_page.dart';
import 'package:app_porteiro/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_localizations/flutter_localizations.dart';
// ignore: depend_on_referenced_packages
// import 'package:localization/localization.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  RendererBinding.instance.setSemanticsEnabled(true);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(const MyApp());
  });
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
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          initialRoute: '/splashScreen',
          supportedLocales: const [
            Locale('en', 'USA'), // English, UK
            Locale('pt', 'BR'), // Arabic, UAE
          ],
          routes: {
            '/splashScreen': (context) => SplashScreen(),
            '/homePage': (context) => HomePage(),
          },
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: child!);
          },
        );
      },
    );
  }
}
