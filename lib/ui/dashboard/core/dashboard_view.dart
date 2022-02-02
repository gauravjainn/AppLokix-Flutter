import 'dart:async';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/app_info/app_info_provider.dart';
import 'package:flutterbuyandsell/provider/chat/chat_history_list_provider.dart';
import 'package:flutterbuyandsell/provider/chat/user_unread_message_provider.dart';
import 'package:flutterbuyandsell/provider/common/notification_provider.dart';
import 'package:flutterbuyandsell/provider/delete_task/delete_task_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/Common/notification_repository.dart';
import 'package:flutterbuyandsell/repository/app_info_repository.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/repository/chat_history_repository.dart';
import 'package:flutterbuyandsell/repository/delete_task_repository.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/repository/user_unread_message_repository.dart';
import 'package:flutterbuyandsell/ui/category/list/category_list_view.dart';
import 'package:flutterbuyandsell/ui/chat/list/chat_list_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/dialog/share_app_dialog.dart';
// import 'package:flutterbuyandsell/ui/common/dialog/chat_noti_dialog.dart';
import 'package:flutterbuyandsell/ui/contact/contact_us_view.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
// import 'package:flutterbuyandsell/ui/common/dialog/noti_dialog.dart';
import 'package:flutterbuyandsell/ui/dashboard/home/home_dashboard_view.dart';
import 'package:flutterbuyandsell/ui/history/list/history_list_view.dart';
import 'package:flutterbuyandsell/ui/item/entry/item_entry_container.dart';
import 'package:flutterbuyandsell/ui/item/favourite/favourite_product_list_view.dart';
import 'package:flutterbuyandsell/ui/item/list_with_filter/product_list_with_filter_view.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad/paid_ad_item_list_view.dart';
import 'package:flutterbuyandsell/ui/item/reported_item/reported_item_list_view.dart';
import 'package:flutterbuyandsell/ui/language/setting/language_setting_view.dart';
import 'package:flutterbuyandsell/ui/offer/list/offer_list_view.dart';
import 'package:flutterbuyandsell/ui/item/paid_ad_product/paid_ad_product_list_view.dart';
import 'package:flutterbuyandsell/ui/search/home_item_search_view.dart';
import 'package:flutterbuyandsell/ui/terms_and_conditions/terms_and_conditions_view.dart';
import 'package:flutterbuyandsell/ui/setting/setting_view.dart';
import 'package:flutterbuyandsell/ui/user/forgot_password/forgot_password_view.dart';
import 'package:flutterbuyandsell/ui/user/blocked_user/blocked_user_list_view.dart';
import 'package:flutterbuyandsell/ui/user/login/login_container_view.dart';
import 'package:flutterbuyandsell/ui/user/login/login_view.dart';
import 'package:flutterbuyandsell/ui/user/phone/sign_in/phone_sign_in_view.dart';
import 'package:flutterbuyandsell/ui/user/phone/verify_phone/verify_phone_view.dart';
import 'package:flutterbuyandsell/ui/user/profile/profile_view.dart';
import 'package:flutterbuyandsell/ui/user/register/register_view.dart';
import 'package:flutterbuyandsell/ui/user/verify/verify_email_view.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/chat_history_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
// import 'package:flutterbuyandsell/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_logout_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_unread_message_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:provider/single_child_widget.dart';

class DashboardView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<DashboardView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  AnimationController animationController;
  AnimationController animationControllerForFab;

  Animation<double> animation;

  String appBarTitle = 'Home';
  int _currentIndex = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
  String _userId = '';
  bool isLogout = false;
  bool isFirstTime = true;
  bool isShowMessageDialog = false;
  String phoneUserName = '';
  String phoneNumber = '';
  String phoneId = '';
  UserProvider provider;
  AppInfoProvider appInfoProvider;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool isResumed = false;
