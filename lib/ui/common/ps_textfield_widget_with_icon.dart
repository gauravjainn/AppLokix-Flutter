import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';

class PsTextFieldWidgetWithIcon extends StatelessWidget {
  const PsTextFieldWidgetWithIcon(
      {this.textEditingController,
      this.hintText,
      this.height = PsDimens.space44,
      this.keyboardType = TextInputType.text,
      this.psValueHolder,
      this.clickEnterFunction,
      this.clickSearchButton});

  final TextEditingController textEditingController;
  final String hintText;
  final double height;
  final TextInputType keyboardType;
  final PsValueHolder psValueHolder;
  final Function clickEnterFunction;
  final Function clickSearchButton;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextFieldWidget = TextField(
        keyboardType: TextInputType.text,
        maxLines: null,
        controller: textEditingController,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: PsDimens.space12,
            bottom: PsDimens.space8,
            top: PsDimens.space16,
          ),
                  border: InputBorder.none,
        hintText: hintText,
        prefixIcon: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: SvgPicture.asset(
                'assets/images/icons/Search.svg',
                width: 15,
                height: 15,
                color: PsColors.mainDividerColor,
              ),
            ),
            onTap: () {
              clickSearchButton();
              // productParameterHolder.searchTerm = textEditingController.text;
              // Utils.psPrint(productParameterHolder.searchTerm);
              // Navigator.pushNamed(context, RoutePaths.filterProductList,
              //     arguments: ProductListIntentHolder(
              //         appBarTitle: Utils.getString(
              //             context, 'home_search__app_bar_title'),
              //         productParameterHolder: productParameterHolder));
            }),
      ),
      onSubmitted: (String value) {
        clickEnterFunction();
      },
    );

    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
            height: height,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color:
                  Utils.isLightMode(context) ? Colors.white60 : Colors.black54,
              borderRadius: BorderRadius.circular(PsDimens.space100),
            ),
            child: Center(
              child: _productTextFieldWidget,
            )),
      
      ],
    );
  }
}
