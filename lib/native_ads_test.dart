import 'package:amuze/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeAds extends StatefulWidget {
  const NativeAds({super.key});

  @override
  State<NativeAds> createState() => _NativeAdsState();
}

class _NativeAdsState extends State<NativeAds> {
  late NativeAd _ad;
  TargetPlatform? os;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    os = Theme.of(context).platform;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ad.dispose();
  }

  @override
  void initState() {
    super.initState();

    _ad = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110',
      factoryId: "listTile",
      request: const AdRequest(),
      listener: NativeAdListener(onAdLoaded: (ad) {
        setState(() {
          _ad = ad as NativeAd;
          isLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
    );
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == true
        ? SizedBox(height: 120, child: AdWidget(ad: _ad))
        : const SizedBox.shrink();
  }
}
