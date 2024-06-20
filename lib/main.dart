import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'providers/extraction_provider.dart';
import 'providers/download_provider.dart';
import 'providers/extract_text_editing_provider.dart';
import 'providers/log_provider.dart';
import 'providers/ad_provider.dart';
import 'app/screens/extract_page.dart';
import 'app/screens/settings_page.dart';
import 'app/screens/help_page.dart';
import 'app/screens/terms_page.dart';
import 'app/screens/license_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExtractTextEditingProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => ExtractionProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
      ],
      child: ExtractApp(),
    ),
  );
}

class ExtractApp extends StatelessWidget {
  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ExtractPage());
      case '/settings':
        return MaterialPageRoute(builder: (_) => SettingsPage());
      case '/settings/help':
        return MaterialPageRoute(builder: (_) => HelpPage());
      case '/settings/terms':
        return MaterialPageRoute(builder: (_) => TermsPage());
      case '/settings/license':
        return MaterialPageRoute(builder: (_) => AppLicensePage());
      default:
        throw Exception('Invalid route: ${settings.name}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: _generateRoute,
    );
  }
}
