import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:the_apple_sign_in/apple_sign_in_button.dart' as apple;
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart' as Btn;
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:flutterbuyandsell/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    this.animationController,
    this.animation,
    this.onProfileSelected,
    this.onForgotPasswordSelected,
    this.onSignInSelected,
    this.onPhoneSignInSelected,
    this.onFbSignInSelected,
    this.onGoogleSignInSelected,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;
  final Function onProfileSelected,
      onForgotPasswordSelected,
      onSignInSelected,
      onPhoneSignInSelected,
      onFbSignInSelected,
      onGoogleSignInSelected;
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserRepository repo1;
  PsValueHolder psValueHolder;

  @override
  Widget build(BuildContext context) {
    widget.animationController.forward();
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space28,
    );

    repo1 = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);

    return SliverToBoxAdapter(
        child: ChangeNotifierProvider<UserProvider>(
      lazy: false,
      create: (BuildContext context) {
        final UserProvider provider =
            UserProvider(repo: repo1, psValueHolder: psValueHolder);
        print(provider.getCurrentFirebaseUser());
        return provider;
      },
      child: Consumer<UserProvider>(
          builder: (BuildContext context, UserProvider provider, Widget child) {
        return AnimatedBuilder(
          animation: widget.animationController,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: PsColors.coreBackgroundColor,
                image: const DecorationImage(
                    image: AssetImage('assets/images/icons/background.png'),
                    fit: BoxFit.fitHeight)),
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
                      children: [
                        _TextFieldAndSignInButtonWidget(
                          provider: provider,
                          text: Utils.getString(context, 'login__submit'),
                          onProfileSelected: widget.onProfileSelected,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: PsDimens.space36,
                            ),
                            // SizedBox(
                            //   height: MediaQuery.of(context).size.height * 0.12,
                            // ),
                            _DividerORWidget(),
                            const SizedBox(
                              height: PsDimens.space16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              // ignore: always_specify_types
                              children: [
                                if (PsConfig.showGoogleLogin)
                                  _LoginWithGoogleWidget(
                                      userProvider: provider,
                                      onGoogleSignInSelected:
                                          widget.onGoogleSignInSelected),
                                if (Utils.isAppleSignInAvailable == 1 &&
                                    Platform.isIOS)
                                  _LoginWithAppleIdWidget(
                                      onAppleIdSignInSelected:
                                          widget.onGoogleSignInSelected),
                                if (PsConfig.showFacebookLogin)
                                  _LoginWithFbWidget(
                                      userProvider: provider,
                                      onFbSignInSelected:
                                          widget.onFbSignInSelected),
                                if (PsConfig.showPhoneLogin)
                                  _LoginWithPhoneWidget(
                                    onPhoneSignInSelected:
                                        widget.onPhoneSignInSelected,
                                    provider: provider,
                                  ),
                              ],
                            ),
                            _spacingWidget,
                          ],
                        )
                      ],
                    ),
                  ),
                )

                // _HeaderIconAndTextWidget(),
                // ,
                // _spacingWidget,
                // _TermsAndConCheckbox(
                //   provider: provider,
                //   onCheckBoxClick: () {
                //     setState(() {
                //       updateCheckBox(context, provider);
                //     });
                //   },
                // ),
                // const SizedBox(
                //   height: PsDimens.space8,
                // ),
                // _ForgotPasswordAndRegisterWidget(
                //   provider: provider,
                //   animationController: widget.animationController,
                //   onForgotPasswordSelected: widget.onForgotPasswordSelected,
                //   onSignInSelected: widget.onSignInSelected,
                // ),
                // _spacingWidget,
              ],
            ),
          ),
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: widget.animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 100 * (1.0 - widget.animation.value), 0.0),
                    child: SingleChildScrollView(child: child)));
          },
        );
      }),
    ));
  }
}

class _TermsAndConCheckbox extends StatefulWidget {
  const _TermsAndConCheckbox(
      {@required this.provider, @required this.onCheckBoxClick});

