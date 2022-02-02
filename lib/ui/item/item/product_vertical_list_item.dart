import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_hero.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:provider/provider.dart';

class ProductVeticalListItem extends StatelessWidget {
  const ProductVeticalListItem(
      {Key key,
      @required this.product,
      this.onTap,
      this.animationController,
      this.animation,
      this.coreTagKey})
      : super(key: key);

  final Product product;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;
  final String coreTagKey;

  @override
  Widget build(BuildContext context) {
    //print("${PsConfig.ps_app_image_thumbs_url}${subCategory.defaultPhoto.imgPath}");
    final PsValueHolder valueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
          onTap: onTap,
          child: GridTile(
            header: Container(
              padding: const EdgeInsets.all(PsDimens.space8),
              child: Ink(
                color: PsColors.backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: PsDimens.space8, vertical: PsDimens.space8),
              decoration: BoxDecoration(
                color: PsColors.backgroundColor,
                borderRadius:
                    const BorderRadius.all(Radius.circular(PsDimens.space8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        left: PsDimens.space4,
                        top: PsDimens.space4,
                        right: PsDimens.space12,
                        bottom: PsDimens.space4,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: PsDimens.space40,
                            height: PsDimens.space40,
                            child: PsNetworkCircleImageForUser(
                              photoKey: '',
                              imagePath: product.user.userProfilePhoto,
                              // width: PsDimens.space40,
                              // height: PsDimens.space40,
                              boxfit: BoxFit.cover,
                              onTap: () {
                                Utils.psPrint(product.defaultPhoto.imgParentId);
                                onTap();
                              },
                            ),
                          ),
                          const SizedBox(width: PsDimens.space8),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: PsDimens.space8,
                                  top: PsDimens.space8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      product.user.userName == ''
                                          ? Utils.getString(
                                              context, 'default__user_name')
                                          : '${product.user.userName}',
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                  if (product.paidStatus ==
                                      PsConst.PAID_AD_PROGRESS)
                                    Text(
                                        Utils.getString(
                                            context, 'paid_ad__sponsor'),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: PsColors.mainColor))
                                  else
                                    Text('${product.addedDateStr}',
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption),
                                  // if (product.paidStatus == PsConst.PAID_AD_PROGRESS)
                                  //   Text(Utils.getString(context, 'paid_ad__sponsor'),
                                  //       textAlign: TextAlign.start,
                                  //       style: Theme.of(context)
                                  //           .textTheme
                                  //           .caption
                                  //           .copyWith(color: Colors.blue))
                                  // else
                                  //   Text('${product.addedDateStr}',
                                  //       textAlign: TextAlign.start,
                                  //       style: Theme.of(context).textTheme.caption)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Stack(
                    //   children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          PsNetworkImage(
                            photoKey: '$coreTagKey${PsConst.HERO_TAG__IMAGE}',
                            defaultPhoto: product.defaultPhoto,
                            width: PsDimens.space180,
                            height: double.infinity,
                            boxfit: BoxFit.cover,
                            onTap: () {
                              Utils.psPrint(product.defaultPhoto.imgParentId);
                              onTap();
                            },
                          ),
                          Positioned(
                              bottom: 0,
                              child: product.isSoldOut == '1'
                                  ? Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: PsDimens.space12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              Utils.getString(context,
                                                  'dashboard__sold_out'),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2
                                                  .copyWith(
                                                      color: PsColors.white)),
                                        ),
                                      ),
                                      height: 30,
                                      width: PsDimens.space180,
                                      decoration: BoxDecoration(
                                          color: PsColors.soldOutUIColor),
                                    )
                                  : Container()
                              //   )
                              // ],
                              ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space12,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4),
                      child: PsHero(
                        tag: '$coreTagKey$PsConst.HERO_TAG__TITLE',
                        child: Text(
                          product.title,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText2,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space4,
                          right: PsDimens.space8),
                      child: Row(
                        children: <Widget>[
                          PsHero(
                            tag: '$coreTagKey$PsConst.HERO_TAG__UNIT_PRICE',
                            flightShuttleBuilder: Utils.flightShuttleBuilder,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Text(
                                  product != null &&
                                          product.price != '0' &&
                                          product.price != ''
                                      ? '${product.itemCurrency.currencySymbol}${Utils.getPriceFormat(product.price)}'
                                      : Utils.getString(
                                          context, 'item_price_free'),
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: PsColors.mainColor)),
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: PsDimens.space8,
                                  right: PsDimens.space8),
                              child: Text(
                                '(${product.conditionOfItem.name})',
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: PsColors.mainColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          top: PsDimens.space12,
                          right: PsDimens.space8,
                          bottom: PsDimens.space4),
                      child: Row(
                        children: <Widget>[
                          Image.asset(
                            'assets/images/baseline_pin_black_24.png',
                            width: PsDimens.space10,
                            height: PsDimens.space10,
                            fit: BoxFit.contain,

                            // ),
                          ),
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: PsDimens.space8,
                                      right: PsDimens.space8),
                                  child: Text(
                                      valueHolder.isSubLocation == PsConst.ONE
                                          ? '${product.itemLocationTownship.townshipName}'
                                          : '${product.itemLocation.name}',
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: PsDimens.space8,
                          right: PsDimens.space8,
                          bottom: PsDimens.space16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: PsDimens.space8,
                                height: PsDimens.space8,
                                decoration: BoxDecoration(
                                    color: PsColors.itemTypeColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(PsDimens.space4))),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: PsDimens.space8,
                                      right: PsDimens.space4),
                                  child: Text('${product.itemType.name}',
                                      textAlign: TextAlign.start,
                                      style:
                                          Theme.of(context).textTheme.caption))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Image.asset(
                                'assets/images/baseline_favourite_grey_24.png',
                                width: PsDimens.space10,
                                height: PsDimens.space10,
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: PsDimens.space4,
                                ),
                                child: Text('${product.favouriteCount}',
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context).textTheme.caption),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
              opacity: animation,
              child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 100 * (1.0 - animation.value), 0.0),
                  child: child));
        });
  }
}
