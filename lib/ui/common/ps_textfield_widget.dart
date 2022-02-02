import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PsTextFieldWidget extends StatelessWidget {
  const PsTextFieldWidget(
      {this.textEditingController,
      this.titleText = '',
      this.hintText,
      this.textAboutMe = false,
      this.height = PsDimens.space44,
      this.showTitle = true,
      this.maxLine = 1,
      this.isBorder = true,
      this.keyboardType = TextInputType.text,
      this.isStar = false});

  final TextEditingController textEditingController;
  final String titleText;
  final String hintText;
  final double height;
  final bool textAboutMe;
  final TextInputType keyboardType;
  final bool showTitle;
  final bool isStar;
  final bool isBorder;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    final Widget _productTextWidget =
        Text(titleText, style: Theme.of(context).textTheme.bodyText2);

    return Column(
      children: <Widget>[
        if (showTitle)
          Container(
            margin: const EdgeInsets.only(
                left: PsDimens.space12,
                top: PsDimens.space12,
                right: PsDimens.space12),
            child: Row(
              children: <Widget>[
                if (isStar)
                  Row(
                    children: <Widget>[
                      Text(titleText,
                          style: Theme.of(context).textTheme.bodyText2),
                      Text(' *',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: PsColors.mainColor))
                    ],
                  )
                else
                  _productTextWidget
              ],
            ),
          )
        else
          Container(
            height: 0,
          ),
        Container(
            width: double.infinity,
            height: height??52,
            margin: const EdgeInsets.all(PsDimens.space12),
            decoration: BoxDecoration(
              color: PsColors.backgroundColor,
              
              borderRadius: BorderRadius.circular(PsDimens.space4),
              // border: Border.all(color: PsColors.mainDividerColor.withOpacity(0.05)),
            ),
            child: TextField(
                keyboardType: keyboardType,
                maxLines: maxLine,
                textDirection: TextDirection.ltr,
                textAlign: Directionality.of(context) == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                controller: textEditingController,
                style: Theme.of(context).textTheme.bodyText1,
                decoration: textAboutMe
                    ? InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                          top: PsDimens.space10,
                        ),
                        
                        enabledBorder: isBorder?OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)):InputBorder.none,
                        border: isBorder? OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor)):InputBorder.none,
                        focusedBorder:isBorder? OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)):InputBorder.none,
                        
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      )
                    : InputDecoration(
                        contentPadding: const EdgeInsets.only(
                          left: PsDimens.space12,
                          bottom: PsDimens.space8,
                        ),
                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
                        border: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor)),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: PsColors.mainColor,)),
                        hintText: hintText,
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: PsColors.textPrimaryLightColor),
                      ))),
      ],
    );
  }
}
