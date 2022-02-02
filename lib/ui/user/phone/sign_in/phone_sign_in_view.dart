import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/error_dialog.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/utils/ps_progress_dialog.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/verify_phone_internt_holder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhoneSignInView extends StatefulWidget {
  const PhoneSignInView(
      {Key key,
      this.animationController,
      this.goToLoginSelected,
      this.phoneSignInSelected})
      : super(key: key);
  final AnimationController animationController;
  final Function goToLoginSelected;
  final Function phoneSignInSelected;
  @override
  _PhoneSignInViewState createState() => _PhoneSignInViewState();
}

class _PhoneSignInViewState extends State<PhoneSignInView>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  UserRepository repo1;
  PsValueHolder psValueHolder;
  AnimationController animationController;
  @override
  void initState() {
    animationController =
        AnimationController(duration: PsConfig.animation_duration, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.5 * 1, 1.0, curve: Curves.fastOutSlowIn)));

    animationController.forward();
    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
      child: ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          final UserProvider provider =
              UserProvider(repo: repo1, psValueHolder: psValueHolder);
          return provider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return Container(
               height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: PsColors.coreBackgroundColor,
                image: const DecorationImage(
                    image: AssetImage('assets/images/icons/background.png'),
                    fit: BoxFit.fill) 
              ),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                      top: PsDimens.space64, left: PsDimens.space16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/images/icons/cloxx.svg',
                        // width: 150,  
                        height: 38,

                      ),
                      const SizedBox(height: PsDimens.space12,),
                      Text(
                          Utils.getString(
                              context, 'let_create_together_the_best'),
                          textWidthBasis: TextWidthBasis.parent,
                          style: Theme.of(context)
                              .textTheme.headline5.copyWith(color: PsColors.blackPurleColor, fontWeight: FontWeight.w400)),
                              const SizedBox(height: PsDimens.space8,),
                      Text(Utils.getString(context, 'the_best'),
                          style: Theme.of(context)
                              .primaryTextTheme.
                              headline5.copyWith(color: PsColors.blackPurleColor, fontWeight: FontWeight.w600)),
                              const SizedBox(height: PsDimens.space12,),
                              
                      Text(Utils.getString(context, 'Join_the_community'),
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(color: PsColors.colorBtn,fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
                
                
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.33,
                  
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        
                        
                        _CardWidget(
                          nameController: nameController,
                          phoneController: phoneController,
                        ),
                        const SizedBox(
                          height: PsDimens.space24,
                        ),
                        _SendButtonWidget(
                          provider: provider,
                          nameController: nameController,
                          phoneController: phoneController,
                          phoneSignInSelected: widget.phoneSignInSelected,
                        ),
                        const SizedBox(
                          height: PsDimens.space64,
                        ),
                        _TextWidget(
                            goToLoginSelected: widget.goToLoginSelected),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _TextWidget extends StatefulWidget {
  const _TextWidget({this.goToLoginSelected});
  final Function goToLoginSelected;
  @override
  __TextWidgetState createState() => __TextWidgetState();
}

class __TextWidgetState extends State<_TextWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:PsDimens.space28, right: PsDimens.space28),
      child: PSButtonWidgetRoundCorner(
        // width: MediaQuery.of(context).size.width*0.5,
        // child: Ink(
        //   color: PsColors.backgroundColor,
          titleText:
          //  Text(
            Utils.getString(context, 'phone_signin__back_login'),
            // style: Theme.of(context)
            //     .textTheme
            //     .bodyText2
            //     .copyWith(color: PsColors.mainColor),
          
        
      
      onPressed: () {
        if (widget.goToLoginSelected != null) {
          widget.goToLoginSelected();
        } else {
          Navigator.pushReplacementNamed(
            context,
            RoutePaths.login_container,
          );
        }
      },
      ),
    );
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context).textTheme.subtitle1.copyWith(
            color: PsColors.mainColor,
          ),
    );

    final Widget _imageWidget = Container(
      // width: 90,
      // height: 90,
      child: SvgPicture.asset(
        'assets/images/icons/cloxx.svg',
        height: 42,
      ),
    );
    return Column(
      children: <Widget>[
        const SizedBox(
          height: PsDimens.space32,
        ),
        _imageWidget,
        const SizedBox(
          height: PsDimens.space8,
        ),
        _textWidget,
        const SizedBox(
          height: PsDimens.space52,
        ),
      ],
    );
  }
}

class _CardWidget extends StatelessWidget {
  const _CardWidget(
      {@required this.nameController, @required this.phoneController});

