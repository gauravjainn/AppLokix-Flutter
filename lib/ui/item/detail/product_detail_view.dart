import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterbuyandsell/api/common/ps_resource.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/about_us/about_us_provider.dart';
import 'package:flutterbuyandsell/provider/app_info/app_info_provider.dart';
import 'package:flutterbuyandsell/provider/history/history_provider.dart';
import 'package:flutterbuyandsell/provider/product/favourite_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/mark_sold_out_item_provider.dart';
import 'package:flutterbuyandsell/provider/product/product_provider.dart';
import 'package:flutterbuyandsell/provider/product/touch_count_provider.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/about_us_repository.dart';
import 'package:flutterbuyandsell/repository/app_info_repository.dart';
import 'package:flutterbuyandsell/repository/history_repsitory.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_multi_provider.dart';
import 'package:flutterbuyandsell/ui/common/dialog/confirm_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_back_button_with_circle_bg_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/ui/common/ps_hero.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/getting_this_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/location_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/safety_tips_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/seller_info_tile_view.dart';
import 'package:flutterbuyandsell/ui/item/detail/views/static_tile_view.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/api_status.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/favourite_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/chat_history_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/item_entry_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/mark_sold_out_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/touch_count_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_block_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_delete_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/user_report_item_parameter_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutterbuyandsell/ui/common/dialog/choose_payment_type_dialog.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView(
      {@required this.productId,
      @required this.heroTagImage,
      @required this.heroTagTitle});

  final String productId;
  final String heroTagImage;
  final String heroTagTitle;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailView>
    with SingleTickerProviderStateMixin {
  ProductRepository productRepo;
  HistoryRepository historyRepo;
  HistoryProvider historyProvider;
  ItemDetailProvider itemDetailProvider;
  TouchCountProvider touchCountProvider;
  AppInfoProvider appInfoProvider;
  AppInfoRepository appInfoRepository;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  AboutUsRepository aboutUsRepo;
  AboutUsProvider aboutUsProvider;
  MarkSoldOutItemProvider markSoldOutItemProvider;
  MarkSoldOutItemParameterHolder markSoldOutItemHolder;
  UserProvider userProvider;
  UserRepository userRepo;
  bool isReadyToShowAppBarIcons = false;
  bool isAddedToHistory = false;

  static final AdRequest request = AdRequest(
    testDevices: <String>[Utils.getBannerAdUnitId()],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  InterstitialAd _interstitialAd;
  // bool _interstitialReady = false;

  void createInterstitialAd() {
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
          // createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('$InterstitialAd onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isReadyToShowAppBarIcons) {
      Timer(const Duration(milliseconds: 800), () {
        setState(() {
          isReadyToShowAppBarIcons = true;
        });
      });
    }
    psValueHolder = Provider.of<PsValueHolder>(context);

    historyRepo = Provider.of<HistoryRepository>(context);
    productRepo = Provider.of<ProductRepository>(context);
    aboutUsRepo = Provider.of<AboutUsRepository>(context);
    userRepo = Provider.of<UserRepository>(context);
    appInfoRepository = Provider.of<AppInfoRepository>(context);
    markSoldOutItemHolder =
        MarkSoldOutItemParameterHolder().markSoldOutItemHolder();
    markSoldOutItemHolder.itemId = widget.productId;

    return PsWidgetWithMultiProvider(
        child: MultiProvider(
            providers: <SingleChildWidget>[
          ChangeNotifierProvider<ItemDetailProvider>(
            lazy: false,
            create: (BuildContext context) {
              itemDetailProvider = ItemDetailProvider(
                  repo: productRepo, psValueHolder: psValueHolder);

              final String loginUserId = Utils.checkUserLoginId(psValueHolder);
              itemDetailProvider.loadProduct(widget.productId, loginUserId);

              return itemDetailProvider;
            },
          ),
          ChangeNotifierProvider<HistoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              historyProvider = HistoryProvider(repo: historyRepo);
              return historyProvider;
            },
          ),
          ChangeNotifierProvider<AboutUsProvider>(
            lazy: false,
            create: (BuildContext context) {
              aboutUsProvider = AboutUsProvider(
                  repo: aboutUsRepo, psValueHolder: psValueHolder);
              aboutUsProvider.loadAboutUsList();
              return aboutUsProvider;
            },
          ),
          ChangeNotifierProvider<MarkSoldOutItemProvider>(
            lazy: false,
            create: (BuildContext context) {
              markSoldOutItemProvider =
                  MarkSoldOutItemProvider(repo: productRepo);

              return markSoldOutItemProvider;
            },
          ),
          ChangeNotifierProvider<UserProvider>(
            lazy: false,
            create: (BuildContext context) {
              userProvider =
                  UserProvider(repo: userRepo, psValueHolder: psValueHolder);
              return userProvider;
            },
          ),
          ChangeNotifierProvider<TouchCountProvider>(
            lazy: false,
            create: (BuildContext context) {
              touchCountProvider = TouchCountProvider(
                  repo: productRepo, psValueHolder: psValueHolder);
              final String loginUserId = Utils.checkUserLoginId(psValueHolder);

              final TouchCountParameterHolder touchCountParameterHolder =
                  TouchCountParameterHolder(
                      itemId: widget.productId, userId: loginUserId);
              touchCountProvider
                  .postTouchCount(touchCountParameterHolder.toMap());
              return touchCountProvider;
            },
          ),
          ChangeNotifierProvider<AppInfoProvider>(
              lazy: false,
              create: (BuildContext context) {
                appInfoProvider = AppInfoProvider(
                    repo: appInfoRepository, psValueHolder: psValueHolder);

                appInfoProvider.loadDeleteHistorywithNotifier();

                return appInfoProvider;
              }),
        ],
            child: Consumer<ItemDetailProvider>(
              builder: (BuildContext context, ItemDetailProvider provider,
                  Widget child) {
                if (provider.itemDetail != null &&
                    provider.itemDetail.data != null &&
                    markSoldOutItemProvider != null &&
                    userProvider != null) {
                  if (!isAddedToHistory) {
                    ///
                    /// Add to History
                    ///
                    historyProvider.addHistoryList(provider.itemDetail.data);
                    isAddedToHistory = true;

                    if (psValueHolder != null &&
                        psValueHolder.detailOpenCount != null &&
                        psValueHolder.detailOpenCount >
                            PsConfig.itemDetailViewCountForAds &&
                        PsConfig.isShowAdsInItemDetail) {
                      createInterstitialAd();
                      itemDetailProvider.replaceDetailOpenCount(0);
                      // if (_interstitialReady) {
                      //   _interstitialAd.show();
                      //   _interstitialReady = false;
                      // }
                    } else if (psValueHolder != null) {
                      if (psValueHolder.detailOpenCount == null) {
                        itemDetailProvider.replaceDetailOpenCount(1);
                      } else {
                        itemDetailProvider.replaceDetailOpenCount(
                            ++psValueHolder.detailOpenCount);
                      }
                    }
                  }

                  return Consumer<MarkSoldOutItemProvider>(builder:
                      (BuildContext context,
                          MarkSoldOutItemProvider markSoldOutItemProvider,
                          Widget child) {
                    return Stack(
                      children: <Widget>[
                        CustomScrollView(slivers: <Widget>[
                          SliverAppBar(
                            
                            automaticallyImplyLeading: true,
                            brightness: Utils.getBrightnessForAppBar(context),
                            expandedHeight: PsDimens.space300,
                            iconTheme: Theme.of(context)
                                .iconTheme
                                .copyWith(color: PsColors.mainColorWithWhite),
                            leading: PsBackButtonWithCircleBgWidget(
                                isReadyToShow: isReadyToShowAppBarIcons),
                            floating: false,
                            pinned: false,
                            stretch: true,
                            actions: <Widget>[
                              Visibility(
                                visible: isReadyToShowAppBarIcons,
                                child: _PopUpMenuWidget(
                                    context: context,
                                    itemDetailProvider: provider,
                                    userProvider: userProvider,
                                    itemId: provider.itemDetail.data.id,
                                    itemUserId:
                                        provider.itemDetail.data.user.userId,
                                    addedUserId:
                                        provider.itemDetail.data.addedUserId,
                                    reportedUserId: psValueHolder.loginUserId,
                                    loginUserId: psValueHolder.loginUserId,
                                    itemTitle: provider.itemDetail.data.title,
                                    itemImage: provider
                                        .itemDetail.data.defaultPhoto.imgPath),
                              ),
                            ],
                            backgroundColor: PsColors.mainColorWithWhite,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: PsColors.backgroundColor,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: <Widget>[
                                    PsNetworkImage(
                                      photoKey: widget.heroTagImage,
                                      defaultPhoto:
                                          provider.itemDetail.data.defaultPhoto,
                                      width: double.infinity,
                                      height: PsDimens.space300,
                                      boxfit: BoxFit.cover,
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryGrid,
                                            arguments:
                                                provider.itemDetail.data);
                                      },
                                    ),
                                    if (provider.itemDetail.data.addedUserId ==
                                            provider
                                                .psValueHolder.loginUserId ||
                                        provider.itemDetail.data.addedUserId !=
                                            provider.psValueHolder.loginUserId)
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: PsDimens.space12,
                                            right: PsDimens.space12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSPROGRESS &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color:
                                                        PsColors.paidAdsColor),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_progress'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADS_REJECT &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.red),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_rejected'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst
                                                        .ADS_WAITING_FOR_APPROVAL &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.yellow),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_waiting'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSFINISHED &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId) ...<
                                                Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: PsColors.black),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_completed'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            ] else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSNOTYETSTART &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId) ...<
                                                Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.yellow),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_is_not_yet_start'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            ] else ...<Widget>[
                                              Container()
                                            ],
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: PsDimens.space4,
                                                  bottom: PsDimens.space4),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  if (provider.itemDetail.data
                                                          .isSoldOut ==
                                                      '1')
                                                    // Container(
                                                    //   decoration: BoxDecoration(
                                                    //       borderRadius:
                                                    //           BorderRadius
                                                    //               .circular(
                                                    //                   PsDimens
                                                    //                       .space4),
                                                    //       color:
                                                    //           PsColors.mainColor),
                                                    //   padding:
                                                    //       const EdgeInsets.all(
                                                    //           PsDimens.space12),
                                                    //   child: Text(
                                                    //     Utils.getString(context,
                                                    //         'dashboard__sold_out'),
                                                    //     style: Theme.of(context)
                                                    //         .textTheme
                                                    //         .bodyText2
                                                    //         .copyWith(
                                                    //             color: PsColors
                                                    //                 .white),
                                                    //   ),
                                                    // ),
                                                    // Positioned(
                                                    //     bottom: 0,
                                                    //     child:
                                                    provider.itemDetail.data
                                                                .isSoldOut ==
                                                            '1'
                                                        ? Expanded(
                                                            child: Container(
                                                              margin: const EdgeInsets
                                                                      .only(
                                                                  right: PsDimens
                                                                      .space4),
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                        .only(
                                                                    left: PsDimens
                                                                        .space12,
                                                                    right: PsDimens
                                                                        .space12),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    Utils.getString(
                                                                        context,
                                                                        'dashboard__sold_out'),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyText2
                                                                        .copyWith(
                                                                            color:
                                                                                PsColors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          PsDimens
                                                                              .space4),
                                                                  color: PsColors
                                                                      .soldOutUIColor),
                                                            ),
                                                          )
                                                        : Container()
                                                  //   )
                                                  // ],
                                                  // )
                                                  else if (provider.itemDetail
                                                          .data.addedUserId ==
                                                      provider.psValueHolder
                                                          .loginUserId)
                                                    Expanded(
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog<dynamic>(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return ConfirmDialogView(
                                                                    description:
                                                                        Utils.getString(
                                                                            context,
                                                                            'item_detail__sold_out_item'),
                                                                    leftButtonText:
                                                                        Utils.getString(
                                                                            context,
                                                                            'item_detail__sold_out_dialog_cancel_button'),
                                                                    rightButtonText:
                                                                        Utils.getString(
                                                                            context,
                                                                            'item_detail__sold_out_dialog_ok_button'),
                                                                    onAgreeTap:
                                                                        () async {
                                                                      await PsProgressDialog
                                                                          .showDialog(
                                                                              context);
                                                                      await await markSoldOutItemProvider.loadmarkSoldOutItem(
                                                                          psValueHolder
                                                                              .loginUserId,
                                                                          markSoldOutItemHolder);
                                                                      PsProgressDialog
                                                                          .dismissDialog();
                                                                      if (markSoldOutItemProvider.markSoldOutItem !=
                                                                              null &&
                                                                          markSoldOutItemProvider.markSoldOutItem.data !=
                                                                              null) {
                                                                        setState(
                                                                            () {
                                                                          provider
                                                                              .itemDetail
                                                                              .data
                                                                              .isSoldOut = markSoldOutItemProvider.markSoldOutItem.data.isSoldOut;
                                                                        });
                                                                      }

                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    });
                                                              });
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: PsDimens
                                                                      .space4),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          PsDimens
                                                                              .space4),
                                                              color: PsColors
                                                                  .mainColor),
                                                          padding:
                                                              const EdgeInsets
                                                                      .all(
                                                                  PsDimens
                                                                      .space12),
                                                          child: Text(
                                                            Utils.getString(
                                                                context,
                                                                'item_detail__mark_sold'),
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText2
                                                                .copyWith(
                                                                    color: PsColors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  InkWell(
                                                    child: Container(
                                                      color:
                                                              Colors.white30
                                                      ,padding:
                                                          const EdgeInsets.all(
                                                              PsDimens.space8),
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: <Widget>[
                                                         SvgPicture.asset('assets/images/icons/PhotoNumber.svg',height: 20,),
                                                          const SizedBox(
                                                              width: PsDimens
                                                                  .space12),
                                                          Text(
                                                            '${provider.itemDetail.data.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText2
                                                                .copyWith(
                                                                    color: PsColors
                                                                        .white),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutePaths
                                                              .galleryGrid,
                                                          arguments: provider
                                                              .itemDetail.data);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.all(
                                            PsDimens.space8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: <Widget>[
                                            if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSPROGRESS &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color:
                                                        PsColors.paidAdsColor),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_progress'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSFINISHED &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: PsColors.black),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_in_completed'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else if (provider.itemDetail.data
                                                        .paidStatus ==
                                                    PsConst.ADSNOTYETSTART &&
                                                provider.itemDetail.data
                                                        .addedUserId ==
                                                    provider.psValueHolder
                                                        .loginUserId)
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.yellow),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Text(
                                                  Utils.getString(context,
                                                      'paid__ads_is_not_yet_start'),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2
                                                      .copyWith(
                                                          color:
                                                              PsColors.white),
                                                ),
                                              )
                                            else
                                              Container(),
                                            InkWell(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            PsDimens.space4),
                                                    color: Colors.black45),
                                                padding: const EdgeInsets.all(
                                                    PsDimens.space12),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Icon(
                                                      Ionicons.md_images,
                                                      color: PsColors.white,
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            PsDimens.space12),
                                                    Text(
                                                      '${provider.itemDetail.data.photoCount}  ${Utils.getString(context, 'item_detail__photo')}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText2
                                                          .copyWith(
                                                              color: PsColors
                                                                  .white),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RoutePaths.galleryGrid,
                                                    arguments: provider
                                                        .itemDetail.data);
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate(<Widget>[
                              Container(
                                color: Utils.isLightMode(context)? PsColors.white:PsColors.black,
                                child: Column(children: <Widget>[
                                  _HeaderBoxWidget(
                                    itemDetail: provider,
                                    product: provider.itemDetail.data,
                                    heroTagTitle: widget.heroTagTitle,
                                  ),
                                  SellerInfoTileView(
                                    itemDetail: provider,
                                  ),
                                  if (provider.itemDetail.data.isOwner ==
                                          PsConst.ONE &&
                                      provider.itemDetail.data.status ==
                                          PsConst.ONE &&
                                      (provider.itemDetail.data.paidStatus ==
                                              PsConst.ADSNOTAVAILABLE ||
                                          provider.itemDetail.data.paidStatus ==
                                              PsConst.ADSFINISHED) &&
                                      appInfoProvider.appInfo.data != null &&
                                      !isAllPaymentDisable(appInfoProvider))
                                    PromoteTileView(
                                      animationController: animationController,
                                      product: provider.itemDetail.data,
                                      provider: provider,
                                    )
                                  else
                                    Container(),
                                  SafetyTipsTileView(
                                      animationController: animationController),
                                  // LocationTileView(
                                  //     item: provider.itemDetail.data),
                                  GettingThisTileView(
                                    item: provider.itemDetail.data,
                                      detailOption:
                                          provider.itemDetail.data.dealOption,
                                      address:
                                          provider.itemDetail.data.address),
                                  StatisticTileView(
                                    provider,
                                  ),
                                  const SizedBox(
                                    height: PsDimens.space80,
                                  ),
                                ]),
                              )
                            ]),
                          )
                        ]),
                        if (provider.itemDetail.data.addedUserId != null &&
                            provider.itemDetail.data.addedUserId ==
                                psValueHolder.loginUserId)
                          _EditAndDeleteButtonWidget(
                            provider: provider,
                          )
                        else
                          _CallAndChatButtonWidget(
                            provider: provider,
                            favouriteItemRepo: productRepo,
                            psValueHolder: psValueHolder,
                          ),
                      ],
                    );
                  });
                } else {
                  return Container();
                }
              },
            )));
  }
}

