import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6519817120789589/9423698219';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6519817120789589/9423698219';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6519817120789589/6570411968';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6519817120789589/6570411968';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (Ad ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      print('Ad failed to load: ${ad.adUnitId}, $error');
    },
    onAdOpened: (Ad ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (Ad ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdImpression: (Ad ad) => print('Ad impression: ${ad.adUnitId}.'),
    onAdClicked: (Ad ad) => print('Ad clicked: ${ad.adUnitId}.'),
  );
}
