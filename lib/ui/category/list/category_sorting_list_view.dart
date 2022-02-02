import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/api/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/provider/category/category_provider.dart';
import 'package:flutterbuyandsell/repository/category_repository.dart';
import 'package:flutterbuyandsell/ui/category/item/category_vertical_list_item.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/dialog/filter_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/product_parameter_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';

class CategorySortingListView extends StatefulWidget {
  @override
  _CategorySortingListViewState createState() {
    return _CategorySortingListViewState();
  }
}

class _CategorySortingListViewState extends State<CategorySortingListView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  CategoryProvider _categoryProvider;

  AnimationController animationController;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _categoryProvider.nextCategoryList(
            _categoryProvider.categoryParameterHolder.toMap(),
            Utils.checkUserLoginId(_categoryProvider.psValueHolder));
      }
    });
  }

  CategoryRepository repo1;
  PsValueHolder psValueHolder;
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
    Future<bool> _requestPop() {
      animationController.reverse().then<dynamic>(
        (void data) {
          if (!mounted) {
            return Future<bool>.value(false);
          }
          Navigator.pop(context, true);
          return Future<bool>.value(true);
        },
      );
      return Future<bool>.value(false);
    }

    timeDilation = 1.0;
    repo1 = Provider.of<CategoryRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<CategoryProvider>(
          appBarTitle:
              Utils.getString(context, 'dashboard__category_list') ?? '',
          actions: <Widget>[
            IconButton(
              icon: Icon(MaterialCommunityIcons.filter_remove_outline,
                  color: PsColors.mainColor),
              onPressed: () {
                showDialog<dynamic>(
                    context: context,
                    builder: (BuildContext context) {
                      return FilterDialog(
                        onAscendingTap: () async {
                          _categoryProvider.categoryParameterHolder.orderBy =
                              PsConst.FILTERING_CAT_NAME;
                          _categoryProvider.categoryParameterHolder.orderType =
                              PsConst.FILTERING__ASC;
                          _categoryProvider.resetCategoryList(
                              _categoryProvider.categoryParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  _categoryProvider.psValueHolder));
                        },
                        onDescendingTap: () {
                          _categoryProvider.categoryParameterHolder.orderBy =
                              PsConst.FILTERING_CAT_NAME;
                          _categoryProvider.categoryParameterHolder.orderType =
                              PsConst.FILTERING__DESC;
                          _categoryProvider.resetCategoryList(
                              _categoryProvider.categoryParameterHolder.toMap(),
                              Utils.checkUserLoginId(
                                  _categoryProvider.psValueHolder));
                        },
                      );
                    });
              },
            )
          ],
          initProvider: () {
            return CategoryProvider(repo: repo1, psValueHolder: psValueHolder);
          },
          onProviderReady: (CategoryProvider provider) {
            provider.loadCategoryList(provider.categoryParameterHolder.toMap(),
                Utils.checkUserLoginId(provider.psValueHolder));

            _categoryProvider = provider;
          },
          builder:
              (BuildContext context, CategoryProvider provider, Widget child) {
            return Column(
              children: <Widget>[
                const PsAdMobBannerWidget(),
                Expanded(
                  child: Stack(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.all(PsDimens.space8),
                        child: RefreshIndicator(
                          child: CustomScrollView(
                              controller: _scrollController,
                              scrollDirection: Axis.vertical,
                              physics: const AlwaysScrollableScrollPhysics(),
                              shrinkWrap: false,
                              slivers: <Widget>[
                                SliverGrid(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 300.0,
                                          childAspectRatio: 1),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      if (provider.categoryList.data != null ||
                                          provider
                                              .categoryList.data.isNotEmpty) {
                                        final int count =
                                            provider.categoryList.data.length;
                                        return CategoryVerticalListItem(
                                          animationController:
                                              animationController,
                                          animation: Tween<double>(
                                                  begin: 0.0, end: 1.0)
                                              .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 / count) * index, 1.0,
                                                curve: Curves.fastOutSlowIn),
                                          )),
                                          category:
                                              provider.categoryList.data[index],
                                          onTap: () {
                                            if (PsConfig.isShowSubCategory) {
                                              Navigator.pushNamed(context,
                                                  RoutePaths.subCategoryGrid,
                                                  arguments: provider
                                                      .categoryList
                                                      .data[index]);
                                            } else {
                                              final ProductParameterHolder
                                                  productParameterHolder =
                                                  ProductParameterHolder()
                                                      .getLatestParameterHolder();
                                              productParameterHolder.catId =
                                                  provider.categoryList
                                                      .data[index].catId;
                                              Navigator.pushNamed(context,
                                                  RoutePaths.filterProductList,
                                                  arguments:
                                                      ProductListIntentHolder(
                                                    appBarTitle: provider
                                                        .categoryList
                                                        .data[index]
                                                        .catName,
                                                    productParameterHolder:
                                                        productParameterHolder,
                                                  ));
                                            }
                                          },
                                        );
                                      } else {
                                        return null;
                                      }
                                    },
                                    childCount:
                                        provider.categoryList.data.length,
                                  ),
                                ),
                              ]),
                          onRefresh: () {
                            return provider.resetCategoryList(
                                _categoryProvider.categoryParameterHolder
                                    .toMap(),
                                Utils.checkUserLoginId(
                                    _categoryProvider.psValueHolder));
                          },
                        )),
                    PSProgressIndicator(provider.categoryList.status)
                  ]),
                )
              ],
            );
          }),
    );
  }
}