dynamic isAllPaymentDisable(AppInfoProvider appInfoProvider) {
  if (appInfoProvider.appInfo.data.inAppPurchasedEnabled == PsConst.ZERO &&
      appInfoProvider.appInfo.data.stripeEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.paypalEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.payStackEnabled == PsConst.ZERO &&
      appInfoProvider.appInfo.data.razorEnable == PsConst.ZERO &&
      appInfoProvider.appInfo.data.offlineEnabled == PsConst.ZERO) {
    return true;
  } else {
    return false;
  }
}

class _PopUpMenuWidget extends StatelessWidget {
  const _PopUpMenuWidget(
      {@required this.userProvider,
      @required this.itemId,
      @required this.itemUserId,
      @required this.addedUserId,
      @required this.reportedUserId,
      @required this.loginUserId,
      @required this.itemTitle,
      @required this.itemImage,
      @required this.context,
      @required this.itemDetailProvider});
  final UserProvider userProvider;
  final String itemId;
  final String addedUserId;
  final String reportedUserId;
  final String loginUserId;
  final String itemUserId;
  final String itemTitle;
  final String itemImage;
  final BuildContext context;
  final ItemDetailProvider itemDetailProvider;

  Future<void> _onSelect(String value) async {
    switch (value) {
      case '1':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_report_item'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserReportItemParameterHolder
                      userReportItemParameterHolder =
                      UserReportItemParameterHolder(
                          itemId: itemId, reportedUserId: reportedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider
                      .userReportItem(userReportItemParameterHolder.toMap());

                  if (_apiStatus != null &&
                      _apiStatus.data != null &&
                      _apiStatus.data.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheById(
                        itemId, reportedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );

        break;

      case '2':
        showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialogView(
                description: Utils.getString(
                    context, 'item_detail__confirm_dialog_block_user'),
                leftButtonText: Utils.getString(context, 'dialog__cancel'),
                rightButtonText: Utils.getString(context, 'dialog__ok'),
                onAgreeTap: () async {
                  await PsProgressDialog.showDialog(context);

                  final UserBlockParameterHolder userBlockItemParameterHolder =
                      UserBlockParameterHolder(
                          loginUserId: loginUserId, addedUserId: addedUserId);

                  final PsResource<ApiStatus> _apiStatus = await userProvider
                      .blockUser(userBlockItemParameterHolder.toMap());

                  if (_apiStatus != null &&
                      _apiStatus.data != null &&
                      _apiStatus.data.status != null) {
                    await itemDetailProvider.deleteLocalProductCacheByUserId(
                        loginUserId, addedUserId);
                  }

                  PsProgressDialog.dismissDialog();

                  Navigator.of(context)
                      .popUntil(ModalRoute.withName(RoutePaths.home));
                });
          },
        );
        break;

      case '3':
        final Size size = MediaQuery.of(context).size;
        if (itemDetailProvider.itemDetail.data.dynamicLink != null) {
          Share.share(
            'Go to App:\n' + itemDetailProvider.itemDetail.data.dynamicLink,
            // +'Image:\n' + PsConfig.ps_app_image_url + itemImage,
            sharePositionOrigin:
                Rect.fromLTWH(0, 0, size.width, size.height / 2),
          );
        }
        // else{
        //   Share.share(
        //     'Go to App:\n Image:\n' + PsConfig.ps_app_image_url + itemImage,
        //     sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
        //   );
        // }

        // await FlutterShare.share(
        //     title: itemTitle,
        //     text: 'Go to App:\n' +
        //             itemDetailProvider.itemDetail.data.dynamicLink ??
        //         '',
        //     linkUrl: 'Image:\n' + PsConfig.ps_app_image_url + itemImage);

        // final HttpClientRequest request = await HttpClient()
        //     .getUrl(Uri.parse(PsConfig.ps_app_image_url + itemImage));
        // final HttpClientResponse response = await request.close();
        // final Uint8List bytes =
        //     await consolidateHttpClientResponseBytes(response);
        //     await Share.file(itemTitle, itemTitle + '.jpg', bytes, 'image/jpg',
        //     text: itemTitle + '\n' + itemDetailProvider.itemDetail.data.dynamicLink);
        break;
      default:
        print('English');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12, right: PsDimens.space12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PsColors.black.withAlpha(100),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
              iconTheme:
                  Theme.of(context).iconTheme.copyWith(color: PsColors.white)),
          child: PopupMenuButton<String>(
            icon:  SvgPicture.asset('assets/images/icons/PostOption.svg', height:14),
      
            // iconSize: 38,

            onSelected: _onSelect,
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                if (itemDetailProvider.psValueHolder.loginUserId !=
                        itemUserId &&
                    itemDetailProvider.psValueHolder.loginUserId != null &&
                    itemDetailProvider.psValueHolder.loginUserId != '')
                  PopupMenuItem<String>(
                    value: '1',
                    child: Visibility(
                      visible: true,
                      child: Text(
                        Utils.getString(context, 'item_detail__report_item'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                if (itemDetailProvider.psValueHolder.loginUserId !=
                        itemUserId &&
                    itemDetailProvider.psValueHolder.loginUserId != null &&
                    itemDetailProvider.psValueHolder.loginUserId != '')
                  PopupMenuItem<String>(
                    value: '2',
                    child: Visibility(
                      visible: true,
                      child: Text(
                        Utils.getString(context, 'item_detail__block_user'),
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                  ),
                PopupMenuItem<String>(
                  value: '3',
                  child: Text(Utils.getString(context, 'item_detail__share'),
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ];
            },
            elevation: 4,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        ));
  }
}

class _HeaderBoxWidget extends StatefulWidget {
  const _HeaderBoxWidget(
      {Key key,
      @required this.itemDetail,
      @required this.product,
      @required this.heroTagTitle})
      : super(key: key);

  final ItemDetailProvider itemDetail;
  final Product product;
  final String heroTagTitle;

  @override
  __HeaderBoxWidgetState createState() => __HeaderBoxWidgetState();
}

class __HeaderBoxWidgetState extends State<_HeaderBoxWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.product != null &&
        widget.itemDetail != null &&
        widget.itemDetail.itemDetail != null &&
        widget.itemDetail.itemDetail.data != null) {
      return Container(
        margin: const EdgeInsets.all(PsDimens.space12),
        // decoration: BoxDecoration(
          // color: PsColors.backgroundColor,
        //   borderRadius:
        //       const BorderRadius.all(Radius.circular(PsDimens.space8)),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
        margin: const EdgeInsets.only(bottom:PsDimens.space12),
        padding: const EdgeInsets.only(top:PsDimens.space12),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ), child:Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
                    child: PsHero(
                      tag: widget.heroTagTitle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.itemDetail.itemDetail.data.title,
                              style: Theme.of(context).textTheme.subtitle1.copyWith(fontWeight: FontWeight.w800)),
                              InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.userDetail,
                  // arguments: itemProvider.itemDetail.data.addedUserId
                  arguments: UserIntentHolder(
                      userId: widget.itemDetail.itemDetail.data.addedUserId,
                      userName: widget.itemDetail.itemDetail.data.user.userName));
            },
            child: Text(
              widget.itemDetail.itemDetail.data.user.userName == ''
                  ? Utils.getString(context, 'default__user_name')
                  : '${widget.itemDetail.itemDetail.data.user.userName}',
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontWeight: FontWeight.w900),
            ),
          ),
                        ],
                      ),
                    ),
                  ),

                ),
                // const  SizedBox(width: PsDimens.space80,),
                    Flexible(
                      flex: 1,
                      child: _IconsAndTitleTextWidget(
                                    icon: Icons.favorite_border,
                                    title:
                      '${widget.itemDetail.itemDetail.data.favouriteCount} ${Utils.getString(context, 'item_detail__like_count')}',
                                    color:const  Color(0xff9299B1)),
                    ),
              ],
            ),
          ],
        ),),
        Container(
          // margin: const EdgeInsets.all(PsDimens.space6),
          margin: const EdgeInsets.only(bottom:PsDimens.space12),
        padding: const EdgeInsets.all(PsDimens.space16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
          child: 
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                         SVGIconsTitleTextWidget(icon: 'assets/images/icons/PriceType.svg',title: widget.itemDetail.itemDetail.data != null &&
                          widget.itemDetail.itemDetail.data.price != '0' &&
                          widget.itemDetail.itemDetail.data.price != ''
                      ? ' ${widget.itemDetail.itemDetail.data.itemCurrency.currencySymbol.toUpperCase()} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data.price)}'

                      : Utils.getString(context, 'item_price_free'), subTitle:'(${widget.itemDetail.itemDetail.data.itemPriceType.name})')                 ,  
                                SVGIconsTitleTextWidget(icon: 'assets/images/icons/ItemCondition.svg' ,title: '${widget.itemDetail.itemDetail.data.addedDateStr}')                         ,  
                                       SVGIconsTitleTextWidget(icon: 'assets/images/icons/ItemCondition.svg',title: '${widget.itemDetail.itemDetail.data.conditionOfItem.name}')                         ,  
                ],
              ),
            const SizedBox(height: PsDimens.space12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
SVGIconsTitleTextWidget(icon: 'assets/images/icons/PostType.svg',title: '${widget.itemDetail.itemDetail.data.itemType.name}')                         ,  
                                SVGIconsTitleTextWidget(icon: 'assets/images/icons/PostCategory.svg',title: '${widget.itemDetail.itemDetail.data.category.catName}', subTitle: '${widget.itemDetail.itemDetail.data.subCategory.name}')                         ,  
                                       SVGIconsTitleTextWidget(icon: 'assets/images/icons/ShopSetting.svg',title: widget.itemDetail.itemDetail.data.businessMode == '0'
                    ? Utils.getString(context, 'item_detail__item_cannot_order')
                    : Utils.getString(context, 'item_detail__item_can_order')  ),
                ],
              )
            ],
          ),
        ),

            // _IconsAndTwoTitleTextWidget(
            //     icon: Icons.schedule,
            //     title: '${widget.itemDetail.itemDetail.data.addedDateStr}',
            //     color: PsColors.grey,
            //     itemProvider: widget.itemDetail),
            // if (widget.itemDetail.itemDetail.data.itemPriceType.name != '')
            //   _IconsAndTowTitleWithColumnTextWidget(
            //       icon: AntDesign.tago,
            //       title: widget.itemDetail.itemDetail.data != null &&
            //               widget.itemDetail.itemDetail.data.price != '0' &&
            //               widget.itemDetail.itemDetail.data.price != ''
            //           ? '${widget.itemDetail.itemDetail.data.itemCurrency.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data.price)}'
            //           : Utils.getString(context, 'item_price_free'),
            //       subTitle:
            //           '(${widget.itemDetail.itemDetail.data.itemPriceType.name})',
            //       color: PsColors.mainColor)
            // else
            //   _IconsAndTitleTextWidget(
            //       icon: AntDesign.tago,
            //       title: widget.itemDetail.itemDetail.data != null &&
            //               widget.itemDetail.itemDetail.data.price != '0' &&
            //               widget.itemDetail.itemDetail.data.price != ''
            //           ? '${widget.itemDetail.itemDetail.data.itemCurrency.currencySymbol} ${Utils.getPriceFormat(widget.itemDetail.itemDetail.data.price)}'
            //           : Utils.getString(context, 'item_price_free'),
            //       color: PsColors.mainColor),
            
            // _IconsAndTitleTextWidget(
            //     icon: SimpleLineIcons.drawer,
            //     title: widget.itemDetail.itemDetail.data.conditionOfItem.name,
            //     color: null),
            // _IconsAndTitleTextWidget(
            //     icon: MaterialCommunityIcons.view_dashboard_outline,
            //     title:
            //         '${widget.itemDetail.itemDetail.data.category.catName} / ${widget.itemDetail.itemDetail.data.subCategory.name}',
            //     color: null),
            // _IconsAndTitleTextWidget(
            //     icon: MaterialCommunityIcons.arrow_left_right_bold_outline,
            //     title: '${widget.itemDetail.itemDetail.data.itemType.name}',
            //     color: null),
            // _IconsAndTitleTextWidget(
            //     icon: Octicons.archive,
            //     title: widget.itemDetail.itemDetail.data.businessMode == '0'
            //         ? Utils.getString(context, 'item_detail__item_cannot_order')
            //         : Utils.getString(context, 'item_detail__item_can_order'),
            //     color: null),
            // _IconsAndTitleTextWidget(
            //     icon: Octicons.info,
            //     title: widget.itemDetail.itemDetail.data.description,
            //     color: null),
            if (widget.itemDetail.itemDetail.data.highlightInformation != '')
              Container(
                margin: const EdgeInsets.only(
                    left: PsDimens.space20,
                    right: PsDimens.space20,
                    bottom: PsDimens.space8),
                child: Card(
                  elevation: 0.0,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(PsDimens.space16)),
                  ),
                  color: PsColors.baseLightColor,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.itemDetail.itemDetail.data.highlightInformation,
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                          letterSpacing: 0.8, fontSize: 16, height: 1.3),
                    ),
                  ),
                ),
              )
            else
              Container(),
            if (widget.itemDetail.itemDetail.data.description != '')
              _DescriptionWedget(
                description: widget.itemDetail.itemDetail.data.description,
              )
            else
              Container(),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _DescriptionWedget extends StatelessWidget {
  const _DescriptionWedget({Key key, @required this.description})
      : super(key: key);
  final String description;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: PsColors.backgroundColor,
          borderRadius:
              const BorderRadius.all(Radius.circular(PsDimens.space8)),
        ),
        
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              Utils.getString(context, 'product_detail__product_description'),
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(height: PsDimens.space12),
            Text(description,
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      height: 1.3,
                      letterSpacing: 0.5,
                    ))
          ]),
    );
  }
}

