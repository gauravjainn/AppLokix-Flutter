import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/viewobject/item_location_township.dart';

class ItemLocationTownshipListItem extends StatelessWidget {
  const ItemLocationTownshipListItem(
      {Key key,
      @required this.itemLocationTownship,
      this.onTap,
      this.animationController,
      this.animation})
      : super(key: key);

  final ItemLocationTownship itemLocationTownship;
  final Function onTap;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    animationController.forward();
    return AnimatedBuilder(
        animation: animationController,
        child: InkWell(
            onTap: onTap,
            child: Container(
                margin: const EdgeInsets.only(bottom: PsDimens.space8),
                child: Ink(
                    child: ItemLocationTownshipListItemWidget(
                        itemLocationTownship: itemLocationTownship)))),
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

class ItemLocationTownshipListItemWidget extends StatelessWidget {
  const ItemLocationTownshipListItemWidget({
    Key key,
    @required this.itemLocationTownship,
  }) : super(key: key);

  final ItemLocationTownship itemLocationTownship;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(PsDimens.space16),
      child: Text(
        itemLocationTownship.townshipName,
        style: Theme.of(context)
            .textTheme
            .subtitle1
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
