import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/extraction_provider.dart';
import 'providers/download_provider.dart';
import 'providers/extract_text_editing_provider.dart';
import 'providers/log_provider.dart';
import 'app/screens/extract_page.dart';
import 'app/screens/settings_page.dart';
import 'app/screens/help_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
