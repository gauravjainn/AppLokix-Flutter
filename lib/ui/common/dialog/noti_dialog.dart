import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';

class NotiDialog extends StatefulWidget {
  const NotiDialog({this.message});
  final String message;
  @override
  _NotiDialogState createState() => _NotiDialogState();
}

class _NotiDialogState extends State<NotiDialog> {
  @override
  Widget build(BuildContext context) {
    return NewDialog(widget: widget);
  }
}

class NewDialog extends StatelessWidget {
  const NewDialog({
    Key key,
    @required this.widget,
  }) : super(key: key);

  final NotiDialog widget;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  // border: Border.all(color: PsColors.mainColor, width: 5),
                  color: PsColors.white),
              child: Center(
                child: SvgPicture.asset('assets/images/icons/NotificationPopUp.svg', height: 72,)
                  
              )),
          const SizedBox(height: PsDimens.space32),
          Container(
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: Text(
              widget.message,
              style: TextStyle(color: PsColors.black),
            ),
          ),
          const SizedBox(height: PsDimens.space32),
          // Divider(
            
          //   height: 1,
          // ),
          MaterialButton(
            height: 48,
            minWidth: double.infinity,
            color:PsColors.white ,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              Utils.getString(context, 'dialog__ok'),
              style: TextStyle(
                  color: PsColors.mainColor),
            ),
          )
        ],
      ),
    );
  }
}