class _IconsAndTitleTextWidget extends StatelessWidget {
  const _IconsAndTitleTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          Expanded(
            child: Text(
              title,
              style: color == null
                  ? Theme.of(context).textTheme.bodyText1
                  : Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconsAndTwoTitleTextWidget extends StatelessWidget {
  const _IconsAndTwoTitleTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.itemProvider,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final ItemDetailProvider itemProvider;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Text(
            title,
            style: color == null
                ? Theme.of(context).textTheme.bodyText1
                : Theme.of(context).textTheme.bodyText1.copyWith(color: color),
          ),
          const SizedBox(
            width: PsDimens.space8,
          ),
          
        ],
      ),
    );
  }
  
}
class SVGIconsTitleTextWidget extends StatelessWidget {
  const SVGIconsTitleTextWidget({
    Key key,
    this.icon='assets/images/icons/StoreOption.svg',
    @required this.title,
    this.subTitle,
    
     this.color,
  }) : super(key: key);

  final String icon;
  final String title;

  final String subTitle;
  
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(radius: 18,backgroundColor:const Color(0xff9299B1),child: SvgPicture.asset(icon,height: 16,)),
          const SizedBox(
            height: PsDimens.space4,
          ),
          
          Text(
            title,
            textAlign: TextAlign.center,
            style: color == null
                ? Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 0.8)
                : Theme.of(context).textTheme.caption.copyWith(color: color),
          ),

          if(subTitle!=null)...{
            Text(
            subTitle,
            style: color == null
                ? Theme.of(context).textTheme.bodyText1.apply(fontSizeFactor: 0.8)
                : Theme.of(context).textTheme.caption.copyWith(color: color),
          ),
          }
          
        ],
      ),
    );
  }}
  

