// Copyright (c) 2019, the Panacea-Soft.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// Panacea-Soft license that can be found in the LICENSE file.

import 'package:flutterbuyandsell/viewobject/common/language.dart';

class PsConfig {
  PsConfig._();

  ///
  /// AppVersion
  /// For your app, you need to change according based on your app version

  static const String app_version = '2.6';

  ///
  /// API Key
  /// If you change here, you need to update in server.
  ///
  static const String ps_api_key = 'lokixapp';

  ///
  /// API URL
  /// Change your backend url
  ///
  static const String ps_core_url =
      'https://lokix.space/index.php/';

  static const String ps_app_url = 'https://lokix.space/index.php/';

  static const String ps_app_image_url = 'https://lokix.space/uploads/';

  static const String ps_app_image_thumbs_url = 'https://lokix.space/uploads/thumbnail/';

  static const String GOOGLE_PLAY_STORE_URL =
      'https://play.google.com/store/apps';

  static const String APPLE_APP_STORE_URL = 'https://www.apple.com/app-store';

  ///
  /// Chat Setting
  ///


  static const String iosGoogleAppId =
      '0:000000000000:ios:0000000000000000000000';
  static const String iosGcmSenderId = '000000000000';
  static const String iosProjectId = 'flutter-buy-and-sell';
  static const String iosDatabaseUrl =
      'https://flutter-buy-and-sell.firebaseio.com';
  static const String iosApiKey = 'AIz000000000000000000000000000000000000';

  static const String androidGoogleAppId =
      '1:671138907621:android:272f41681b3a97fe2d5b0c';
  static const String androidGcmSenderId = '671138907621';
  static const String androidProjectId = 'lokix-37c36';
  static const String androidApiKey = 'AIzaSyAY1DQBavk-CCnVCkJng_pdF17hn3L-S4Q';
  static const String androidDatabaseUrl =
      'https://lokix-37c36-default-rtdb.europe-west1.firebasedatabase.app';

  ///
  /// Facebook Key
  ///

  static const String fbKey = '000000000000000';

  ///
  ///Admob Setting
  ///
  static bool showAdMob = true;
  static String androidAdMobAdsIdKey = 'ca-app-pub-2705473237139737~8672481451';
  static String androidAdMobUnitIdApiKey = 'ca-app-pub-2705473237139737/2521650854';
  static String androidAdMobInterstitial = 'ca-app-pub-3940256099942544/1033173712';//ca-app-pub-2705473237139737/6680194197';
  static String iosAdMobAdsIdKey = 'ca-app-pub-0000000000000000~0000000000';
  static String iosAdMobUnitIdApiKey = 'ca-app-pub-0000000000000000/0000000000';
  static String iosAdMobInterstitial = 'ca-app-pub-0000000000000000/0000000000';



  ///
  /// iOS App No
  ///
  static const String iOSAppStoreId = '000000000';


  ///
  /// Animation Duration
  ///
  static const Duration animation_duration = Duration(milliseconds: 300);

  ///
  /// Fonts Family Config
  /// Before you declare you here,
  /// 1) You need to add font under assets/fonts/
  /// 2) Declare at pubspec.yaml
  /// 3) Update your font family name at below
  ///
  static const String ps_default_font_family = 'Quicksand';

  /// Default Language
// static const ps_default_language = 'en';

// static const ps_language_list = [Locale('en', 'US'), Locale('ar', 'DZ')];
  static const String ps_app_db_name = 'ps_db.db';

  ///
  /// For default language change, please check
  /// LanguageFragment for language code and country code
  /// ..............................................................
  /// Language             | Language Code     | Country Code
  /// ..............................................................
  /// "English"            | "en"              | "US"
  /// "Arabic"             | "ar"              | "DZ"
  /// "India (Hindi)"      | "hi"              | "IN"
  /// "German"             | "de"              | "DE"
  /// "Spainish"           | "es"              | "ES"
  /// "French"             | "fr"              | "FR"
  /// "Indonesian"         | "id"              | "ID"
  /// "Italian"            | "it"              | "IT"
  /// "Japanese"           | "ja"              | "JP"
  /// "Korean"             | "ko"              | "KR"
  /// "Malay"              | "ms"              | "MY"
  /// "Portuguese"         | "pt"              | "PT"
  /// "Russian"            | "ru"              | "RU"
  /// "Thai"               | "th"              | "TH"
  /// "Turkish"            | "tr"              | "TR"
  /// "Chinese"            | "zh"              | "CN"
  /// ..............................................................
  ///
  static final Language defaultLanguage =
      Language(languageCode: 'fr', countryCode: 'FR', name: 'French');

