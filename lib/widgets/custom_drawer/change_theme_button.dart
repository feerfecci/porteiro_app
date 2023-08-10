import 'package:app_porteiro/consts/consts_widget.dart';
import 'package:app_porteiro/repositories/theme_modals/themes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../screens/splash/splash_screen.dart';

class ChangeThemeButton extends StatefulWidget {
  const ChangeThemeButton({super.key});

  @override
  State<ChangeThemeButton> createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    String title =
        themeProvider.isDarkMode ? 'Ativar Modo Claro' : 'Ativar Modo Escuro';
    bool isOn = themeProvider.isDarkMode;
    return ListTile(
      title: ConstsWidget.buildTitleText(context, title: title),
      iconColor: Theme.of(context).iconTheme.color,
      leading: isOn
          ? Icon(
              Icons.light_mode,
              size: SplashScreen.isSmall ? 20 : 25,
            )
          : Icon(
              Icons.dark_mode_rounded,
              size: SplashScreen.isSmall ? 20 : 25,
            ),
      trailing: Switch.adaptive(
        value: themeProvider.isDarkMode,
        onChanged: (value) {
          final themeProvider =
              Provider.of<ThemeProvider>(context, listen: false);
          themeProvider.toogle(value);
          setState(() {
            isOn = !value;
          });
        },
      ),
    );
  }
}
