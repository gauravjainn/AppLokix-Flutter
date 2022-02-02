import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/api/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/paid_ad_product_provider%20copy.dart';
import 'package:flutterbuyandsell/repository/product_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/item/item/product_vertical_list_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_detail_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:provider/provider.dart';

class PaidAdProductListView extends StatefulWidget {
  const PaidAdProductListView({Key key, @required this.animationController})
      : super(key: key);
  final AnimationController animationController;
  @override
  _PaidAdProductListView createState() => _PaidAdProductListView();
}

class _PaidAdProductListView extends State<PaidAdProductListView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  PaidAdProductProvider paidAdItemProvider;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // _paidAdItemProvider.nextProductList();
      }
    });

    super.initState();
  }

  ProductRepository repo1;
  PsValueHolder psValueHolder;
  dynamic data;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }

    repo1 = Provider.of<ProductRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    print(
        '............................Build UI Again ............................');

    return ChangeNotifierProvider<PaidAdProductProvider>(
        lazy: false,
        create: (BuildContext context) {
          paidAdItemProvider = PaidAdProductProvider(
              repo: repo1, limit: PsConfig.POPULAR_ITEM_LOADING_LIMIT);
          paidAdItemProvider.productPaidAdParameterHolder.itemLocationId =
              psValueHolder.locationId;
          final String loginUserId = Utils.checkUserLoginId(psValueHolder);
          if (psValueHolder.isSubLocation == PsConst.ONE) {
            paidAdItemProvider.productPaidAdParameterHolder
                .itemLocationTownshipId = psValueHolder.locationTownshipId;
          }
          paidAdItemProvider.loadProductList(
              loginUserId, paidAdItemProvider.productPaidAdParameterHolder);
          return paidAdItemProvider;
        },
        child: Consumer<PaidAdProductProvider>(
          builder: (BuildContext context,
              PaidAdProductProvider paidAdItemProvider, Widget child) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(
                            left: PsDimens.space4,
                            right: PsDimens.space4,
                            top: PsDimens.space4,
                            bottom: PsDimens.space4),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              physics: const AlwaysScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 220.0,
                                          childAspectRatio: 0.6),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (paidAdItemProvider.productList.data !=
                                              null ||
                                          paidAdItemProvider
                                              .productList.data.isNotEmpty) {
                                        final int count = paidAdItemProvider
                                            .productList.data.length;
                                        return ProductVeticalListItem(
                                          coreTagKey: paidAdItemProvider
                                                  .hashCode
                                                  .toString() +
                                              paidAdItemProvider
                                                  .productList.data[index].id,
                                          animationController:
                                              widget.animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(
                                            CurvedAnimation(
                                              parent:
                                                  widget.animationController,
                                              curve: Interval(
                                                  (1 / count) * index, 1.0,
                                                  curve: Curves.fastOutSlowIn),
                                            ),
                                          ),
                                          product: paidAdItemProvider
                                              .productList.data[index],
                                          onTap: () async {
                                            final Product product =
                                                paidAdItemProvider
                                                    .productList.data.reversed
                                                    .toList()[index];
                                            final ProductDetailIntentHolder
                                                holder =
                                                ProductDetailIntentHolder(
                                                    productId:
                                                        paidAdItemProvider
                                                            .productList
                                                            .data[index]
                                                            .id,
                                                    heroTagImage:
                                                        paidAdItemProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id +
                                                            PsConst
                                                                .HERO_TAG__IMAGE,
                                                    heroTagTitle:
                                                        paidAdItemProvider
                                                                .hashCode
                                                                .toString() +
                                                            product.id +
                                                            PsConst
                                                                .HERO_TAG__TITLE);
                                            await Navigator.pushNamed(context,
                                                RoutePaths.productDetail,
                                                arguments: holder);
                                            final String loginUserId =
                                                Utils.checkUserLoginId(
                                                    psValueHolder);
                                            await paidAdItemProvider
                                                .resetProductList(
                                                    loginUserId,
                                                    paidAdItemProvider
                                                        .productPaidAdParameterHolder);
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount: paidAdItemProvider
                                        .productList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            final String loginUserId =
                                Utils.checkUserLoginId(psValueHolder);
                            return paidAdItemProvider.resetProductList(
                                loginUserId,
                                paidAdItemProvider
                                    .productPaidAdParameterHolder);
                          },
                        )),
                    PSProgressIndicator(paidAdItemProvider.productList.status)
                  ]),
                )
              ],
            );
          },
        ));
  }
}