static final AdRequest request = AdRequest(
    testDevices: <String>[Utils.getBannerAdUnitId()],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  InterstitialAd _interstitialAd;
  // bool _interstitialReady = false;

  void _createInterstitialAd() {
    _interstitialAd = InterstitialAd(
      adUnitId: Utils.getAdsInterstitialKey(), //InterstitialAd.testAdUnitId,
      request: request,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('$InterstitialAd loaded.');
          // _interstitialReady = true;
          _interstitialAd.show();
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$InterstitialAd failed to load: $error.');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$InterstitialAd onAdOpened.'),
        onAdClosed: (Ad ad) {
          print('$InterstitialAd closed.');
          ad.dispose();
          // _createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('$InterstitialAd onApplicationExit.'),
      ),
    )..load();
  }

  

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      isResumed = true;
      initDynamicLinks(context);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
        userUnreadMessageHolder = UserUnreadMessageParameterHolder(
            userId: valueHolder.loginUserId,
            deviceToken: valueHolder.deviceToken);
        userUnreadMessageProvider
            .userUnreadMessageCount(userUnreadMessageHolder);
      }
    } else {
      //
    }
  }

  Future<dynamic> showMessageDialog(BuildContext context) async {
    if (!Utils.isShowNotiFromToolbar() && !isShowMessageDialog) {
      
      showDialog<dynamic>(
          context: context,
          builder: (_) {
            return ChatNotiDialog(
                description:
                    Utils.getString(context, 'noti_message__new_message'),
                leftButtonText: Utils.getString(context, 'chat_noti__cancel'),
                rightButtonText: Utils.getString(context, 'chat_noti__open'),
                onAgreeTap: () {
                  updateSelectedIndexWithAnimation(
                      Utils.getString(
                          context, 'dashboard__bottom_navigation_message'),
                      PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT);
                });
          });
      isShowMessageDialog = true;
    }
  }

  Future<void> updateSelectedIndexWithAnimation(String title, int index) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }

      setState(() {
        appBarTitleName = '';
        appBarTitle = title;
        _currentIndex = index;
      });
    });
     if (index == 2) {
      if (await Utils.checkInternetConnectivity()) {
        // Utils.navigateOnUserVerificationView(_categoryProvider, context,
        //     () async {
        //   final dynamic returnData = await Navigator.pushNamed(
        //       context, RoutePaths.itemEntry,
        //       arguments: ItemEntryIntentHolder(
        //           flag: PsConst.ADD_NEW_ITEM, item: Product()));
        //   if (returnData == true) {
        //     _recentProductProvider.resetProductList(valueHolder.loginUserId,
        //         _recentProductProvider.productRecentParameterHolder);
        //   }
        // });
      } else {
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    }

  }

  Future<void> updateSelectedIndexWithAnimationUserId(
      String title, int index, String userId) async {
    await animationController.reverse().then<dynamic>((void data) {
      if (!mounted) {
        return;
      }
      if (userId != null) {
        _userId = userId;
      }
      setState(() {
        appBarTitle = title;
        _currentIndex = index;
      });
    });
  }

  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);

    animationControllerForFab = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this, value: 1);
    super.initState();
    initDynamicLinks(context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerForFab.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _interstitialAd.dispose();
    super.dispose();
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    Future<dynamic>.delayed(const Duration(seconds: 3)); //recomme
    String itemId = '';
    if (!isResumed) {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      if (data != null && data?.link != null) {
        final Uri deepLink = data?.link;
        if (deepLink != null) {
          final String path = deepLink.path;
          final List<String> pathList = path.split('=');
          itemId = pathList[1];
          final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
              productId: itemId,
              heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
              heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
          Navigator.pushNamed(context, RoutePaths.productDetail,
              arguments: holder);
        }
      }
      _createInterstitialAd();
    }

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
      final Uri deepLink = dynamicLink?.link;
      if (deepLink != null) {
        final String path = deepLink.path;
        final List<String> pathList = path.split('=');
        if (itemId == '') {
          final ProductDetailIntentHolder holder = ProductDetailIntentHolder(
              productId: pathList[1],
              heroTagImage: '-1' + pathList[1] + PsConst.HERO_TAG__IMAGE,
              heroTagTitle: '-1' + pathList[1] + PsConst.HERO_TAG__TITLE);
          Navigator.pushNamed(context, RoutePaths.productDetail,
              arguments: holder);
        }
      }
      debugPrint('DynamicLinks onLink $deepLink');
    }, onError: (OnLinkErrorException e) async {
      debugPrint('DynamicLinks onError $e');
    });
  }

  int getBottonNavigationIndex(int param) {
    int index = 0;
    switch (param) {
      case PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT:
        index = 0;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT:
        index = 1;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT:
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT:
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT:
        if (valueHolder.loginUserId != null && valueHolder.loginUserId != '') {
          index = 2;
        } else {
          index = 3;
        }
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT:
        index = 2;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT:
        index = 3;
        break;
      case PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT:
        index = 4;
        break;
      default:
        index = 0;
        break;
    }
    return index;
  }

  dynamic getIndexFromBottonNavigationIndex(int param) {
    int index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
    String title;
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    switch (param) {
      case 0:
        index = PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT;
        title = ''; //Utils.getString(context, 'app_name');
        break;
      case 1:
        index = PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT;
        title = Utils.getString(context, 'dashboard__categories');
        break;
       case 2:
        index = PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT;
        title = Utils.getString(context, 'home__bottom_app_bar_search');
        break;
      case 3:
        index = PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT;
        title =
            Utils.getString(context, 'dashboard__bottom_navigation_message');
        break;
      case 4:
        index = PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT;
        title = (psValueHolder == null ||
                psValueHolder.userIdToVerify == null ||
                psValueHolder.userIdToVerify == '')
            ? Utils.getString(context, 'home__bottom_app_bar_login')
            : Utils.getString(context, 'home__bottom_app_bar_verify_email');
        break;
      default:
        index = 0;
        title = ''; //Utils.getString(context, 'app_name');
        break;
    }
    return <dynamic>[title, index];
  }

  CategoryRepository categoryRepository;
  UserRepository userRepository;
  AppInfoRepository appInfoRepository;
  ProductRepository productRepository;
  PsValueHolder valueHolder;
  DeleteTaskRepository deleteTaskRepository;
  DeleteTaskProvider deleteTaskProvider;
  UserUnreadMessageProvider userUnreadMessageProvider;
  UserUnreadMessageRepository userUnreadMessageRepository;
  NotificationRepository notificationRepository;
  UserUnreadMessageParameterHolder userUnreadMessageHolder;
  String appBarTitleName = '';
  void changeAppBarTitle(String categoryName) {
    appBarTitleName = categoryName;
  }

  @override
  Widget build(BuildContext context) {
    categoryRepository = Provider.of<CategoryRepository>(context);
    userRepository = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    productRepository = Provider.of<ProductRepository>(context);
    deleteTaskRepository = Provider.of<DeleteTaskRepository>(context);
    userUnreadMessageRepository =
        Provider.of<UserUnreadMessageRepository>(context);
        // ChangeNotifierProvider<
        //                         //               UserUnreadMessageProvider>(
        //                         //           create: (BuildContext context) {
  //  userUnreadMessageProvider = Provider.of<UserUnreadMessageProvider>(context);
                                            
                                
    notificationRepository = Provider.of<NotificationRepository>(context);
    // final dynamic data = EasyLocalizationProvider.of(context).data;

    timeDilation = 1.0;

    if (isFirstTime) {
      appBarTitle = ''; //Utils.getString(context, 'app_name');

      Utils.subscribeToTopic(valueHolder.notiSetting ?? true);
      Utils.fcmConfigure(context, _fcm, valueHolder.loginUserId);
      isFirstTime = false;
    }

    Future<void> updateSelectedIndex(int index) async {
      setState(() {
        _currentIndex = index;
      });
    }

    dynamic callLogout(UserProvider provider,
        DeleteTaskProvider deleteTaskProvider, int index) async {
      updateSelectedIndex(index);
      await provider.replaceLoginUserId('');
      await provider.replaceLoginUserName('');
      await deleteTaskProvider.deleteTask();
      await FacebookLogin().logOut();
      await GoogleSignIn().signOut();
      await fb_auth.FirebaseAuth.instance.signOut();
    }

    Future<bool> _onWillPop() {
      
      // return  showMessageDialog(context);
      return showDialog<dynamic>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialogView(
                    description: Utils.getString(
                        context, 'home__quit_dialog_description'),
                    leftButtonText: Utils.getString(context, 'dialog__cancel'),
                    rightButtonText: Utils.getString(context, 'dialog__ok'),
                    onAgreeTap: () {
                      SystemNavigator.pop();
                    });
              }) ??
          false;
    }

    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    // return EasyLocalizationProvider(
    //   data: data,
    //   child:
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: scaffoldKey,
        drawer: Drawer(
          child: MultiProvider(
            providers: <SingleChildWidget>[
              
              ChangeNotifierProvider<UserProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    return UserProvider(
                        repo: userRepository, psValueHolder: valueHolder);
                  }),
              ChangeNotifierProvider<DeleteTaskProvider>(
                  lazy: false,
                  create: (BuildContext context) {
                    deleteTaskProvider = DeleteTaskProvider(
                        repo: deleteTaskRepository, psValueHolder: valueHolder);
                    return deleteTaskProvider;
                  }),
                  ChangeNotifierProvider<UserUnreadMessageProvider>(
                    lazy: false,
                                          create: (BuildContext context) {
                                        userUnreadMessageProvider =
                                            UserUnreadMessageProvider(
                                                repo:
                                                    userUnreadMessageRepository);
                                
                                        if (valueHolder.loginUserId != null &&
                                            valueHolder.loginUserId != '') {
                                          userUnreadMessageHolder =
                                              UserUnreadMessageParameterHolder(
                                                  userId:
                                                      valueHolder.loginUserId,
                                                  deviceToken:
                                                      valueHolder.deviceToken);
                                          userUnreadMessageProvider
                                              .userUnreadMessageCount(
                                                  userUnreadMessageHolder);
                                        }
                                        return userUnreadMessageProvider;
                                      }),
                  
                                
            ],
            child: Consumer<UserProvider>(
              builder:
                  (BuildContext context, UserProvider provider, Widget child) {
                print(provider.psValueHolder.loginUserId);
                return ListView(padding: EdgeInsets.zero, children: <Widget>[
                  const SizedBox(height: PsDimens.space52,),
                  // _DrawerHeaderWidget(),
                  // ListTile(
                  //   title: Text(
                  //       Utils.getString(context, 'home__drawer_menu_home')),
                  // ),
                  _DrawerMenuWidget(
                      icon: Icons.store,
                      title: Utils.getString(context, 'home__drawer_menu_home'),
                      index: PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.category,
                      title: Utils.getString(
                          context, 'home__drawer_menu_category'),
                      index: PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.schedule,
                      title: Utils.getString(
                          context, 'home__drawer_menu_latest_product'),
                      index: PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.trending_up,
                      title: Utils.getString(
                          context, 'home__drawer_menu_popular_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: FontAwesome5.gem,
                      title: Utils.getString(
                          context, 'home__drawer_menu_feature_item'),
                      index:
                          PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title: Text(Utils.getString(
                        context, 'home__menu_drawer_user_info')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.person,
                      title:
                          Utils.getString(context, 'home__menu_drawer_profile'),
                      index:
                          PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        title = (valueHolder == null ||
                                valueHolder.userIdToVerify == null ||
                                valueHolder.userIdToVerify == '')
                            ? Utils.getString(
                                context, 'home__menu_drawer_profile')
                            : Utils.getString(
                                context, 'home__bottom_app_bar_verify_email');
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.favorite_border,
                            title: Utils.getString(
                                context, 'home__menu_drawer_favourite'),
                            index:
                                PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                          icon: Icons.swap_horiz,
                          title: Utils.getString(
                              context, 'home__menu_drawer_paid_ad_transaction'),
                          index:
                              PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT,
                          onTap: (String title, int index) {
                            Navigator.pop(context);
                            updateSelectedIndexWithAnimation(title, index);
                          },
                        ),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.book,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_history'),
                            index: PsConst
                                .REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT, //14
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: Icons.chat_bubble,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_offers'),
                            index: PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: SimpleLineIcons.user_unfollow,
                            title: Utils.getString(
                                context, 'home__menu_drawer_user_blocked'),
                            index: PsConst
                                .REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: _DrawerMenuWidget(
                            icon: MaterialCommunityIcons.playlist_remove,
                            title: Utils.getString(
                                context, 'home__menu_drawer_reported_item'),
                            index: PsConst
                                .REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT,
                            onTap: (String title, int index) {
                              Navigator.pop(context);
                              updateSelectedIndexWithAnimation(title, index);
                            }),
                      ),
                  if (provider != null)
                    if (provider.psValueHolder.loginUserId != null &&
                        provider.psValueHolder.loginUserId != '')
                      Visibility(
                        visible: true,
                        child: ListTile(
                          leading: Icon(
                            Icons.power_settings_new,
                            color: PsColors.mainColorWithWhite,
                          ),
                          title: Text(
                            Utils.getString(
                                context, 'home__menu_drawer_logout'),
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(context,
                                          'home__logout_dialog_description'),
                                      leftButtonText: Utils.getString(context,
                                          'home__logout_dialog_cancel_button'),
                                      rightButtonText: Utils.getString(context,
                                          'home__logout_dialog_ok_button'),
                                      onAgreeTap: () async {
                                        //hide dialog
                                        Navigator.of(context).pop();

                                        await PsProgressDialog.showDialog(
                                            context);

                                        final UserLogoutHolder
                                            userlogoutHolder = UserLogoutHolder(
                                                userId: provider
                                                    .psValueHolder.loginUserId);

                                        await userUnreadMessageProvider
                                            .userDeleteUnreadMessageCount();
                                        final PsResource<ApiStatus> apiStatus =
                                            await provider.userLogout(
                                                userlogoutHolder.toMap());


                                        PsProgressDialog.dismissDialog();

                                        if (apiStatus.data != null) {
                                          callLogout(
                                              provider,
                                              deleteTaskProvider,
                                              PsConst
                                                  .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                        } else {
                                          callLogout(
                                              provider,
                                              deleteTaskProvider,
                                              PsConst
                                                  .REQUEST_CODE__MENU_HOME_FRAGMENT);
                                        }
                                      });
                                });
                          },
                        ),
                      ),
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  ListTile(
                    title:
                        Text(Utils.getString(context, 'home__menu_drawer_app')),
                  ),
                  _DrawerMenuWidget(
                      icon: Icons.g_translate,
                      title: Utils.getString(
                          context, 'home__menu_drawer_language'),
                      index: PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation('', index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.contacts,
                      title: Utils.getString(
                          context, 'home__menu_drawer_contact_us'),
                      index: PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.settings,
                      title:
                          Utils.getString(context, 'home__menu_drawer_setting'),
                      index: PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  _DrawerMenuWidget(
                      icon: Icons.info_outline,
                      title: Utils.getString(
                          context, 'privacy_policy__toolbar_name'),
                      index: PsConst
                          .REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT,
                      onTap: (String title, int index) {
                        Navigator.pop(context);
                        updateSelectedIndexWithAnimation(title, index);
                      }),
                  ListTile(
                    leading: Icon(
                      Icons.share,
                      color: PsColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_share_this_app'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog<dynamic>(
                          context: context,
                          builder: (BuildContext context) {
                            return ShareAppDialog(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            );
                          });
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_border,
                      color: PsColors.mainColorWithWhite,
                    ),
                    title: Text(
                      Utils.getString(
                          context, 'home__menu_drawer_rate_this_app'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      if (Platform.isIOS) {
                        Utils.launchAppStoreURL(
                            iOSAppId: PsConfig.iOSAppStoreId,
                            writeReview: true);
                      } else {
                        Utils.launchURL();
                      }
                    },
                  )
                ]);
              },
            ),
          ),
        ),
    appBar: AppBar(
          backgroundColor: Colors.white,
          // backgroundColor: (appBarTitle ==
          //             Utils.getString(context, 'home__verify_email') ||
          //         appBarTitle == Utils.getString(context, 'home_verify_phone'))
          //     ? PsColors.mainColor
          //     : PsColors.baseColor,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(4),
                child: Builder(
                  builder: (context) => Container(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: GestureDetector(
                            onTap: () => Scaffold.of(context).openDrawer(),
                            child: Container(
                              child: SvgPicture.asset(
                                "assets/images/icons/MenuIcon.svg",
                                height: 12,
                                width: 15,
                              ),
                            ),
                          ))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 8),
                child: Text(
                  appBarTitleName == '' ? appBarTitle : appBarTitleName,
                  style: Theme.of(context).textTheme.headline6.copyWith(
                      fontWeight: FontWeight.bold,
                      // color: (appBarTitle ==
                      //             Utils.getString(
                      //                 context, 'home__verify_email') ||
                      //         appBarTitle ==
                      //             Utils.getString(context, 'home_verify_phone'))
                      //     ? PsColors.white
                      //     : PsColors.mainColorWithWhite,
                      color: PsColors.textPrimaryColor),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: PsColors.mainDarkColor.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        right: PsDimens.space4,
                        top: PsDimens.space2,
                        bottom: PsDimens.space2),
                    child: InkWell(
                        onTap: _navigateToLocationSelector,
                        child: Row(
                          children: [
                            Text(
                              valueHolder.locactionName,
                              textAlign: TextAlign.right,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(color: PsColors.white),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: SvgPicture.asset(
                                'assets/images/icons/arrow_down.svg',
                                width: 10,
                                height: 10,
                              ),
                            )
                          ],
                        )),
                  ))
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(
              color: (appBarTitle ==
                          Utils.getString(context, 'home__verify_email') ||
                      appBarTitle ==
                          Utils.getString(context, 'home_verify_phone'))
                  ? PsColors.white
                  : PsColors.mainColorWithWhite),
          textTheme: Theme.of(context).textTheme,
          brightness: Utils.getBrightnessForAppBar(context),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: PsDimens.space16),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    RoutePaths.notiList,
                  ),
                  child: Container(
                    child: SvgPicture.asset(
                      "assets/images/icons/Notification.svg",
                      height: 18,
                      width: 18,
                    ),
                  ),
                )),
            // IconButton(
            //   icon: Icon(
            //     Icons.notifications_none,
            //     color: (appBarTitle ==
            //                 Utils.getString(context, 'home__verify_email') ||
            //             appBarTitle ==
            //                 Utils.getString(context, 'home_verify_phone'))
            //         ? PsColors.white
            //         : Theme.of(context).iconTheme.color,
            //   ),
            //   onPressed: () {
            //     Navigator.pushNamed(
            //       context,
            //       RoutePaths.notiList,
            //     );
            //   },
            // ),
          ],
        ),     bottomNavigationBar: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT || //go to profile
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT || //go to forgot password
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT || //go to register
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT || //go to email verify
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Visibility(
                visible: true,
                child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: PsDimens.space16,
                        left: PsDimens.space16,
                        right: PsDimens.space16),
                    child: Container(
                        decoration: BoxDecoration(
                          color: PsColors.mainDarkColor.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(PsDimens.space28),
                              topRight: Radius.circular(PsDimens.space28),
                              bottomLeft: Radius.circular(PsDimens.space28),
                              bottomRight: Radius.circular(PsDimens.space28)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(PsDimens.space28),
                              topRight: Radius.circular(PsDimens.space28),
                              bottomLeft: Radius.circular(PsDimens.space28),
                              bottomRight: Radius.circular(PsDimens.space28)),
                          child: BottomNavigationBar(
                            showSelectedLabels: false,
                            showUnselectedLabels: false,
                            type: BottomNavigationBarType.fixed,
                            currentIndex:
                                getBottonNavigationIndex(_currentIndex),
                            // showUnselectedLabels: true,
                            backgroundColor: PsColors.backgroundColor,
                            selectedItemColor: PsColors.mainColor,
                            elevation: 0,
                            onTap: (int index) {
                              if (valueHolder.loginUserId == null ||
                                            valueHolder.loginUserId == '') {
                              if(index>0)
                              {Navigator.pushNamed(context,RoutePaths.login_container);
                              return;}                
                                            }
                            //   if (provider == null ||
                            // provider.psValueHolder == null ||
                            // provider.psValueHolder.loginUserId == null ||
                            // provider.psValueHolder.loginUserId == '') {
                            //   if(index>1)
                            //   {Navigator.pushNamed(context,RoutePaths.login_container);
                            //   return;}
                            // }
                              final dynamic _returnValue =
                                  getIndexFromBottonNavigationIndex(index);
                              updateSelectedIndexWithAnimation(
                                  _returnValue[0], _returnValue[1]);
                            },
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  'assets/images/icons/Home.svg',
                                  width: 30,
                                  height: 30,
                                  color: PsColors.mainDividerColor,
                                ),
                                label:
                                    Utils.getString(context, 'dashboard__home'),
                              ),
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  'assets/images/icons/Categories.svg',
                                  width: 30,
                                  height: 30,
                                  color: PsColors.mainDividerColor,
                                ),
                                label: Utils.getString(context,
                                    'dashboard__bottom_navigation_catogory'),
                              ),
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  'assets/images/icons/AddAds.svg',
                                  width: 35,
                                  height: 35,
                                  color: PsColors.mainDividerColor,
                                ),
                                label: Utils.getString(
                                    context, 'home__bottom_app_bar_search'),
                              ),
                              // BottomNavigationBarItem(
                              //   icon: Container(
                              //     decoration: BoxDecoration(
                              //       color: PsColors.white,
                              //       borderRadius: const BorderRadius.all(
                              //           Radius.circular(60)),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.grey,
                              //           offset: Offset(0.0, 1.0), //(x,y)
                              //           blurRadius: 1.0,
                              //         ),
                              //       ],
                              //     ),
                              //     child: SvgPicture.asset(
                              //       'assets/images/icons/AddAds.svg',
                              //       width: 60,
                              //       height: 60,
                              //       color: PsColors.mainDividerColor,
                              //     ),
                              //   ),
                              //   label: Utils.getString(
                              //       context, 'home__bottom_app_bar_search'),
                              // ),
                              BottomNavigationBarItem(
                                icon:    SvgPicture.asset(
                                            'assets/images/icons/Chat.svg'),
                                      
          
        
                                // icon: Stack(
                                //   children: <Widget>[
                                //     Container(
                                //       width: PsDimens.space40,
                                //       margin: const EdgeInsets.only(
                                //           left: PsDimens.space8,
                                //           right: PsDimens.space8),
                                //       child: const Align(
                                //         alignment: Alignment.center,
                                //         child: Icon(
                                //           Icons.message,
                                //         ),
                                //       ),
                                //     ),
                                //     Positioned(
                                //       right: PsDimens.space4,
                                //       top: PsDimens.space1,
                                //       child: ChangeNotifierProvider<
                                //               UserUnreadMessageProvider>(
                                //           create: (BuildContext context) {
                                //         userUnreadMessageProvider =
                                //             UserUnreadMessageProvider(
                                //                 repo:
                                //                     userUnreadMessageRepository);
                                //
                                //         if (valueHolder.loginUserId != null &&
                                //             valueHolder.loginUserId != '') {
                                //           userUnreadMessageHolder =
                                //               UserUnreadMessageParameterHolder(
                                //                   userId:
                                //                       valueHolder.loginUserId,
                                //                   deviceToken:
                                //                       valueHolder.deviceToken);
                                //           userUnreadMessageProvider
                                //               .userUnreadMessageCount(
                                //                   userUnreadMessageHolder);
                                //         }
                                //         return userUnreadMessageProvider;
                                //       }, child: Consumer<
                                //                   UserUnreadMessageProvider>(
                                //               builder: (BuildContext
                                //                       context,
                                //                   UserUnreadMessageProvider
                                //                       userUnreadMessageProvider,
                                //                   Widget child) {
                                //         if (userUnreadMessageProvider != null &&
                                //             userUnreadMessageProvider
                                //                     .userUnreadMessage !=
                                //                 null &&
                                //             userUnreadMessageProvider
                                //                     .userUnreadMessage.data !=
                                //                 null) {
                                //           final int sellerCount = int.parse(
                                //               userUnreadMessageProvider
                                //                   .userUnreadMessage
                                //                   .data
                                //                   .sellerUnreadCount);
                                //           final int buyerCount = int.parse(
                                //               userUnreadMessageProvider
                                //                   .userUnreadMessage
                                //                   .data
                                //                   .buyerUnreadCount);
                                //           userUnreadMessageProvider
                                //                   .totalUnreadCount =
                                //               sellerCount + buyerCount;
                                //           if (userUnreadMessageProvider
                                //                   .totalUnreadCount ==
                                //               0) {
                                //             return Container();
                                //           } else {
                                //             if (userUnreadMessageProvider
                                //                     .totalUnreadCount >
                                //                 0) {
                                //               Future<dynamic>.delayed(
                                //                   Duration.zero,
                                //                   () => showMessageDialog(
                                //                       context));
                                //             }
                                //             return Container(
                                //               width: PsDimens.space20,
                                //               height: PsDimens.space20,
                                //               decoration: BoxDecoration(
                                //                 shape: BoxShape.circle,
                                //                 color: PsColors.mainColor,
                                //               ),
                                //               child: Align(
                                //                 alignment: Alignment.center,
                                //                 child: Text(
                                //                   userUnreadMessageProvider
                                //                               .totalUnreadCount >
                                //                           9
                                //                       ? '9+'
                                //                       : userUnreadMessageProvider
                                //                           .totalUnreadCount
                                //                           .toString(),
                                //                   textAlign: TextAlign.left,
                                //                   style: Theme.of(context)
                                //                       .textTheme
                                //                       .bodyText2
                                //                       .copyWith(
                                //                           color:
                                //                               PsColors.white),
                                //                   maxLines: 1,
                                //                 ),
                                //               ),
                                //             );
                                //           }
                                //         } else {
                                //           return Container();
                                //         }
                                //       })),
                                //     ),
                                //   ],
                                // ),
                                
                                label: Utils.getString(context,
                                    'dashboard__bottom_navigation_message'),
                              ),
                              BottomNavigationBarItem(
                                icon: SvgPicture.asset(
                                  'assets/images/icons/Profil.svg',
                                  width: 30,
                                  height: 30,
                                  color: PsColors.mainDividerColor,
                                ),
                                label: Utils.getString(
                                    context, 'home__bottom_app_bar_login'),
                              ),
                            ],
                          ),
                        )))
                // ],
                // ),
                ): null,
        floatingActionButton: _currentIndex ==
                    PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT ||
                _currentIndex ==
                    PsConst
                        .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                _currentIndex ==
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
            ? Container(
                height: 65.0,
                width: 65.0,
                child: FittedBox(
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: PsColors.mainColor.withOpacity(0.3),
                              offset: const Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Container()),
                ),
              )
            : null,
        body: ChangeNotifierProvider<NotificationProvider>(
          lazy: false,
          create: (BuildContext context) {
            final NotificationProvider provider = NotificationProvider(
                repo: notificationRepository, psValueHolder: valueHolder);
            if (provider.psValueHolder.deviceToken == null ||
                provider.psValueHolder.deviceToken == '') {
              final FirebaseMessaging _fcm = FirebaseMessaging.instance;
              Utils.saveDeviceToken(_fcm, provider);
            } else {
              print(
                  'Notification Token is already registered. Notification Setting : true.');
            }
            return provider;
          },
          child: Builder(
            builder: (BuildContext context) {
              if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_CATEGORY_FRAGMENT) {
                return CategoryListView();
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      provider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);

                      return provider;
                    },
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                      if (provider == null ||
                          provider.psValueHolder.userIdToVerify == null ||
                          provider.psValueHolder.userIdToVerify == '') {
                        if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '') {
                              // Navigator.pushReplacementNamed(context, RoutePaths.login_container);
                          return _CallLoginWidget(
                              currentIndex: _currentIndex,
                              animationController: animationController,
                              animation: animation,
                              updateCurrentIndex: (String title, int index) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                              },
                              updateUserCurrentIndex:
                                  (String title, int index, String userId) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                                if (userId != null) {
                                  _userId = userId;
                                  provider.psValueHolder.loginUserId = userId;
                                }
                              });
                        } else {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                            callLogoutCallBack: (String userId) {
                              callLogout(provider, deleteTaskProvider,
                                  PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                            },
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    }));
              }
              if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SEARCH_FRAGMENT) {
                // 2nd Way
                  if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '') {
                              // Navigator.pushReplacementNamed(context, RoutePaths.login_container);
                          return _CallLoginWidget(
                              currentIndex: _currentIndex,
                              animationController: animationController,
                              animation: animation,
                              updateCurrentIndex: (String title, int index) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                              },
                              updateUserCurrentIndex:
                                  (String title, int index, String userId) {
                                if (index != null) {
                                  updateSelectedIndexWithAnimation(
                                      title, index);
                                }
                                if (userId != null) {
                                  _userId = userId;
                                  provider.psValueHolder.loginUserId = userId;
                                }
                              });
                        }

                return 
                // CustomScrollView(
                //   scrollDirection: Axis.vertical,
                //   slivers: <Widget>[
                    ItemEntryContainerView(
                              flag: PsConst.ADD_NEW_ITEM, item: Product());
                //     HomeItemSearchView(
                //         animationController: animationController,
                //         animation: animation,
                //         productParameterHolder:
                //             ProductParameterHolder().getLatestParameterHolder())
                //   ],
                // );
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColor,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                      Widget>[
                    PhoneSignInView(
                        animationController: animationController,
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        },
                        phoneSignInSelected:
                            (String name, String phoneNo, String verifyId) {
                          phoneUserName = name;
                          phoneNumber = phoneNo;
                          phoneId = verifyId;
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_verify_phone'),
                                PsConst
                                    .REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT);
                          }
                          if (_currentIndex ==
                              PsConst
                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                            updateSelectedIndexWithAnimation(
                                Utils.getString(context, 'home_verify_phone'),
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT);
                          }
                        })
                  ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
                return _CallVerifyPhoneWidget(
                    userName: phoneUserName,
                    phoneNumber: phoneNumber,
                    phoneId: phoneId,
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT) {
                return ProfileView(
                  scaffoldKey: scaffoldKey,
                  animationController: animationController,
                  flag: _currentIndex,
                  userId: _userId,
                  callLogoutCallBack: (String userId) {
                    callLogout(provider, deleteTaskProvider,
                        PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                  },
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CATEGORY_FRAGMENT) {
                return CategoryListView();
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LATEST_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('1'),
                  changeAppBarTitle: changeAppBarTitle,
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getLatestParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_DISCOUNT_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('2'),
                  changeAppBarTitle: changeAppBarTitle,
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getRecentParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRENDING_PRODUCT_FRAGMENT) {
                return ProductListWithFilterView(
                  key: const Key('3'),
                  changeAppBarTitle: changeAppBarTitle,
                  animationController: animationController,
                  productParameterHolder:
                      ProductParameterHolder().getPopularParameterHolder(),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FEATURED_PRODUCT_FRAGMENT) {
                return PaidAdProductListView(
                  key: const Key('4'),
                  animationController: animationController,
                );
              } else if (_currentIndex ==
                      PsConst
                          .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColorWithBlack,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(
                      scrollDirection: Axis.vertical,
                      slivers: <Widget>[
                        ForgotPasswordView(
                          animationController: animationController,
                          goToLoginSelected: () {
                            animationController
                                .reverse()
                                .then<dynamic>((void data) {
                              if (!mounted) {
                                return;
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                              }
                              if (_currentIndex ==
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT) {
                                updateSelectedIndexWithAnimation(
                                    Utils.getString(context, 'home_login'),
                                    PsConst
                                        .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                              }
                            });
                          },
                        )
                      ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                return Stack(children: <Widget>[
                  Container(
                    color: PsColors.mainLightColorWithBlack,
                    width: double.infinity,
                    height: double.maxFinite,
                  ),
                  CustomScrollView(scrollDirection: Axis.vertical, slivers: <
                      Widget>[
                    RegisterView(
                        animationController: animationController,
                        onRegisterSelected: (User user) {
                          _userId = user.userId;
                          // widget.provider.psValueHolder.loginUserId = userId;
                          if (user.status == PsConst.ONE) {
                            updateSelectedIndexWithAnimationUserId(
                                Utils.getString(
                                    context, 'home__menu_drawer_profile'),
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                user.userId);
                          } else {
                            if (_currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(
                                      context, 'home__verify_email'),
                                  PsConst
                                      .REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT);
                            } else if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(
                                      context, 'home__verify_email'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT);
                            } else {
                              updateSelectedIndexWithAnimationUserId(
                                  Utils.getString(
                                      context, 'home__menu_drawer_profile'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                                  user.userId);
                            }
                          }
                        },
                        goToLoginSelected: () {
                          animationController
                              .reverse()
                              .then<dynamic>((void data) {
                            if (!mounted) {
                              return;
                            }
                            if (_currentIndex ==
                                PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT);
                            }
                            if (_currentIndex ==
                                PsConst
                                    .REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT) {
                              updateSelectedIndexWithAnimation(
                                  Utils.getString(context, 'home_login'),
                                  PsConst
                                      .REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT);
                            }
                          });
                        })
                  ])
                ]);
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT ||
                  _currentIndex ==
                      PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
                return _CallVerifyEmailWidget(
                    animationController: animationController,
                    animation: animation,
                    currentIndex: _currentIndex,
                    userId: _userId,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) async {
                      if (userId != null) {
                        _userId = userId;
                      }
                      setState(() {
                        appBarTitle = title;
                        _currentIndex = index;
                      });
                    });
              } else if (_currentIndex ==
                      PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT ||
                  _currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                    // Navigator.pushReplacementNamed(context, RoutePaths.login_container);
                return _CallLoginWidget(
                    currentIndex: _currentIndex,
                    animationController: animationController,
                    animation: animation,
                    updateCurrentIndex: (String title, int index) {
                      updateSelectedIndexWithAnimation(title, index);
                    },
                    updateUserCurrentIndex:
                        (String title, int index, String userId) {
                      setState(() {
                        if (index != null) {
                          appBarTitle = title;
                          _currentIndex = index;
                        }
                      });
                      if (userId != null) {
                        _userId = userId;
                      }
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                return ChangeNotifierProvider<UserProvider>(
                    lazy: false,
                    create: (BuildContext context) {
                      final UserProvider provider = UserProvider(
                          repo: userRepository, psValueHolder: valueHolder);

                      return provider;
                    },
                    child: Consumer<UserProvider>(builder:
                        (BuildContext context, UserProvider provider,
                            Widget child) {
                      if (provider == null ||
                          provider.psValueHolder.userIdToVerify == null ||
                          provider.psValueHolder.userIdToVerify == '') {
                        if (provider == null ||
                            provider.psValueHolder == null ||
                            provider.psValueHolder.loginUserId == null ||
                            provider.psValueHolder.loginUserId == '') {
                          return Stack(
                            children: <Widget>[
                              Container(
                                color: PsColors.mainLightColorWithBlack,
                                width: double.infinity,
                                height: double.maxFinite,
                              ),
                              CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  slivers: <Widget>[
                                    LoginView(
                                      animationController: animationController,
                                      animation: animation,
                                      onGoogleSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      },
                                      onFbSignInSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                        });
                                        _userId = userId;
                                        provider.psValueHolder.loginUserId =
                                            userId;
                                      },
                                      onPhoneSignInSelected: () {
                                        if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
                                        } else if (_currentIndex ==
                                            PsConst
                                                .REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        } else {
                                          updateSelectedIndexWithAnimation(
                                              Utils.getString(
                                                  context, 'home_phone_signin'),
                                              PsConst
                                                  .REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
                                        }
                                      },
                                      onProfileSelected: (String userId) {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT;
                                          _userId = userId;
                                          provider.psValueHolder.loginUserId =
                                              userId;
                                        });
                                      },
                                      onForgotPasswordSelected: () {
                                        setState(() {
                                          _currentIndex = PsConst
                                              .REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT;
                                          appBarTitle = Utils.getString(
                                              context, 'home__forgot_password');
                                        });
                                      },
                                      onSignInSelected: () {
                                        updateSelectedIndexWithAnimation(
                                            Utils.getString(
                                                context, 'home__register'),
                                            PsConst
                                                .REQUEST_CODE__MENU_REGISTER_FRAGMENT);
                                      },
                                    ),
                                  ])
                            ],
                          );
                        } else {
                          return ProfileView(
                            scaffoldKey: scaffoldKey,
                            animationController: animationController,
                            flag: _currentIndex,
                            callLogoutCallBack: (String userId) {
                              callLogout(provider, deleteTaskProvider,
                                  PsConst.REQUEST_CODE__MENU_HOME_FRAGMENT);
                            },
                          );
                        }
                      } else {
                        return _CallVerifyEmailWidget(
                            animationController: animationController,
                            animation: animation,
                            currentIndex: _currentIndex,
                            userId: _userId,
                            updateCurrentIndex: (String title, int index) {
                              updateSelectedIndexWithAnimation(title, index);
                            },
                            updateUserCurrentIndex:
                                (String title, int index, String userId) async {
                              if (userId != null) {
                                _userId = userId;
                                provider.psValueHolder.loginUserId = userId;
                              }
                              setState(() {
                                appBarTitle = title;
                                _currentIndex = index;
                              });
                            });
                      }
                    }));
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_FAVOURITE_FRAGMENT) {
                return FavouriteProductListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TRANSACTION_FRAGMENT) {
                return PaidAdItemListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_USER_HISTORY_FRAGMENT) {
                return HistoryListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_OFFER_FRAGMENT) {
                return OfferListView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_BLOCKED_USER_FRAGMENT) {
                return BlockedUserListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_REPORTED_ITEM_FRAGMENT) {
                return ReportedItemListView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT) {
                return LanguageSettingView(
                    animationController: animationController,
                    languageIsChanged: () {
                      // _currentIndex = PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT;
                      // appBarTitle = Utils.getString(
                      //     context, 'home__menu_drawer_language');

                      //updateSelectedIndexWithAnimation(
                      //  '', PsConst.REQUEST_CODE__MENU_LANGUAGE_FRAGMENT);
                      // setState(() {});
                    });
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_CONTACT_US_FRAGMENT) {
                return ContactUsView(animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SETTING_FRAGMENT) {
                return Container(
                  color: PsColors.coreBackgroundColor,
                  height: double.infinity,
                  child: SettingView(
                    animationController: animationController,
                  ),
                );
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__MENU_TERMS_AND_CONDITION_FRAGMENT) {
                return TermsAndConditionsView(
                    animationController: animationController);
              } else if (_currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_MESSAGE_FRAGMENT) {
                if (valueHolder.loginUserId != null &&
                    valueHolder.loginUserId != '') {
                  return ChatListView(
                    animationController: animationController,
                  );
                } else {
                  // Navigator.pushReplacementNamed(context, RoutePaths.login_container);
                  return _CallLoginWidget(
                      currentIndex: _currentIndex,
                      animationController: animationController,
                      animation: animation,
                      updateCurrentIndex: (String title, int index) {
                        updateSelectedIndexWithAnimation(title, index);
                      },
                      updateUserCurrentIndex:
                          (String title, int index, String userId) {
                        setState(() {
                          if (index != null) {
                            appBarTitle = title;
                            _currentIndex = index;
                          }
                        });
                        if (userId != null) {
                          _userId = userId;
                        }
                      });
                }
              } else {
                animationController.forward();
                return HomeDashboardViewWidget(
                  _scrollController,
                  animationController,
                  animationControllerForFab,
                  context,
                  //      (String payload) {
                  //   return showDialog<dynamic>(
                  //     context: context,
                  //     builder: (_) {
                  //       return NotiDialog(message: '$payload');
                  //     },
                  //   );
                  // }, (String payload,
                  //         String sellerId,
                  //         String buyerId,
                  //         String senderName,
                  //         String senderProflePhoto,
                  //         String itemId,
                  //         String action) {
                  //   return showDialog<dynamic>(
                  //     context: context,
                  //     builder: (_) {
                  //       return ChatNotiDialog(
                  //           description: '$payload',
                  //           leftButtonText:
                  //               Utils.getString(context, 'dialog__cancel'),
                  //           rightButtonText:
                  //               Utils.getString(context, 'chat_noti__open'),
                  //           onAgreeTap: () {
                  //             _navigateToChat(sellerId, buyerId, senderName,
                  //                 senderProflePhoto, itemId, action);
                  //           });
                  //     },
                  //   );
                  // }
                );
              }
            },
          ),
        ),
      ),
    );
  }
  void _navigateToLocationSelector() {
    Navigator.pushNamed(context, RoutePaths.itemLocationList);
  }

  int _getCount(ChatHistoryListProvider provider) {
    int total=0;
    
    provider.chatHistoryList.data.forEach((element) {
      // print(element.buyerUnreadCount  );
      print(element.sellerUnreadCount  );
      total+=int.tryParse(element?.buyerUnreadCount??0 );
          });
  return total;
  }

}

