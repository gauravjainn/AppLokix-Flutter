import 'package:flutter/painting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/user/user_provider.dart';
import 'package:flutterbuyandsell/repository/user_repository.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget.dart';
import 'package:flutterbuyandsell/ui/common/ps_button_widget_with_round_corner.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutterbuyandsell/viewobject/common/ps_value_holder.dart';
import 'package:provider/provider.dart';

class IntroSliderView extends StatefulWidget {
  const IntroSliderView({@required this.settingSlider});
  final int settingSlider;
  @override
  @override
  _IntroSliderViewState createState() => _IntroSliderViewState();
}

class _IntroSliderViewState extends State<IntroSliderView>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  @override
  void initState() {
    _controller = TabController(vsync: this, length: 3);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserProvider userProvider;
  UserRepository userRepo;
  PsValueHolder psValueHolder;
  TabController _controller;

  @override
  Widget build(BuildContext context) {
    print(
        '............................Build UI Again ............................');
    userRepo = Provider.of<UserRepository>(context);
    psValueHolder = Provider.of<PsValueHolder>(context);
    _controller.animateTo(0);
    return ChangeNotifierProvider<UserProvider>(
        lazy: false,
        create: (BuildContext context) {
          userProvider =
              UserProvider(repo: userRepo, psValueHolder: psValueHolder);
          return userProvider;
        },
        child: Consumer<UserProvider>(builder:
            (BuildContext context, UserProvider provider, Widget child) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              body: TabBarView(controller: _controller, children: <Widget>[
                IntroSliderWidget(controller: _controller),
                //IntroSliderWidget(),
                IntroSliderSecondWidget(controller: _controller),
                IntroSliderDonotshowagainWidget(
                    provider: provider, settingSlider: widget.settingSlider)
              ]),
            ),
          );
        }));
  }
}

class IntroSliderWidget extends StatelessWidget {
  const IntroSliderWidget({this.controller});
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      color: const Color(0xffe1e5ec),
      child: Stack(children: <Widget>[
        Positioned.fill(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/icons/walkthroug1.png'),
                  fit: BoxFit.cover
                ),
                color: Color(0xffdde2ec)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // SizedBox(height: MediaQuery.of(context).size.height*0.165,),
                Column(
                  children: [
                    Text(
                      Utils.getString(context, 'let_create_together_the_best'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      Utils.getString(context, 'the_best'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space48,
                      top: PsDimens.space48,
                      right: PsDimens.space48),
                  child: Text(
                    Utils.getString(context, 'intro_slider_desc_1'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: PsColors.blackPurleColor,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: PsDimens.space12,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    if (psValueHolder.locationId != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.itemLocationList,
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_skip'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: PsColors.blackPurleColor,
                          ),
                    ),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.grey)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade500)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade500))
                ],
              ),
              InkWell(
                  onTap: () {
                    controller.animateTo(1);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_next'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: PsColors.blackPurleColor,
                          ),
                    ),
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}

class IntroSliderSecondWidget extends StatelessWidget {
  const IntroSliderSecondWidget({this.controller});
  final TabController controller;
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      color: const Color(0xffe1e5ec),
      child: Stack(children: <Widget>[
        Positioned.fill(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/icons/walkthroug2.png'),
                  fit: BoxFit.cover
                ),
                color: Color(0xffdde2ec)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // SizedBox(height: MediaQuery.of(context).size.height*0.165,),
                Column(
                  children: [
                    Text(
                      Utils.getString(context, 'intro_slider_title_2'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      Utils.getString(context, 'intro_slider_subtitle_2'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space48,
                      top: PsDimens.space48,
                      right: PsDimens.space48),
                  child: Text(
                    Utils.getString(context, 'intro_slider_desc_2'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: PsColors.blackPurleColor,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: PsDimens.space12,
          width: MediaQuery.of(context).size.width,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    if (psValueHolder.locationId != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.home,
                      );
                    } else {
                      Navigator.pushReplacementNamed(
                        context,
                        RoutePaths.itemLocationList,
                      );
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_skip'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: PsColors.blackPurleColor,
                          ),
                    ),
                  )),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade500)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: PsColors.grey)),
                  Container(
                      width: 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey.shade500))
                ],
              ),
              InkWell(
                  onTap: () {
                    controller.animateTo(2);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: PsDimens.space12,
                    ),
                    child: Text(
                      Utils.getString(context, 'intro_slider_next'),
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: PsColors.blackPurleColor,
                          ),
                    ),
                  ))
            ],
          ),
        ),
      ]),
    );
  }
}

