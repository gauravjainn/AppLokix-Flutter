import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/api/common/ps_admob_banner_widget.dart';
import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/subcategory/sub_category_provider.dart';
import 'package:flutterbuyandsell/repository/sub_category_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/filter_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/subcategory/item/sub_category_grid_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/product_list_intent_holder.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:shimmer/shimmer.dart';

class SubCategoryGridView extends StatefulWidget {
  const SubCategoryGridView({this.category});
  final Category category;
  @override
  _ModelGridViewState createState() {
    return _ModelGridViewState();
  }
}

class _ModelGridViewState extends State<SubCategoryGridView>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  SubCategoryProvider _subCategoryProvider;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void dispose() {
    animationController.dispose();
    animation = null;
    super.dispose();
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final String categId = widget.category.catId;
        Utils.psPrint('CategoryId number is $categId');

        _subCategoryProvider.nextSubCategoryList(
            _subCategoryProvider.subCategoryParameterHolder.toMap(),
            Utils.checkUserLoginId(valueHolder),
            widget.category.catId);
      }
    });
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  SubCategoryRepository repo1;
  PsValueHolder valueHolder;
  bool isConnectedToInternet = false;
  bool isSuccessfullyLoaded = true;

  void checkConnection() {
    Utils.checkInternetConnectivity().then((bool onValue) {
      isConnectedToInternet = onValue;
      if (isConnectedToInternet && PsConfig.showAdMob) {
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isConnectedToInternet && PsConfig.showAdMob) {
      print('loading ads....');
      checkConnection();
    }
    timeDilation = 1.0;
    repo1 = Provider.of<SubCategoryRepository>(context);
    valueHolder = Provider.of<PsValueHolder>(context);
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: PsColors.mainColor,
          brightness: Utils.getBrightnessForAppBar(context),
          title: Text(
            widget.category.catName,
            style: TextStyle(color: PsColors.mainColor),
          ),
          iconTheme: IconThemeData(
            color: PsColors.mainColor,
          ),
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
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__ASC;
                          _subCategoryProvider.resetSubCategoryList(
                            _subCategoryProvider.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(
                                _subCategoryProvider.psValueHolder),
                            widget.category.catId,
                          );
                        },
                        onDescendingTap: () {
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderBy = PsConst.FILTERING_SUBCAT_NAME;
                          _subCategoryProvider.subCategoryParameterHolder
                              .orderType = PsConst.FILTERING__DESC;
                          _subCategoryProvider.resetSubCategoryList(
                            _subCategoryProvider.subCategoryParameterHolder
                                .toMap(),
                            Utils.checkUserLoginId(
                                _subCategoryProvider.psValueHolder),
                            widget.category.catId,
                          );
                        },
                      );
                    });
              },
            )
          ],
        ),
        body: ChangeNotifierProvider<SubCategoryProvider>(
            lazy: false,
            create: (BuildContext context) {
              _subCategoryProvider =
                  SubCategoryProvider(repo: repo1, psValueHolder: valueHolder);
              _subCategoryProvider.loadAllSubCategoryList(
                _subCategoryProvider.subCategoryParameterHolder.toMap(),
                Utils.checkUserLoginId(_subCategoryProvider.psValueHolder),
                widget.category.catId,
              );
              return _subCategoryProvider;
            },
            child: Consumer<SubCategoryProvider>(builder: (BuildContext context,
                SubCategoryProvider provider, Widget child) {
              return Column(
                children: <Widget>[
                  const PsAdMobBannerWidget(),
                  Expanded(
                    child: Stack(children: <Widget>[
                      Container(
                          child: RefreshIndicator(
                        onRefresh: () {
                          return _subCategoryProvider.resetSubCategoryList(
                              _subCategoryProvider.subCategoryParameterHolder
                                  .toMap(),
                              Utils.checkUserLoginId(valueHolder),
                              widget.category.catId);
                        },
                        child: CustomScrollView(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            slivers: <Widget>[
                              SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 240.0,
                                        childAspectRatio: 1.4),
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    if (provider.subCategoryList.status ==
                                        PsStatus.BLOCK_LOADING) {
                                      return Shimmer.fromColors(
                                          baseColor: PsColors.grey,
                                          highlightColor: PsColors.white,
                                          child:
                                              Column(children: const <Widget>[
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                            FrameUIForLoading(),
                                          ]));
                                    } else {
                                      final int count =
                                          provider.subCategoryList.data.length;
                                      return SubCategoryGridItem(
                                        subCategory: provider
                                            .subCategoryList.data[index],
                                        onTap: () {
                                          provider.subCategoryByCatIdParamenterHolder
                                                  .catId =
                                              provider.subCategoryList
                                                  .data[index].catId;
                                          provider.subCategoryByCatIdParamenterHolder
                                                  .subCatId =
                                              provider.subCategoryList
                                                  .data[index].id;
                                          Navigator.pushNamed(context,
                                              RoutePaths.filterProductList,
                                              arguments: ProductListIntentHolder(
                                                  appBarTitle: provider
                                                      .subCategoryList
                                                      .data[index]
                                                      .name,
                                                  productParameterHolder: provider
                                                      .subCategoryByCatIdParamenterHolder));
                                        },
                                        animationController:
                                            animationController,
                                        animation:
                                            Tween<double>(begin: 0.0, end: 1.0)
                                                .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn),
                                        )),
                                      );
                                    }
                                  },
                                  childCount:
                                      provider.subCategoryList.data.length,
                                ),
                              ),
                            ]),
                      )),
                      PSProgressIndicator(
                        provider.subCategoryList.status,
                        message: provider.subCategoryList.message,
                      )
                    ]),
                  )
                ],
              );
            }))
        // )
        );
  }
}

class FrameUIForLoading extends StatelessWidget {
  const FrameUIForLoading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.all(PsDimens.space16),
            decoration: BoxDecoration(color: PsColors.grey)),
        Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: BoxDecoration(color: Colors.grey[300])),
          Container(
              height: 15,
              margin: const EdgeInsets.all(PsDimens.space8),
              decoration: const BoxDecoration(color: Colors.grey)),
        ]))
      ],
    );
  }
}
