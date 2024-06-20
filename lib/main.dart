import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'app/screens/terms_agreement_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // Checking if the user has agreed to the terms
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool termsAgreed = prefs.getBool('termsAgreed') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExtractTextEditingProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => ExtractionProvider()),
        ChangeNotifierProvider(create: (_) => LogProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
      ],
      child: ExtractApp(termsAgreed: termsAgreed),
    ),
  );
}

class ExtractApp extends StatelessWidget {
  final bool termsAgreed;

  ExtractApp({required this.termsAgreed});

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => ExtractPage());
      case '/terms-agreement':
        return MaterialPageRoute(builder: (_) => TermsAgreementPage());
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
      initialRoute: termsAgreed ? '/' : '/terms-agreement',
      onGenerateRoute: _generateRoute,
    );
  }
}