  final UserProvider provider;
  final Function onCheckBoxClick;

  @override
  __TermsAndConCheckboxState createState() => __TermsAndConCheckboxState();
}

class __TermsAndConCheckboxState extends State<_TermsAndConCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: PsDimens.space20,
        ),
        Checkbox(
          activeColor: PsColors.mainColor,
          value: widget.provider.isCheckBoxSelect,
          onChanged: (bool value) {
            widget.onCheckBoxClick();
          },
        ),
        Expanded(
          child: InkWell(
            child: Text(
              Utils.getString(context, 'login__agree_privacy'),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            onTap: () {
              widget.onCheckBoxClick();
            },
          ),
        ),
      ],
    );
  }
}

void updateCheckBox(BuildContext context, UserProvider provider) {
  if (provider.isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;

    Navigator.pushNamed(context, RoutePaths.privacyPolicy, arguments: 1);
  }
}

class _HeaderIconAndTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _textWidget = Text(
      Utils.getString(context, 'app_name'),
      style: Theme.of(context)
          .textTheme
          .subtitle1
          .copyWith(fontWeight: FontWeight.bold, color: PsColors.mainColor),
    );

    final Widget _imageWidget = Container(
      width: 90,
      height: 90,
      child: Image.asset(
        'assets/images/flutter_buy_and_sell_logo.png',
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

class _TextFieldAndSignInButtonWidget extends StatefulWidget {
  const _TextFieldAndSignInButtonWidget({
    @required this.provider,
    @required this.text,
    this.onProfileSelected,
  });

  final UserProvider provider;
  final String text;
  final Function onProfileSelected;

  @override
  __CardWidgetState createState() => __CardWidgetState();
}

class __CardWidgetState extends State<_TextFieldAndSignInButtonWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const EdgeInsets _marginEdgeInsetsforCard = EdgeInsets.only(
        left: PsDimens.space16,
        right: PsDimens.space16,
        top: PsDimens.space4,
        bottom: PsDimens.space4);
    return Column(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: PsDimens.space32,
                right: PsDimens.space32,
                top: PsDimens.space8,
              ),
              child: Text(Utils.getString(context, 'login__title'),
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: const Color(0xff9292B8),
                        fontWeight: FontWeight.w800
                      )),
            ),
            const SizedBox(
              height: PsDimens.space24,
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
                controller: emailController,
                style: Theme.of(context).textTheme.bodyText1.copyWith(),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Utils.getString(context, 'login__email'),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: PsColors.textPrimaryLightColor, fontWeight: FontWeight.w400),
                    icon: SvgPicture.asset('assets/images/icons/mailicon.svg',
                        color:Theme.of(context).iconTheme.color.withOpacity(0.2))),
              ),
            ),
            const SizedBox(
              height: PsDimens.space24,
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
              child: TextField(
                controller: passwordController,
                obscureText: true,
                style: Theme.of(context).textTheme.button.copyWith(),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: Utils.getString(context, 'login__password'),
                    hintStyle: Theme.of(context)
                        .textTheme
                        .button
                 .copyWith(color: PsColors.textPrimaryLightColor, fontWeight: FontWeight.w400),
                    icon: SvgPicture.asset(
                        'assets/images/icons/passwordicon.svg',
                        color: Theme.of(context).iconTheme.color.withOpacity(0.2))),
                // keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: PsDimens.space40,
        ),
        Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space32, right: PsDimens.space32),
              child: PSButtonWidgetRoundCorner(
            hasShadow: true,
            width: double.infinity,
            titleText: Utils.getString(context, 'login__sign_in'),
            onPressed: () async {
              if (emailController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_email'));
              } else if (passwordController.text.isEmpty) {
                callWarningDialog(context,
                    Utils.getString(context, 'warning_dialog__input_password'));
              } else {
                if (Utils.checkEmailFormat(emailController.text.trim())) {
                  await widget.provider.loginWithEmailId(
                      context,
                      emailController.text.trim(),
                      passwordController.text,
                      widget.onProfileSelected);
                } else {
                  callWarningDialog(context,
                      Utils.getString(context, 'warning_dialog__email_format'));
                }
              }
            },
          ),
        ),
      ],
    );
  }
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

