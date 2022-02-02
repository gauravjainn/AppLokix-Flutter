import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/viewobject/category.dart';

class CategoryHorizontalListItem extends StatelessWidget {
  const CategoryHorizontalListItem({
    Key key,
    @required this.category,
    this.onTap,
  }) : super(key: key);

  final Category category;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0.0,
          color: PsColors.categoryBackgroundColor,
          margin: const EdgeInsets.symmetric(
              horizontal: PsDimens.space8, vertical: PsDimens.space12),
          child: Container(
            width: PsDimens.space100,
            child: Ink(
              color: PsColors.backgroundColor,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: PsDimens.space52,
                      height: PsDimens.space52,
                      child: PsNetworkCircleIconImage(
                        photoKey: '',
                        defaultIcon: category.defaultIcon,
                        // width: PsDimens.space52,
                        // height: PsDimens.space52,
                        boxfit: BoxFit.fitHeight,
                      ),
                    ),
                    const SizedBox(
                      height: PsDimens.space8,
                    ),
                    Text(
                      category.catName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