class _CallAndChatButtonWidget extends StatefulWidget {
  const _CallAndChatButtonWidget({
    Key key,
    @required this.provider,
    @required this.favouriteItemRepo,
    @required this.psValueHolder,
  }) : super(key: key);

  final ItemDetailProvider provider;
  final ProductRepository favouriteItemRepo;
  final PsValueHolder psValueHolder;

  @override
  __CallAndChatButtonWidgetState createState() =>
      __CallAndChatButtonWidgetState();
}

class __CallAndChatButtonWidgetState extends State<_CallAndChatButtonWidget> {
  FavouriteItemProvider favouriteProvider;
  Widget icon;

  static final AdRequest request = AdRequest(
    testDevices: <String>[Utils.getBannerAdUnitId()],
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  @override
  void initState() {
    super.initState();
  }

  InterstitialAd _interstitialAd;
  // bool _interstitialReady = false;

  void createInterstitialAd() {
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
          // createInterstitialAd();
        },
        onApplicationExit: (Ad ad) =>
            print('$InterstitialAd onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.provider != null &&
        widget.provider.itemDetail != null &&
        widget.provider.itemDetail.data != null) {
      return ChangeNotifierProvider<FavouriteItemProvider>(
          lazy: false,
          create: (BuildContext context) {
            favouriteProvider = FavouriteItemProvider(
                repo: widget.favouriteItemRepo,
                psValueHolder: widget.psValueHolder);
            // provider.loadFavouriteList('prd9a3bfa2b7ab0f0693e84d834e73224bb');
            return favouriteProvider;
          },
          child: Consumer<FavouriteItemProvider>(builder: (BuildContext context,
              FavouriteItemProvider provider, Widget child) {
            return Container(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: double.infinity,
                height: PsDimens.space72,
                child: Container(
                  decoration: BoxDecoration(
                    color: PsColors.backgroundColor,
                    border: Border.all(color: PsColors.backgroundColor),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(PsDimens.space12),
                        topRight: Radius.circular(PsDimens.space12)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: PsColors.backgroundColor,
                        blurRadius:
                            10.0, // has the effect of softening the shadow
                        spreadRadius:
                            0, // has the effect of extending the shadow
                        offset: const Offset(
                          0.0, // horizontal, move right 10
                          0.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        PSButtonWithIconWidget(
                          hasShadow: false,
                          haschange: true,
                          colorData: PsColors.black.withOpacity(0.1),
                          icon: (widget.provider != null &&
                                  widget.provider.itemDetail != null &&
                                  widget.provider.itemDetail.data != null)
                              ? widget.provider.itemDetail.data.isFavourited ==
                                      PsConst.ZERO
                                  ? Icons.favorite_border
                                  : Icons.favorite
                              : null,
                          iconColor: PsColors.white,

                          width: 60,
                          titleText: '',
                          onPressed: () async {
                            if (await Utils.checkInternetConnectivity()) {
                              Utils.navigateOnUserVerificationView(
                                  widget.provider, context, () async {
                                if (widget.provider.itemDetail.data
                                        .isFavourited ==
                                    '0') {
                                  setState(() {
                                    widget.provider.itemDetail.data
                                        .isFavourited = '1';
                                  });
                                } else {
                                  setState(() {
                                    widget.provider.itemDetail.data
                                        .isFavourited = '0';
                                  });
                                }

                                final FavouriteParameterHolder
                                    favouriteParameterHolder =
                                    FavouriteParameterHolder(
                                        itemId:
                                            widget.provider.itemDetail.data.id,
                                        userId:
                                            widget.psValueHolder.loginUserId);

                                final PsResource<Product> _apiStatus =
                                    await favouriteProvider.postFavourite(
                                        favouriteParameterHolder.toMap());

                                if (_apiStatus.data != null) {
                                  if (_apiStatus.status == PsStatus.SUCCESS) {
                                    await widget.provider.loadItemForFav(
                                        widget.provider.itemDetail.data.id,
                                        widget.psValueHolder.loginUserId);
                                  }
                                  if (widget.provider != null &&
                                      widget.provider.itemDetail != null &&
                                      widget.provider.itemDetail.data != null) {
                                    if (widget.provider.itemDetail.data
                                            .isFavourited ==
                                        PsConst.ONE) {
                                      icon = Icon(Icons.favorite,
                                          color: PsColors.mainColor);
                                    } else {
                                      icon = Icon(Icons.favorite_border,
                                          color: PsColors.mainColor);
                                    }
                                  }
                                } else {
                                  print('There is no comment');
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        if (widget.provider.itemDetail.data.user.userPhone !=
                                null &&
                            widget.provider.itemDetail.data.user.userPhone !=
                                '' &&
                            widget.provider.itemDetail.data.user.isShowPhone ==
                                '1')
                          Visibility(
                              visible: true,
                              child: PSButtonWithIconWidget(
                                hasShadow: true,
                                icon: Icons.call,
                                haschange: true,
                                width: 100,
                                titleText: Utils.getString(
                                    context, 'item_detail__call'),
                                onPressed: () async {
                                  if (await canLaunch(
                                      'tel://${widget.provider.itemDetail.data.user.userPhone}')) {
                                    await launch(
                                        'tel://${widget.provider.itemDetail.data.user.userPhone}');
                                  } else {
                                    throw 'Could not Call Phone';
                                  }
                                },
                              ))
                        else
                          Container(),
                        const SizedBox(
                          width: PsDimens.space10,
                        ),
                        Expanded(
                          child:
                              // RaisedButton(
                              //   child: Text(
                              //     Utils.getString(context, 'item_detail__chat'),
                              //     overflow: TextOverflow.ellipsis,
                              //     maxLines: 1,
                              //     textAlign: TextAlign.center,
                              //     softWrap: false,
                              //   ),
                              //   color: PsColors.mainColor,
                              //   shape: const BeveledRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //     Radius.circular(PsDimens.space8),
                              //   )),
                              //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                              //   onPressed: () {
                              PSButtonWithIconWidget(
                            hasShadow: true,
                            icon: Icons.chat,
                            haschange: true,
                            width: double.infinity,
                            titleText:
                                Utils.getString(context, 'item_detail__chat'),
                            onPressed: () async {
                              createInterstitialAd();
                              if (await Utils.checkInternetConnectivity()) {
                                Utils.navigateOnUserVerificationView(
                                    widget.provider, context, () async {
                                  Navigator.pushNamed(
                                      context, RoutePaths.chatView,
                                      arguments: ChatHistoryIntentHolder(
                                        chatFlag: PsConst.CHAT_FROM_SELLER,
                                        itemId:
                                            widget.provider.itemDetail.data.id,
                                        buyerUserId:
                                            widget.psValueHolder.loginUserId,
                                        sellerUserId: widget.provider.itemDetail
                                            .data.addedUserId,
                                      ));
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
    } else {
      return Container();
    }
  }
}

class _EditAndDeleteButtonWidget extends StatelessWidget {
  const _EditAndDeleteButtonWidget({
    Key key,
    @required this.provider,
  }) : super(key: key);

  final ItemDetailProvider provider;
  @override
  Widget build(BuildContext context) {
    if (provider != null &&
        provider.itemDetail != null &&
        provider.itemDetail.data != null) {
      return Container(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: PsDimens.space12),
            SizedBox(
              width: double.infinity,
              height: PsDimens.space72,
              child: Container(
                decoration: BoxDecoration(
                  color: PsColors.backgroundColor,
                  border: Border.all(color: PsColors.backgroundColor),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(PsDimens.space12),
                      topRight: Radius.circular(PsDimens.space12)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: PsColors.backgroundColor,
                      blurRadius:
                          10.0, // has the effect of softening the shadow
                      spreadRadius: 0, // has the effect of extending the shadow
                      offset: const Offset(
                        0.0, // horizontal, move right 10
                        0.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(PsDimens.space8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child:
                            // RaisedButton(
                            //   child: Text(
                            //     Utils.getString(context, 'item_detail__delete'),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     softWrap: false,
                            //   ),
                            //   color: PsColors.grey,
                            //   shape: const BeveledRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //     Radius.circular(PsDimens.space8),
                            //   )),
                            //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                            //   onPressed: () async {
                            PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.delete,
                          colorData: PsColors.grey,
                          titleText:
                              Utils.getString(context, 'item_detail__delete'),
                          onPressed: () async {
                            showDialog<dynamic>(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialogView(
                                      description: Utils.getString(
                                          context, 'item_detail__delete_desc'),
                                      leftButtonText: Utils.getString(
                                          context, 'dialog__cancel'),
                                      rightButtonText: Utils.getString(
                                          context, 'dialog__ok'),
                                      onAgreeTap: () async {
                                        final UserDeleteItemParameterHolder
                                            userDeleteItemParameterHolder =
                                            UserDeleteItemParameterHolder(
                                          itemId: provider.itemDetail.data.id,
                                        );

                                        final PsResource<ApiStatus> _apiStatus =
                                            await provider.userDeleteItem(
                                                userDeleteItemParameterHolder
                                                    .toMap());

                                        if (_apiStatus.data.status ==
                                            'success') {
                                          Fluttertoast.showToast(
                                              msg: 'Item Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blueGrey,
                                              textColor: Colors.white);
                                          // Navigator.pop(context, true);
                                          Navigator.pushReplacementNamed(
                                            context,
                                            RoutePaths.home,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: 'Item is not Deleated',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.blueGrey,
                                              textColor: Colors.white);
                                        }
                                      });
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        width: PsDimens.space10,
                      ),
                      Expanded(
                        child:
                            //  RaisedButton(
                            //   child: Text(
                            //     Utils.getString(context, 'item_detail__edit'),
                            //     overflow: TextOverflow.ellipsis,
                            //     maxLines: 1,
                            //     textAlign: TextAlign.center,
                            //     softWrap: false,
                            //   ),
                            //   color: PsColors.mainColor,
                            //   shape: const BeveledRectangleBorder(
                            //       borderRadius: BorderRadius.all(
                            //     Radius.circular(PsDimens.space8),
                            //   )),
                            //   textColor: Theme.of(context).textTheme.button.copyWith(color: PsColors.white).color,
                            //   onPressed: () async {
                            PSButtonWithIconWidget(
                          hasShadow: true,
                          width: double.infinity,
                          icon: Icons.edit,
                          titleText:
                              Utils.getString(context, 'item_detail__edit'),
                          onPressed: () async {
                            final dynamic entryData = await Navigator.pushNamed(
                                context, RoutePaths.itemEntry,
                                arguments: ItemEntryIntentHolder(
                                    flag: PsConst.EDIT_ITEM,
                                    item: provider.itemDetail.data));
                            if (entryData != null &&
                                entryData is bool &&
                                entryData) {
                              provider.loadProduct(
                                  provider.itemDetail.data.id,
                                  Utils.checkUserLoginId(
                                      provider.psValueHolder));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}

class _IconsAndTowTitleWithColumnTextWidget extends StatelessWidget {
  const _IconsAndTowTitleWithColumnTextWidget({
    Key key,
    @required this.icon,
    @required this.title,
    @required this.subTitle,
    @required this.color,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String subTitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: PsDimens.space16,
          right: PsDimens.space16,
          bottom: PsDimens.space16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            icon,
            size: PsDimens.space18,
          ),
          const SizedBox(
            width: PsDimens.space16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: color == null
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: color),
              ),

              Text(
                subTitle,
                style: color == null
                    ? Theme.of(context).textTheme.bodyText1
                    : Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: color),
              )
              // )
            ],
          )
        ],
      ),
    );
  }
}

class PromoteTileView extends StatefulWidget {
  const PromoteTileView({
    Key key,
    @required this.animationController,
    @required this.product,
    @required this.provider,
  }) : super(key: key);

  final AnimationController animationController;
  final Product product;
  final ItemDetailProvider provider;

  @override
  _PromoteTileViewState createState() => _PromoteTileViewState();
}

class _PromoteTileViewState extends State<PromoteTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'item_detail__promote_your_item'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget =
        Icon(Ionicons.ios_megaphone, color: PsColors.mainColor);

    return Consumer<AppInfoProvider>(builder:
        (BuildContext context, AppInfoProvider appInfoprovider, Widget child) {
      if (appInfoprovider.appInfo.data == null) {
        return Container();
      } else {
        return Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: true,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: PsDimens.space1,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(PsDimens.space12),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_sub_title')),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: PsDimens.space12,
                        right: PsDimens.space12,
                        bottom: PsDimens.space12),
                    child: Text(Utils.getString(
                        context, 'item_detail__promote_description')),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(width: PsDimens.space2),
                      SizedBox(
                          width: PsDimens.space220,
                          child: PSButtonWithIconWidget(
                              hasShadow: false,
                              width: double.infinity,
                              icon: Ionicons.ios_megaphone,
                              titleText: Utils.getString(
                                  context, 'item_detail__promte'),
                              onPressed: () async {
                                if (appInfoprovider.appInfo.data
                                            .inAppPurchasedEnabled ==
                                        PsConst.ONE &&
                                    appInfoprovider.appInfo.data.stripeEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data.paypalEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                            .appInfo.data.payStackEnabled ==
                                        PsConst.ZERO &&
                                    appInfoprovider.appInfo.data.razorEnable ==
                                        PsConst.ZERO &&
                                    appInfoprovider
                                            .appInfo.data.offlineEnabled ==
                                        PsConst.ZERO) {
                                  // InAppPurchase View
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.inAppPurchase,
                                          arguments: <String, dynamic>{
                                        'productId': widget.product.id,
                                        'appInfo': appInfoprovider.appInfo.data
                                      });
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String loginUserId =
                                        Utils.checkUserLoginId(
                                            widget.provider.psValueHolder);
                                    widget.provider.loadProduct(
                                        widget.product.id, loginUserId);
                                  }
                                } else if (appInfoprovider
                                        .appInfo.data.inAppPurchasedEnabled ==
                                    PsConst.ZERO) {
                                  //Original Item Promote View
                                  final dynamic returnData =
                                      await Navigator.pushNamed(
                                          context, RoutePaths.itemPromote,
                                          arguments: widget.product);
                                  if (returnData == true ||
                                      returnData == null) {
                                    final String loginUserId =
                                        Utils.checkUserLoginId(
                                            widget.provider.psValueHolder);
                                    widget.provider.loadProduct(
                                        widget.product.id, loginUserId);
                                  }
                                } else {
                                  //choose payment
                                  showDialog<dynamic>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ChoosePaymentTypeDialog(
                                          onInAppPurchaseTap: () async {
                                            final dynamic returnData =
                                                await Navigator.pushNamed(
                                                    context,
                                                    RoutePaths.inAppPurchase,
                                                    arguments: <String,
                                                        dynamic>{
                                                  'productId':
                                                      widget.product.id,
                                                  'appInfo': appInfoprovider
                                                      .appInfo.data
                                                });
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String loginUserId =
                                                  Utils.checkUserLoginId(widget
                                                      .provider.psValueHolder);
                                              widget.provider.loadProduct(
                                                  widget.product.id,
                                                  loginUserId);
                                            }
                                          },
                                          onOtherPaymentTap: () async {
                                            final dynamic returnData =
                                                await Navigator.pushNamed(
                                                    context,
                                                    RoutePaths.itemPromote,
                                                    arguments: widget.product);
                                            if (returnData == true ||
                                                returnData == null) {
                                              final String loginUserId =
                                                  Utils.checkUserLoginId(widget
                                                      .provider.psValueHolder);
                                              widget.provider.loadProduct(
                                                  widget.product.id,
                                                  loginUserId);
                                            }
                                          },
                                        );
                                      });
                                }
                              })),
                      Padding(
                        padding: const EdgeInsets.only(
                            right: PsDimens.space18, bottom: PsDimens.space8),
                        child: Image.asset(
                          'assets/images/baseline_promotion_color_74.png',
                          width: PsDimens.space80,
                          height: PsDimens.space80,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      }
    });
  }
}
