import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../services/admob_service.dart';

class AdProvider with ChangeNotifier {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  BannerAd? get bannerAd => _bannerAd;
  bool get isAdLoaded => _isAdLoaded;

  void createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdmobService.bannerAdUnitId!,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isAdLoaded = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          _isAdLoaded = false;
          notifyListeners();
        },
      ),
      request: AdRequest(),
    )..load();
  }

  void disposeAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
    notifyListeners();
  }
}