class _CallLoginWidget extends StatelessWidget {
  const _CallLoginWidget(
      {@required this.animationController,
      @required this.animation,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.currentIndex});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: PsColors.mainLightColorWithBlack,
          width: double.infinity,
          height: double.maxFinite,
        ),
        CustomScrollView(scrollDirection: Axis.vertical, slivers: <Widget>[
          LoginView(
            animationController: animationController,
            animation: animation,
            onGoogleSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onFbSignInSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onPhoneSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__MENU_PHONE_SIGNIN_FRAGMENT);
              } else if (currentIndex ==
                  PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home_phone_signin'),
                    PsConst.REQUEST_CODE__DASHBOARD_PHONE_SIGNIN_FRAGMENT);
              }
            },
            onProfileSelected: (String userId) {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                    userId);
              } else {
                updateUserCurrentIndex(
                    Utils.getString(context, 'home__menu_drawer_profile'),
                    PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                    userId);
              }
            },
            onForgotPasswordSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__MENU_FORGOT_PASSWORD_FRAGMENT);
              } else {
                updateCurrentIndex(
                    Utils.getString(context, 'home__forgot_password'),
                    PsConst.REQUEST_CODE__DASHBOARD_FORGOT_PASSWORD_FRAGMENT);
              }
            },
            onSignInSelected: () {
              if (currentIndex == PsConst.REQUEST_CODE__MENU_LOGIN_FRAGMENT) {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
              } else {
                updateCurrentIndex(Utils.getString(context, 'home__register'),
                    PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
              }
            },
          ),
        ])
      ],
    );
  }
}

