import 'dart:async';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class PsSharedPreferences {
  PsSharedPreferences._() {
    Utils.psPrint('init PsSharePerference $hashCode');
    futureShared = SharedPreferences.getInstance();
    futureShared.then((SharedPreferences shared) {
      this.shared = shared;
      //loadUserId('Admin');
      loadValueHolder();
    });
  }

  Future<SharedPreferences> futureShared;
  SharedPreferences shared;

// Singleton instance
  static final PsSharedPreferences _singleton = PsSharedPreferences._();

  // Singleton accessor
  static PsSharedPreferences get instance => _singleton;

  final StreamController<PsValueHolder> _valueController =
      StreamController<PsValueHolder>();
  Stream<PsValueHolder> get psValueHolder => _valueController.stream;

  void loadValueHolder() {
    final String _loginUserId = shared.getString(PsConst.VALUE_HOLDER__USER_ID);

    final String _loginUserName =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME);
    final String _userIdToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY);
    final String _userNameToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY);
    final String _userEmailToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY);
    final String _userPasswordToVerify =
        shared.getString(PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY);
    final String _notiToken =
        shared.getString(PsConst.VALUE_HOLDER__NOTI_TOKEN);
    final String _isSubLocation =
        shared.getString(PsConst.VALUE_HOLDER__IS_SUB_LOCATION) ?? '';
    final String _defaultCurrency =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_CURRENCY) ?? '';
    final String _defaultCurrencyId =
        shared.getString(PsConst.VALUE_HOLDER__DEFAULT_CURRENCY_ID) ?? '';
    final bool _notiSetting =
        shared.getBool(PsConst.VALUE_HOLDER__NOTI_SETTING);
    final bool _cameraSetting =
        shared.getBool(PsConst.VALUE_HOLDER__CAMERA_SETTING) ?? false;
    final bool _isToShowIntroSlider =
        shared.getBool(PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER) ?? true;
    final String _overAllTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL);
    final String _overAllTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE);
    final String _shippingTaxLabel =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL);
    final String _shippingTaxValue =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE);
    final String _shippingId =
        shared.getString(PsConst.VALUE_HOLDER__SHIPPING_ID);
    final String _shopId = shared.getString(PsConst.VALUE_HOLDER__SHOP_ID);
    final String _messenger = shared.getString(PsConst.VALUE_HOLDER__MESSENGER);
    final String _whatsApp = shared.getString(PsConst.VALUE_HOLDER__WHATSAPP);
    final String _phone = shared.getString(PsConst.VALUE_HOLDER__PHONE);
    final String _appInfoVersionNo =
        shared.getString(PsConst.APPINFO_PREF_VERSION_NO);
    final bool _appInfoForceUpdate =
        shared.getBool(PsConst.APPINFO_PREF_FORCE_UPDATE);
    final String _appInfoForceUpdateTitle =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_TITLE);
    final String _appInfoForceUpdateMsg =
        shared.getString(PsConst.APPINFO_FORCE_UPDATE_MSG);
    final String _startDate =
        shared.getString(PsConst.VALUE_HOLDER__START_DATE);
    final String _endDate = shared.getString(PsConst.VALUE_HOLDER__END_DATE);

    final String _paypalEnabled =
        shared.getString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED);
    final String _stripeEnabled =
        shared.getString(PsConst.VALUE_HOLDER__STRIPE_ENABLED);
    final String _codEnabled =
        shared.getString(PsConst.VALUE_HOLDER__COD_ENABLED);
    final String _bankEnabled =
        shared.getString(PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE);
    final String _publishKey =
        shared.getString(PsConst.VALUE_HOLDER__PUBLISH_KEY);

    final String _standardShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE);
    final String _zoneShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE);
    final String _noShippingEnable =
        shared.getString(PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE);
    final String _locationTownshipId =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_ID) ?? '';
    final String _locationTownshipName =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_NAME) ?? '';
    final String _locationTownshipLat =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LAT) ?? '0';
    final String _locationTownshipLng =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LNG) ?? '0';
    final String _locationId =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_ID);
    final String _locationName =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_NAME);
    final String _locationLat =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_LAT);
    final String _locationLng =
        shared.getString(PsConst.VALUE_HOLDER__LOCATION_LNG);
    final int _detailOpenCount =
        shared.getInt(PsConst.VALUE_HOLDER__DETAIL_OPEN_COUNTER);
    final PsValueHolder _valueHolder = PsValueHolder(
        loginUserId: _loginUserId,
        loginUserName: _loginUserName,
        locationId: _locationId,
        locactionName: _locationName,
        locationLat: _locationLat,
        locationLng: _locationLng,
        locationTownshipId: _locationTownshipId,
        locationTownshipName: _locationTownshipName,
        locationTownshipLat: _locationTownshipLat,
        locationTownshipLng: _locationTownshipLng,
        userIdToVerify: _userIdToVerify,
        userNameToVerify: _userNameToVerify,
        userEmailToVerify: _userEmailToVerify,
        userPasswordToVerify: _userPasswordToVerify,
        deviceToken: _notiToken,
        isSubLocation: _isSubLocation,
        defaultCurrency: _defaultCurrency,
        defaultCurrencyId: _defaultCurrencyId,
        notiSetting: _notiSetting,
        isCustomCamera: _cameraSetting,
        isToShowIntroSlider: _isToShowIntroSlider,
        overAllTaxLabel: _overAllTaxLabel,
        overAllTaxValue: _overAllTaxValue,
        shippingTaxLabel: _shippingTaxLabel,
        shippingTaxValue: _shippingTaxValue,
        shopId: _shopId,
        messenger: _messenger,
        whatsApp: _whatsApp,
        phone: _phone,
        appInfoVersionNo: _appInfoVersionNo,
        appInfoForceUpdate: _appInfoForceUpdate,
        appInfoForceUpdateTitle: _appInfoForceUpdateTitle,
        appInfoForceUpdateMsg: _appInfoForceUpdateMsg,
        startDate: _startDate,
        endDate: _endDate,
        paypalEnabled: _paypalEnabled,
        stripeEnabled: _stripeEnabled,
        codEnabled: _codEnabled,
        bankEnabled: _bankEnabled,
        publishKey: _publishKey,
        shippingId: _shippingId,
        standardShippingEnable: _standardShippingEnable,
        zoneShippingEnable: _zoneShippingEnable,
        noShippingEnable: _noShippingEnable,
        detailOpenCount: _detailOpenCount);

    _valueController.add(_valueHolder);
  }

  Future<dynamic> replaceLoginUserId(String loginUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_ID, loginUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceAddedUserId(String addedUserId) async {
    await shared.setString(PsConst.VALUE_HOLDER__ADDED_USER_ID, addedUserId);

    loadValueHolder();
  }

  Future<dynamic> replaceLoginUserName(String loginUserName) async {
    await shared.setString(PsConst.VALUE_HOLDER__USER_NAME, loginUserName);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiToken(String notiToken) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_TOKEN, notiToken);

    loadValueHolder();
  }

  Future<dynamic> replaceIsSubLocation(String isSubLocation) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__IS_SUB_LOCATION, isSubLocation);

    loadValueHolder();
  }

  Future<dynamic> replaceDefaultCurrency(
      String defaultCurrencyId, String defaultCurrency) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_CURRENCY_ID, defaultCurrencyId);
    await shared.setString(
        PsConst.VALUE_HOLDER__DEFAULT_CURRENCY, defaultCurrency);

    loadValueHolder();
  }

  String getNotiMessage() {
    return shared.getString(PsConst.VALUE_HOLDER__NOTI_MESSAGE);
  }

  Future<dynamic> replaceNotiSetting(bool notiSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__NOTI_SETTING, notiSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceItemLocationTownshipData(
      String townshipId,
      String locationId,
      String locationTownshipName,
      String locationTownshipLat,
      String locationTownshipLng) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_ID, townshipId);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_ID, locationId);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_NAME, locationTownshipName);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LAT, locationTownshipLat);
    await shared.setString(
        PsConst.VALUE_HOLDER__LOCATION_TOWNSHIP_LNG, locationTownshipLng);

    loadValueHolder();
  }

  Future<dynamic> replaceCustomCameraSetting(bool cameraSetting) async {
    await shared.setBool(PsConst.VALUE_HOLDER__CAMERA_SETTING, cameraSetting);

    loadValueHolder();
  }

  Future<dynamic> replaceIsToShowIntroSlider(bool doNotShowAgain) async {
    await shared.setBool(
        PsConst.VALUE_HOLDER__SHOW_INTRO_SLIDER, doNotShowAgain);

    loadValueHolder();
  }

  Future<dynamic> replaceNotiMessage(String message) async {
    await shared.setString(PsConst.VALUE_HOLDER__NOTI_MESSAGE, message);
  }

  Future<dynamic> replaceDate(String startDate, String endDate) async {
    await shared.setString(PsConst.VALUE_HOLDER__START_DATE, startDate);
    await shared.setString(PsConst.VALUE_HOLDER__END_DATE, endDate);

    loadValueHolder();
  }

  Future<dynamic> replaceVerifyUserData(
      String userIdToVerify,
      String userNameToVerify,
      String userEmailToVerify,
      String userPasswordToVerify) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_ID_TO_VERIFY, userIdToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_NAME_TO_VERIFY, userNameToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_EMAIL_TO_VERIFY, userEmailToVerify);
    await shared.setString(
        PsConst.VALUE_HOLDER__USER_PASSWORD_TO_VERIFY, userPasswordToVerify);

    loadValueHolder();
  }

  Future<dynamic> replaceItemLocationData(String locationId,
      String locationName, String locationLat, String locationLng) async {
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_ID, locationId);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_NAME, locationName);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_LAT, locationLat);
    await shared.setString(PsConst.VALUE_HOLDER__LOCATION_LNG, locationLng);

    loadValueHolder();
  }

  Future<dynamic> replaceVersionForceUpdateData(bool appInfoForceUpdate) async {
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);

    loadValueHolder();
  }

  Future<dynamic> replaceDetailOpenCount(int count) async {
    await shared.setInt(PsConst.VALUE_HOLDER__DETAIL_OPEN_COUNTER, count);

    loadValueHolder();
  }

  Future<dynamic> replaceAppInfoData(
      String appInfoVersionNo,
      bool appInfoForceUpdate,
      String appInfoForceUpdateTitle,
      String appInfoForceUpdateMsg) async {
    await shared.setString(PsConst.APPINFO_PREF_VERSION_NO, appInfoVersionNo);
    await shared.setBool(PsConst.APPINFO_PREF_FORCE_UPDATE, appInfoForceUpdate);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_TITLE, appInfoForceUpdateTitle);
    await shared.setString(
        PsConst.APPINFO_FORCE_UPDATE_MSG, appInfoForceUpdateMsg);

    loadValueHolder();
  }

  Future<dynamic> replaceShopInfoValueHolderData(
    String overAllTaxLabel,
    String overAllTaxValue,
    String shippingTaxLabel,
    String shippingTaxValue,
    String shippingId,
    String shopId,
    String messenger,
    String whatsapp,
    String phone,
  ) async {
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_LABEL, overAllTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__OVERALL_TAX_VALUE, overAllTaxValue);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_LABEL, shippingTaxLabel);
    await shared.setString(
        PsConst.VALUE_HOLDER__SHIPPING_TAX_VALUE, shippingTaxValue);
    await shared.setString(PsConst.VALUE_HOLDER__SHIPPING_ID, shippingId);
    await shared.setString(PsConst.VALUE_HOLDER__SHOP_ID, shopId);
    await shared.setString(PsConst.VALUE_HOLDER__MESSENGER, messenger);
    await shared.setString(PsConst.VALUE_HOLDER__WHATSAPP, whatsapp);
    await shared.setString(PsConst.VALUE_HOLDER__PHONE, phone);

    loadValueHolder();
  }

  Future<dynamic> replaceCheckoutEnable(
      String paypalEnabled,
      String stripeEnabled,
      String codEnabled,
      String bankEnabled,
      String standardShippingEnable,
      String zoneShippingEnable,
      String noShippingEnable) async {
    await shared.setString(PsConst.VALUE_HOLDER__PAYPAL_ENABLED, paypalEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__STRIPE_ENABLED, stripeEnabled);
    await shared.setString(PsConst.VALUE_HOLDER__COD_ENABLED, codEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__BANK_TRANSFER_ENABLE, bankEnabled);
    await shared.setString(
        PsConst.VALUE_HOLDER__STANDART_SHIPPING_ENABLE, standardShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__ZONE_SHIPPING_ENABLE, zoneShippingEnable);
    await shared.setString(
        PsConst.VALUE_HOLDER__NO_SHIPPING_ENABLE, noShippingEnable);

    loadValueHolder();
  }

  Future<dynamic> replacePublishKey(String pubKey) async {
    await shared.setString(PsConst.VALUE_HOLDER__PUBLISH_KEY, pubKey);

    loadValueHolder();
  }
}