  final TextEditingController nameController;
  final TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
         Padding(
              padding: const EdgeInsets.only(
                left: PsDimens.space32,
                right: PsDimens.space32,
                top: PsDimens.space8,
                bottom: PsDimens.space12
              ),
              child: Text(Utils.getString(context, 'home_phone_signin'),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: const Color(0xff9292B8),
                        fontWeight: FontWeight.w800
                      )),
            ),
        Container(
          margin: _marginEdgeInsetsforCard,
          padding: const EdgeInsets.only(
                  left: PsDimens.space24,
                  right: PsDimens.space24,
                  top: PsDimens.space6,
                  bottom: PsDimens.space6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Utils.isLightMode(context)
                            ? Colors.blue.shade50.withOpacity(0.5)
                            : PsColors.mainShadowColor,
                        offset: const Offset(0, 1),
                        blurRadius: 1.0,
                        spreadRadius: 1.0),
                  ]),
              
          child: TextField(
            controller: nameController,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: Utils.getString(context, 'register__user_name'),
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: PsColors.textPrimaryLightColor, fontWeight: FontWeight.w400),
                icon: Icon(Icons.people,
                    color: Theme.of(context).iconTheme.color.withOpacity(0.2))),
          ),
        ),
        const SizedBox(
          height: PsDimens.space16,
        ),
        Container(
          margin: _marginEdgeInsetsforCard,
          padding: const EdgeInsets.only(
                  left: PsDimens.space24,
                  right: PsDimens.space24,
                  top: PsDimens.space6,
                  bottom: PsDimens.space6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Utils.isLightMode(context)
                            ? Colors.blue.shade50.withOpacity(0.5)
                            : PsColors.mainShadowColor,
                        offset: const Offset(0, 2),
                        blurRadius: 2.0,
                        spreadRadius: 1.0),
                  ]),
              
          child: Directionality(
              textDirection: Directionality.of(context) == TextDirection.ltr
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: TextField(
                controller: phoneController,
                textDirection: TextDirection.ltr,
                textAlign: Directionality.of(context) == TextDirection.ltr
                    ? TextAlign.left
                    : TextAlign.right,
                style: Theme.of(context).textTheme.button.copyWith(),
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '+959123456789',
                    hintStyle: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: PsColors.textPrimaryLightColor, fontWeight: FontWeight.w400),
                    icon: Icon(Icons.phone,
                        color: Theme.of(context).iconTheme.color.withOpacity(0.2))),
                // keyboardType: TextInputType.number,
              )),
        ),
      ],
    );
  }
}

class _SendButtonWidget extends StatefulWidget {
  const _SendButtonWidget(
      {@required this.provider,
      @required this.nameController,
      @required this.phoneController,
      @required this.phoneSignInSelected});
  final UserProvider provider;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final Function phoneSignInSelected;

  @override
  __SendButtonWidgetState createState() => __SendButtonWidgetState();
}

dynamic callWarningDialog(BuildContext context, String text) {
  showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return WarningDialog(
          message: Utils.getString(context, text),
          onPressed: () {},
        );
      });
}

class __SendButtonWidgetState extends State<_SendButtonWidget> {
  Future<String> verifyPhone() async {
    String verificationId;
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
      PsProgressDialog.dismissDialog();
      print('code has been send');

      if (widget.phoneSignInSelected != null) {
        widget.phoneSignInSelected(widget.nameController.text,
            widget.phoneController.text, verificationId);
      } else {
        Navigator.pushReplacementNamed(
            context, RoutePaths.user_phone_verify_container,
            arguments: VerifyPhoneIntentHolder(
                userName: widget.nameController.text,
                phoneNumber: widget.phoneController.text,
                phoneId: verificationId));
      }
    };
    final PhoneVerificationCompleted verifySuccess = (AuthCredential user) {
      print('verify');
      PsProgressDialog.dismissDialog();
    };
    final PhoneVerificationFailed verifyFail =
        (FirebaseAuthException exception) {
      print('${exception.message}');
      PsProgressDialog.dismissDialog();
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: '${exception.message}',
            );
          });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneController.text,
        codeAutoRetrievalTimeout: autoRetrieve,
        codeSent: smsCodeSent,
        timeout: const Duration(minutes: 2),
        verificationCompleted: verifySuccess,
        verificationFailed: verifyFail);
    return verificationId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space32, right: PsDimens.space32),
      child: PSButtonWidgetRoundCorner(
          hasShadow: true,
          width: double.infinity,
          titleText: Utils.getString(context, 'login__phone_signin'),
          onPressed: () async {
            if (widget.nameController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_name'));
            } else if (widget.phoneController.text.isEmpty) {
              callWarningDialog(context,
                  Utils.getString(context, 'warning_dialog__input_phone'));
            } else {
              await PsProgressDialog.showDialog(context);
              await verifyPhone();
            }
          }),
    );
  }
}