class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Expanded(
      child: Divider(
        height: PsDimens.space2,
        color: PsColors.white,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: PsDimens.space8,
    );

    final Widget _textWidget = Text(
      'Or Use',
      style: Theme.of(context).textTheme.subtitle2.copyWith(
            color: const Color(0xff9292B8),
          ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // _dividerWidget,
        // _spacingWidget,
        _textWidget,
        // _spacingWidget,
        // _dividerWidget,
      ],
    );
  }
}

class IconWidget extends StatelessWidget {
  final Widget icon;
  final Function onPressed;

  const IconWidget({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: icon,
        
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(1.5),
          
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(16)),
          shadowColor: MaterialStateProperty.all<Color>(Colors.blue.shade50.withOpacity(0.5)),
          backgroundColor:
              MaterialStateProperty.all(Colors.white), // <-- Button color
        ));
  }
}

class _LoginWithPhoneWidget extends StatefulWidget {
  const _LoginWithPhoneWidget(
      {@required this.onPhoneSignInSelected, @required this.provider});
  final Function onPhoneSignInSelected;
  final UserProvider provider;

  @override
  __LoginWithPhoneWidgetState createState() => __LoginWithPhoneWidgetState();
}

class __LoginWithPhoneWidgetState extends State<_LoginWithPhoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space24, right: PsDimens.space24),
      child: IconWidget(
        // titleText: Utils.getString(context, 'login__phone_signin'),
        icon: SvgPicture.asset(
          'assets/images/icons/phoneicon.svg',
          height: 28,
          color: PsColors.blackPurleColor,
        ),
        // colorData: widget.provider.isCheckBoxSelect
        //     ? PsColors.mainColor
        //     : PsColors.mainColor,
        onPressed: () async {
          if (widget.provider.isCheckBoxSelect) {
            if (widget.onPhoneSignInSelected != null) {
              widget.onPhoneSignInSelected();
            } else {
              Navigator.pushReplacementNamed(
                context,
                RoutePaths.user_phone_signin_container,
              );
            }
          } else {
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  return WarningDialog(
                    message: Utils.getString(
                        context, 'login__warning_agree_privacy'),
                    onPressed: () {},
                  );
                });
          }
        },
      ),
    );
  }
}

class _LoginWithFbWidget extends StatefulWidget {
  const _LoginWithFbWidget(
      {@required this.userProvider, @required this.onFbSignInSelected});
  final UserProvider userProvider;
  final Function onFbSignInSelected;

  @override
  __LoginWithFbWidgetState createState() => __LoginWithFbWidgetState();
}

class __LoginWithFbWidgetState extends State<_LoginWithFbWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space24,
          top: PsDimens.space8,
          right: PsDimens.space24),
      child: IconWidget(
          // titleText: Utils.getString(context, 'login__fb_signin'),
          icon: SvgPicture.asset(
            'assets/images/icons/facebookicon.svg',
            height: 24,
            color: PsColors.blackPurleColor,
          ), // colorData: widget.userProvider.isCheckBoxSelect == false
          //     ? PsColors.facebookLoginButtonColor
          //     : PsColors.facebookLoginButtonColor,
          onPressed: () async {
            await widget.userProvider
                .loginWithFacebookId(context, widget.onFbSignInSelected);
          }),
    );
  }
}

class _LoginWithGoogleWidget extends StatefulWidget {
  const _LoginWithGoogleWidget(
      {@required this.userProvider, @required this.onGoogleSignInSelected});
  final UserProvider userProvider;
  final Function onGoogleSignInSelected;

  @override
  __LoginWithGoogleWidgetState createState() => __LoginWithGoogleWidgetState();
}