  static final List<Language> psSupportedLanguageList = <Language>[
    Language(languageCode: 'en', countryCode: 'US', name: 'English'),
    Language(languageCode: 'ar', countryCode: 'DZ', name: 'Arabic'),
    Language(languageCode: 'hi', countryCode: 'IN', name: 'Hindi'),
    Language(languageCode: 'de', countryCode: 'DE', name: 'German'),
    Language(languageCode: 'es', countryCode: 'ES', name: 'Spainish'),
    Language(languageCode: 'fr', countryCode: 'FR', name: 'French'),
    Language(languageCode: 'id', countryCode: 'ID', name: 'Indonesian'),
    Language(languageCode: 'it', countryCode: 'IT', name: 'Italian'),
    Language(languageCode: 'ja', countryCode: 'JP', name: 'Japanese'),
    Language(languageCode: 'ko', countryCode: 'KR', name: 'Korean'),
    Language(languageCode: 'ms', countryCode: 'MY', name: 'Malay'),
    Language(languageCode: 'pt', countryCode: 'PT', name: 'Portuguese'),
    Language(languageCode: 'ru', countryCode: 'RU', name: 'Russian'),
    Language(languageCode: 'th', countryCode: 'TH', name: 'Thai'),
    Language(languageCode: 'tr', countryCode: 'TR', name: 'Turkish'),
    Language(languageCode: 'zh', countryCode: 'CN', name: 'Chinese'),
  ];

  ///
  /// Price Format
  /// Need to change according to your format that you need
  /// E.g.
  /// ",##0.00"   => 2,555.00
  /// "##0.00"    => 2555.00
  /// ".00"       => 2555.00
  /// ",##0"      => 2555
  /// ",##0.0"    => 2555.0
  ///
  static const String priceFormat = ',##0';

  ///
  /// Date Time Format
  ///
  static const String dateFormat = 'dd-MM-yyyy hh:mm';

  ///
  /// Tmp Image Folder Name
  ///
  static const String tmpImageFolderName = 'FlutterBuySell';

  ///
  /// Image Loading
  ///
  /// - If you set "true", it will load thumbnail image first and later it will
  ///   load full image
  /// - If you set "false", it will load full image directly and for the
  ///   placeholder image it will use default placeholder Image.
  ///
  static const bool USE_THUMBNAIL_AS_PLACEHOLDER = true;

  ///
  /// Token Id
  ///
  /// "true" = it will show token id under setting
  static const bool isShowTokenId = true;

  ///
  /// ShowSubCategory
  ///
  static const bool isShowSubCategory = true;

  ///
  /// GoogleMap, default map is Flutter Map
  ///
  static const bool isUseGoogleMap = true;

  ///
  /// Promote Item
  ///
  static const String PROMOTE_FIRST_CHOICE_DAY_OR_DEFAULT_DAY = '7 ';
  static const String PROMOTE_SECOND_CHOICE_DAY = '14 ';
  static const String PROMOTE_THIRD_CHOICE_DAY = '30 ';
  static const String PROMOTE_FOURTH_CHOICE_DAY = '60 ';

  ///
  /// Image Size
  ///
  static const int uploadImageSize = 1024;
  static const int profileImageSize = 512;
  static const int chatImageSize = 650;

  ///
  /// Default Limit
  ///
  static const int DEFAULT_LOADING_LIMIT = 30;
  static const int CATEGORY_LOADING_LIMIT = 10;
  static const int RECENT_ITEM_LOADING_LIMIT = 10;
  static const int POPULAR_ITEM_LOADING_LIMIT = 10;
  static const int FEATURE_ITEM_LOADING_LIMIT = 10;
  static const int BLOCK_SLIDER_LOADING_LIMIT = 10;
  static const int FOLLOWER_ITEM_LOADING_LIMIT = 10;

  ///
  ///Login Setting
  ///
  static bool showFacebookLogin = true;
  static bool showGoogleLogin = true;
  static bool showPhoneLogin = true;

  ///
  /// Map Filter Setting
  ///
  static bool noFilterWithLocationOnMap = false;

  ///
  /// Show AdMob inside List
  ///
  static bool isShowAdMobInsideList = true;

  ///
  /// one Admob will show after item count (eg 10) in vertical list
  ///
  static int afterItemCountAdmobOnce = 3;

  ///
  /// Admob in item detail
  ///
  static bool isShowAdsInItemDetail = true;

  ///
  /// full Admob show in item detail after seeing item 5 times
  ///
  static int itemDetailViewCountForAds = 5;

  ///
  /// Razor Currency
  ///
  /// If you set true, your razor account must support multi-currency.
  static bool isRazorSupportMultiCurrency = false;
  static String defaultRazorCurrency = 'INR'; // Don't change
}
