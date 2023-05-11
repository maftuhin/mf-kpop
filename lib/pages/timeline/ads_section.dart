import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpop_lyrics/utils/ad_helper.dart';

class AdsSection extends StatefulWidget {
  const AdsSection({super.key});

  @override
  State<AdsSection> createState() => _AdsSectionState();
}

class _AdsSectionState extends State<AdsSection> {
  BannerAd? _bannerAds;
  bool _bannerAdsLoaded = false;

  @override
  void dispose() {
    _bannerAds?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _bannerAds = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitHome,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          _bannerAdsLoaded = true;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    )..load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 300,
        minHeight: 200,
        maxHeight: 250,
      ),
      child: _bannerAdsLoaded ? AdWidget(ad: _bannerAds!) : Container(),
    );
  }
}
