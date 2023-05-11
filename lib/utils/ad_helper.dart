import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9691140516799861/1025844817';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9691140516799861/1025844817';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerAdUnitHome {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9691140516799861/5317969694';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9691140516799861/5317969694';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get bannerRequestAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9691140516799861/5317594993';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9691140516799861/5317594993';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnit {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9691140516799861/2097122013';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-9691140516799861/2097122013';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
