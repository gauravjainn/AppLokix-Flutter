import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/gallery/gallery_provider.dart';
import 'package:flutterbuyandsell/repository/gallery_repository.dart';
import 'package:flutterbuyandsell/ui/common/base/ps_widget_with_appbar.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/gallery/item/gallery_grid_item.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GalleryGridView extends StatefulWidget {
  const GalleryGridView({
    Key key,
    @required this.product,
    this.onImageTap,
  }) : super(key: key);

  final Product product;
  final Function onImageTap;
  @override
  _GalleryGridViewState createState() => _GalleryGridViewState();
}

class _GalleryGridViewState extends State<GalleryGridView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final GalleryRepository productRepo =
        Provider.of<GalleryRepository>(context);
    print(
        '............................Build UI Again ............................');
    return PsWidgetWithAppBar<GalleryProvider>(
        appBarTitle: Utils.getString(context, 'gallery__title') ?? '',
        initProvider: () {
          return GalleryProvider(repo: productRepo);
        },
        onProviderReady: (GalleryProvider provider) {
          provider.loadImageList(
              widget.product.defaultPhoto.imgParentId, PsConst.ITEM_TYPE);
        },
        builder:
            (BuildContext context, GalleryProvider provider, Widget child) {
          if (provider.galleryList != null &&
              provider.galleryList.data.isNotEmpty) {
            return Stack(
              children: <Widget>[
                Container(
                  color: Theme.of(context).cardColor,
                  height: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RefreshIndicator(
                      child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          slivers: <Widget>[
                            SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 150.0, childAspectRatio: 1.0),
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return GalleryGridItem(
                                      image: provider.galleryList.data[index],
                                      onImageTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePaths.galleryDetail,
                                            arguments:
                                                provider.galleryList.data[index]);
                                      });
                                },
                                childCount: provider.galleryList.data.length,
                              ),
                            )
                          ]),
                          onRefresh: (){
                            return provider.resetGalleryList( 
                              widget.product.defaultPhoto.imgParentId, PsConst.ITEM_TYPE);
                          },
                    ),
                  ),
                ),
                PSProgressIndicator(provider.galleryList.status)
              ],
            );
          } else {
            return Stack(
                  children: <Widget>[
                    Container(),
                    PSProgressIndicator(provider.galleryList.status)
                  ],
                );
          }
        });
  }
}
