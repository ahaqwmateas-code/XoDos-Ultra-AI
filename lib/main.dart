import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'pages.dart';
import 'core_classes.dart';
import 'ultra_ai.dart';
import 'auto_update_system.dart';
import 'bug_fixes.dart';
import 'light_blue_theme.dart';
import 'yearly_auto_update.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Global State and Preferences
  G.prefs = await SharedPreferences.getInstance();
  
  // Enable Wakelock to keep screen on
  await WakelockPlus.enable();
  
  // Set Immersive Mode
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Initialize the auto-update system
  await AutoUpdateSystem().initialize();
  
  // Initialize the bug fix system
  await BugFixSystem().initialize();
  
  // Initialize the yearly auto-update system
  await YearlyAutoUpdateSystem().initialize();
  
  runApp(const XoDosApp());
}

class XoDosApp extends StatelessWidget {
  const XoDosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XoDos Ultra AI',
      debugShowCheckedModeBanner: false,
      theme: LightBlueTheme.getLightBlueTheme(),
      darkTheme: LightBlueTheme.getLightBlueTheme(),
      themeMode: ThemeMode.dark,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('zh', ''),
        Locale('ar', ''),
      ],
      home: const MyHomePage(title: 'XoDos Ultra AI'),
    );
  }
}

class RTLWrapper extends StatelessWidget {
  final Widget child;
  const RTLWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine directionality based on the current locale
    final locale = Localizations.maybeLocaleOf(context);
    final isRtl = locale?.languageCode == 'ar';
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }
}
