import 'package:cirilla/service/ads_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CirillaAdsBottom extends StatefulWidget {
  const CirillaAdsBottom({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  _CirillaAdsBottomState createState() => _CirillaAdsBottomState();
}

class _CirillaAdsBottomState extends State<CirillaAdsBottom> {
  // COMPLETE: Add a BannerAd instance
  late BannerAd _ad;

  // COMPLETE: Add _isAdLoaded
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    // COMPLETE: Create a BannerAd instance
    _ad = BannerAd(
      adUnitId: AdService.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          if (kDebugMode) {
            print('Ad load failed (code=${error.code} message=${error.message})');
          }
        },
      ),
    );

    // COMPLETE: Load an ad
    _ad.load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: widget.child),
        if (_isAdLoaded)
          Container(
            child: AdWidget(ad: _ad),
            width: _ad.size.width.toDouble(),
            height: 50.0,
            alignment: Alignment.center,
          )
      ],
    );
  }
}