import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';

class ChatNotiDialog extends StatefulWidget {
  const ChatNotiDialog(
      {Key key,
      this.description,
      this.leftButtonText,
      this.rightButtonText,
      this.onAgreeTap})
      : super(key: key);

  final String description, leftButtonText, rightButtonText;
  final Function onAgreeTap;

  @override
  _LogoutDialogState createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<ChatNotiDialog> {
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

  final ChatNotiDialog widget;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space4,
    );
    const Widget _largeSpacingWidget = SizedBox(
      height: PsDimens.space20,
    );
    final Widget _headerWidget = Row(
      children: <Widget>[
        _spacingWidget,
        const Icon(
          Icons.mail,
          color: Colors.white,
        ),
        _spacingWidget,
        Text(
          Utils.getString(context, 'chat_noti__new_message'),
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );

    final Widget _messageWidget = Text(
      widget.description,
      style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.black, fontWeight: FontWeight.w400),
    );
    return Dialog(
      backgroundColor: Colors.white,
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
          
          _largeSpacingWidget,
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(
                left: PsDimens.space16,
                right: PsDimens.space16,
                top: PsDimens.space8,
                bottom: PsDimens.space8),
            child: _messageWidget,
          ),
          _largeSpacingWidget,
          // Divider(
          //   color: Theme.of(context).iconTheme.color,
          //   height: 0.4,
          // ),
          Row(children: <Widget>[
            Expanded(
                child: MaterialButton(
              height: 48,
              minWidth: double.infinity,
              color:Colors.white ,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                widget.leftButtonText,
                style: Theme.of(context).textTheme.button.copyWith(color: PsColors.categoryStartColor),
              ),
            )),
            // Container(
            //     height: 50,
            //     width: 0.4,
            //     color: Theme.of(context).iconTheme.color),
            Expanded(
                child: MaterialButton(
              height: 48,
              color:PsColors.white ,
              minWidth: double.infinity,
              onPressed: () {
                Navigator.of(context).pop();
                widget.onAgreeTap();
              },
              child: Text(
                widget.rightButtonText,
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(color: PsColors.mainColor,fontWeight: FontWeight.w600),
              ),
            )),
          ])
        ],
      ),
    );
  }
}