class IntroSliderDonotshowagainWidget extends StatefulWidget {
  const IntroSliderDonotshowagainWidget(
      {@required this.provider, @required this.settingSlider});

  final UserProvider provider;
  final int settingSlider;
  @override
  _IntroSliderDonotshowagainWidgetState createState() =>
      _IntroSliderDonotshowagainWidgetState();
}

Future<void> updateCheckBox(
    BuildContext context, UserProvider provider, bool isCheckBoxSelect) async {
  if (isCheckBoxSelect) {
    provider.isCheckBoxSelect = false;
  } else {
    provider.isCheckBoxSelect = true;
  }
}

class _IntroSliderDonotshowagainWidgetState
    extends State<IntroSliderDonotshowagainWidget> {
  @override
  Widget build(BuildContext context) {
    final PsValueHolder psValueHolder =
        Provider.of<PsValueHolder>(context, listen: false);
    return Container(
      color: const Color(0xffe1e5ec),
      child: Stack(children: <Widget>[
        Positioned.fill(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/icons/walkthroug3.png'),
                  fit: BoxFit.cover
                ),
                color: Color(0xffdde2ec)),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // SizedBox(height: MediaQuery.of(context).size.height*0.165,),
                Column(
                  children: [
                    Text(
                      Utils.getString(context, 'intro_slider_title_3'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      Utils.getString(context, 'intro_slider_subtitle_3'),
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: PsColors.blackPurleColor,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: PsDimens.space48,
                      top: PsDimens.space48,
                      right: PsDimens.space48),
                  child: Text(
                    Utils.getString(context, 'intro_slider_desc_3'),
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: PsColors.blackPurleColor,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            bottom: PsDimens.space8,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: PsDimens.space12, right: PsDimens.space12),
              child: Column(
                children: <Widget>[
                  // Row(children: <Widget>[
                  //   Checkbox(
                  //       activeColor: PsColors.mainColor,
                  //       value: widget.provider.isCheckBoxSelect,
                  //       onChanged: (bool value) {
                  //         setState(() {
                  //           updateCheckBox(context, widget.provider,
                  //               widget.provider.isCheckBoxSelect);
                  //         });
                  //       }),
                  //   Expanded(
                  //     child: Text(
                  //       Utils.getString(
                  //           context, 'intro_slider_do_not_show_again'),
                  //       style: Theme.of(context).textTheme.bodyText1.copyWith(
                  //             color: PsColors.white,
                  //           ),
                  //     ),
                  //   ),
                  // ]),
                  InkWell(
                      onTap: () {
                        updateCheckBox(context, widget.provider,
                            widget.provider.isCheckBoxSelect);

                        if (widget.settingSlider == 1) {
                          Navigator.pop(context);
                        } else {
                          if (psValueHolder.locationId != null) {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.home,
                            );
                          } else {
                            Navigator.pushNamed(
                              context,
                              RoutePaths.itemLocationList,
                            );
                          }
                        }
                      },
                      child: Center(
                        child: Stack(
                          children: [
                            Container(
                                height: 70,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/icons/walkthroughbutton.svg',
                                    ),
                                    Center(
                                      child: Text(
                                        Utils.getString(
                                            context, 'start_adventure'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                              color: PsColors.white,
                                            )),
                                    ),
                                  ],
                                )),
                            // Positioned(
                            //     top: 20,
                            //     left: 0,
                            //     right: 0,
                            //     child: Container(
                            //       // width: 150,
                            //       child: Text(
                            //           Utils.getString(
                            //               context, 'start_adventure'),
                            //           style: Theme.of(context)
                            //               .textTheme
                            //               .subtitle1
                            //               .copyWith(
                            //                 color: PsColors.white,
                            //               )),
                            //     ))
                          ],
                        ),
                      )),
                  // PSButtonWidgetRoundCorner(
                  //   hasShadow: false,
                  //   width: double.infinity,
                  //   titleText:
                  //       Utils.getString(context, 'intro_slider_lets_explore'),
                  //   onPressed: () async {
                  //     if (widget.provider.isCheckBoxSelect) {
                  //       await widget.provider.replaceIsToShowIntroSlider(false);
                  //     }

                  //     if (widget.settingSlider == 1) {
                  //       Navigator.pop(context);
                  //     } else {
                  //       if (psValueHolder.locationId != null) {
                  //         Navigator.pushNamed(
                  //           context,
                  //           RoutePaths.home,
                  //         );
                  //       } else {
                  //         Navigator.pushNamed(
                  //           context,
                  //           RoutePaths.itemLocationList,
                  //         );
                  //       }
                  //     }
                  //   },
                  // ),
                ],
              ),
            )),
      ]),
    );
  }
}
