import 'dart:io';

import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutter/material.dart';

class PsBackButtonWithCircleBgWidget extends StatelessWidget {
  const PsBackButtonWithCircleBgWidget({Key key, this.isReadyToShow})
      : super(key: key);

  final bool isReadyToShow;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isReadyToShow,
      child: Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space12, right: PsDimens.space4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: PsColors.black.withAlpha(100),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(left: Platform.isIOS ? PsDimens.space8: PsDimens.space8),
            child: InkWell(
                child: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back_ios,
                  color: PsColors.white,
                  size: 16,
                ),
                onTap: () {
                  Navigator.pop(context);
                }),
          ),
        ),
      ),
    );
  }
}
