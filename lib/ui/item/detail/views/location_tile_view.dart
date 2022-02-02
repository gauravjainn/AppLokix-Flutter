import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/map_pin_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';

class LocationTileView extends StatefulWidget {
  const LocationTileView({
    Key key,
    @required this.item,
  }) : super(key: key);

  final Product item;

  @override
  _LocationTileViewState createState() => _LocationTileViewState();
}

class _LocationTileViewState extends State<LocationTileView> {
  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'location_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingWidget = Icon(
      SimpleLineIcons.location_pin,
      color: PsColors.mainColor,
    );
    // if (productDetail != null && productDetail.description != null) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space12,
          right: PsDimens.space12,
          bottom: PsDimens.space12),
      decoration: BoxDecoration(
        color: PsColors.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(PsDimens.space8)),
      ),
      child: PsExpansionTile(
        initiallyExpanded: true,
        leading: _expansionTileLeadingWidget,
        title: _expansionTileTitleWidget,
        children: <Widget>[
          Column(
            children: <Widget>[
              const Divider(
                height: PsDimens.space1,
              ),
              InkWell(
                child: Ink(
                  child: Padding(
                    padding: const EdgeInsets.all(PsDimens.space16),
                    child: Text(
                      Utils.getString(
                              context, 'location_tile__view_on_map_button')
                          .toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: PsColors.mainColor),
                    ),
                  ),
                ),
                onTap: () async {
                  if (PsConfig.isUseGoogleMap) {
                    await Navigator.pushNamed(context, RoutePaths.googleMapPin,
                        arguments: MapPinIntentHolder(
                            flag: PsConst.VIEW_MAP,
                            mapLat: widget.item.lat,
                            mapLng: widget.item.lng));
                  } else {
                    await Navigator.pushNamed(context, RoutePaths.mapPin,
                      arguments: MapPinIntentHolder(
                          flag: PsConst.VIEW_MAP,
                          mapLat: widget.item.lat,
                          mapLng: widget.item.lng));
                  }
                }
              ),
            ],
          ),
        ],
      ),
    );
    // } else {
    //   return const Card();
    // }
  }
}