class _CallVerifyPhoneWidget extends StatelessWidget {
  const _CallVerifyPhoneWidget(
      {this.userName,
      this.phoneNumber,
      this.phoneId,
      @required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex});

  final String userName;
  final String phoneNumber;
  final String phoneId;
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyPhoneView(
          userName: userName,
          phoneNumber: phoneNumber,
          phoneId: phoneId,
          animationController: animationController,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              //PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_PHONE_VERIFY_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _CallVerifyEmailWidget extends StatelessWidget {
  const _CallVerifyEmailWidget(
      {@required this.updateCurrentIndex,
      @required this.updateUserCurrentIndex,
      @required this.animationController,
      @required this.animation,
      @required this.currentIndex,
      @required this.userId});
  final Function updateCurrentIndex;
  final Function updateUserCurrentIndex;
  final int currentIndex;
  final AnimationController animationController;
  final Animation<double> animation;
  final String userId;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: VerifyEmailView(
          animationController: animationController,
          userId: userId,
          onProfileSelected: (String userId) {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__MENU_USER_PROFILE_FRAGMENT,
                  userId);
            } else {
              //PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT
              updateUserCurrentIndex(
                  Utils.getString(context, 'home__menu_drawer_profile'),
                  PsConst.REQUEST_CODE__DASHBOARD_USER_PROFILE_FRAGMENT,
                  userId);
            }
          },
          onSignInSelected: () {
            if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_VERIFY_EMAIL_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__DASHBOARD_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__DASHBOARD_REGISTER_FRAGMENT);
            } else if (currentIndex ==
                PsConst.REQUEST_CODE__MENU_SELECT_WHICH_USER_FRAGMENT) {
              updateCurrentIndex(Utils.getString(context, 'home__register'),
                  PsConst.REQUEST_CODE__MENU_REGISTER_FRAGMENT);
            }
          },
        ));
  }
}

class _DrawerMenuWidget extends StatefulWidget {
  const _DrawerMenuWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.onTap,
    @required this.index,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Function onTap;
  final int index;

  @override
  __DrawerMenuWidgetState createState() => __DrawerMenuWidgetState();
}

class __DrawerMenuWidgetState extends State<_DrawerMenuWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(widget.icon, color: PsColors.mainColorWithWhite),
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        onTap: () {
          widget.onTap(widget.title, widget.index);
        });
  }
}

class _DrawerHeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/flutter_buy_and_sell_logo.png',
            width: PsDimens.space100,
            height: PsDimens.space72,
          ),
          const SizedBox(
            height: PsDimens.space8,
          ),
          Text(
            Utils.getString(context, 'app_name'),
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: PsColors.white),
          ),
        ],
      ),
      decoration: BoxDecoration(color: PsColors.mainColor),
    );
  }
}
