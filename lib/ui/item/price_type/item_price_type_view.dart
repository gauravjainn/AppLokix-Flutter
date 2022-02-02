import 'package:flutterbuyandsell/api/common/ps_status.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/provider/product/item_price_type_provider.dart';
import 'package:flutterbuyandsell/repository/item_price_type_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_frame_loading_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'item_price_type_list_view_item.dart';

class ItemPriceTypeView extends StatefulWidget {
  // const ItemPriceTypeView({@required this.categoryId});

  @override
  State<StatefulWidget> createState() {
    return ItemPriceTypeTypeViewState();
  }
}

class ItemPriceTypeTypeViewState extends State<ItemPriceTypeView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  ItemPriceTypeProvider _itemPriceTypeProvider;
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
        _itemPriceTypeProvider.nextItemPriceTypeList();
      }
    });

    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(animationController);
    super.initState();
  }

  ItemPriceTypeRepository repo1;

  @override
  Widget build(BuildContext context) {
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

    repo1 = Provider.of<ItemPriceTypeRepository>(context);

    print(
        '............................Build UI Again ............................');

    return WillPopScope(
      onWillPop: _requestPop,
      child: PsWidgetWithAppBar<ItemPriceTypeProvider>(
          appBarTitle: Utils.getString(context, 'item_entry__price_type') ?? '',
          initProvider: () {
            return ItemPriceTypeProvider(
              repo: repo1,
            );
          },
          onProviderReady: (ItemPriceTypeProvider provider) {
            provider.loadItemPriceTypeList();
            _itemPriceTypeProvider = provider;
          },
          builder: (BuildContext context, ItemPriceTypeProvider provider,
              Widget child) {
            return Stack(children: <Widget>[
              Container(
                  child: RefreshIndicator(
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: provider.itemPriceTypeList.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (provider.itemPriceTypeList.status ==
                          PsStatus.BLOCK_LOADING) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.white,
                            child: Column(children: const <Widget>[
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                              PsFrameUIForLoading(),
                            ]));
                      } else {
                        final int count =
                            provider.itemPriceTypeList.data.length;
                        animationController.forward();
                        return FadeTransition(
                            opacity: animation,
                            child: ItemPriceTypeListViewItem(
                              itemPriceType:
                                  provider.itemPriceTypeList.data[index],
                              onTap: () {
                                Navigator.pop(context,
                                    provider.itemPriceTypeList.data[index]);
                                print(provider
                                    .itemPriceTypeList.data[index].name);
                                // if (index == 0) {
                                //   Navigator.pushNamed(
                                //     context,
                                //     RoutePaths.searchCategory,
                                //   );
                                // }
                              },
                              animationController: animationController,
                              animation:
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: animationController,
                                  curve: Interval((1 / count) * index, 1.0,
                                      curve: Curves.fastOutSlowIn),
                                ),
                              ),
                            ));
                      }
                    }),
                onRefresh: () {
                  return provider.resetItemPriceTypeList();
                },
              )),
              PSProgressIndicator(provider.itemPriceTypeList.status)
            ]);
          }),
    );
  }
}