class __LoginWithGoogleWidgetState extends State<_LoginWithGoogleWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          left: PsDimens.space24,
          top: PsDimens.space8,
          right: PsDimens.space24),
      child: IconWidget(
        // titleText: Utils.getString(context, 'login__google_signin'),
        icon: SvgPicture.asset(
          'assets/images/icons/googleicon.svg',
          height: 24,
          color: PsColors.blackPurleColor,
        ),
        // colorData: widget.userProvider.isCheckBoxSelect
        //     ? PsColors.googleLoginButtonColor
        //     : PsColors.googleLoginButtonColor,
        onPressed: () async {
          await widget.userProvider
              .loginWithGoogleId(context, widget.onGoogleSignInSelected);
        },
      ),
    );
  }
}

class _LoginWithAppleIdWidget extends StatelessWidget {
  const _LoginWithAppleIdWidget({@required this.onAppleIdSignInSelected});

  final Function onAppleIdSignInSelected;

  @override
  Widget build(BuildContext context) {
    final UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);

    return Container(
        margin: const EdgeInsets.only(
            left: PsDimens.space32,
            top: PsDimens.space8,
            right: PsDimens.space32),
        child: Directionality(
          // add this
          textDirection: TextDirection.ltr,
          child: apple.AppleSignInButton(
            style: apple.ButtonStyle.black, // style as needed
            type: apple.ButtonType.signIn, // style as needed

            onPressed: () async {
              await _userProvider.loginWithAppleId(
                  context, onAppleIdSignInSelected);
            },
          ),
        ));
  }
}

class _ForgotPasswordAndRegisterWidget extends StatefulWidget {
  const _ForgotPasswordAndRegisterWidget(
      {Key key,
      this.provider,
      this.animationController,
      this.onForgotPasswordSelected,
      this.onSignInSelected})
      : super(key: key);

  final AnimationController animationController;
  final Function onForgotPasswordSelected;
  final Function onSignInSelected;
  final UserProvider provider;

  @override
  __ForgotPasswordAndRegisterWidgetState createState() =>
      __ForgotPasswordAndRegisterWidgetState();
}

class __ForgotPasswordAndRegisterWidgetState
    extends State<_ForgotPasswordAndRegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: PsDimens.space40),
      margin: const EdgeInsets.all(PsDimens.space12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: InkWell(
              child: Ink(
                color: PsColors.backgroundColor,
                child: Text(
                  Utils.getString(context, 'login__forgot_password'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: PsColors.mainColor,
                      ),
                ),
              ),
              onTap: () {
                if (widget.onForgotPasswordSelected != null) {
                  widget.onForgotPasswordSelected();
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_forgot_password_container,
                  );
                }
              },
            ),
          ),
          Flexible(
            child: InkWell(
              child: Container(
                child: Ink(
                  color: PsColors.backgroundColor,
                  child: Text(
                    Utils.getString(context, 'login__sign_up'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.button.copyWith(
                          color: PsColors.mainColor,
                        ),
                  ),
                ),
              ),
              onTap: () async {
                if (widget.onSignInSelected != null) {
                  widget.onSignInSelected();
                } else {
                  final dynamic returnData =
                      await Navigator.pushReplacementNamed(
                    context,
                    RoutePaths.user_register_container,
                  );
                  if (returnData != null && returnData is User) {
                    final User user = returnData;
                    widget.provider.psValueHolder =
                        Provider.of<PsValueHolder>(context, listen: false);
                    widget.provider.psValueHolder.loginUserId = user.userId;
                    widget.provider.psValueHolder.userIdToVerify = '';
                    widget.provider.psValueHolder.userNameToVerify = '';
                    widget.provider.psValueHolder.userEmailToVerify = '';
                    widget.provider.psValueHolder.userPasswordToVerify = '';
                    Navigator.pop(context, user);
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * .03, size.height);
    path.quadraticBezierTo(
        size.width * .2, size.height * .5, 0, size.height * .03);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper old) => false;
}
