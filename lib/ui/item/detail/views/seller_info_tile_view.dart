import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/constant/route_paths.dart';
import 'package:flutterbuyandsell/provider/product/product_provider.dart';
import 'package:flutterbuyandsell/ui/common/ps_expansion_tile.dart';
import 'package:flutterbuyandsell/ui/common/ps_ui_widget.dart';
import 'package:flutterbuyandsell/ui/common/smooth_star_rating_widget.dart';
import 'package:flutterbuyandsell/utils/utils.dart';
import 'package:flutterbuyandsell/viewobject/holder/intent_holder/user_intent_holder.dart';
import 'package:flutterbuyandsell/viewobject/product.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerInfoTileView extends StatelessWidget {
  const SellerInfoTileView({
    Key key,
    @required this.itemDetail,
  }) : super(key: key);

  final ItemDetailProvider itemDetail;

  @override
  Widget build(BuildContext context) {
    final Widget _expansionTileTitleWidget = Text(
        Utils.getString(context, 'seller_info_tile__title'),
        style: Theme.of(context).textTheme.subtitle1);

    final Widget _expansionTileLeadingIconWidget = Icon(
      Entypo.address,
      color: PsColors.mainColor,
    );
    if (itemDetail != null &&
        itemDetail.itemDetail != null &&
        itemDetail.itemDetail.data != null) {
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, RoutePaths.userDetail,
              // arguments: itemDetail.itemDetail.data.addedUserId
              arguments: UserIntentHolder(
                  userId: itemDetail.itemDetail.data.addedUserId,
                  userName: itemDetail.itemDetail.data.user.userName));
        },
        child: Container(
          margin: const EdgeInsets.only(
              left: PsDimens.space12,
              right: PsDimens.space12,
              bottom: PsDimens.space12),
          decoration: BoxDecoration(
            color: PsColors.backgroundColor,
            borderRadius:
                const BorderRadius.all(Radius.circular(PsDimens.space8)),
          ),
          child: PsExpansionTile(
            initiallyExpanded: false,
            leading: _expansionTileLeadingIconWidget,
            title: _expansionTileTitleWidget,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Divider(
                    height: PsDimens.space1,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          top: PsDimens.space12,
                          bottom: PsDimens.space16,
                          left: PsDimens.space16,
                          right: PsDimens.space16),
                      child: ImageAndTextWidget(
                        data: itemDetail.itemDetail.data,
                        itemDetail: itemDetail,
                      )),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const Card();
    }
  }
}

class ImageAndTextWidget extends StatelessWidget {
  const ImageAndTextWidget({
    Key key,
    @required this.data,
    @required this.itemDetail,
  }) : super(key: key);

  final Product data;
  final ItemDetailProvider itemDetail;

  @override
  Widget build(BuildContext context) {
    const Widget _spacingWidget = SizedBox(
      height: PsDimens.space4,
    );

    // final Widget _imageWidget = PsNetworkCircleImageForUser(
    //   photoKey: '',
    //   imagePath: data.user.userProfilePhoto,
    //   width: 50,
    //   height: 50,
    //   boxfit: BoxFit.cover,
    //   onTap: () {
    //     Navigator.pushNamed(context, RoutePaths.userDetail,
    //         // arguments: data.addedUserId
    //         arguments: UserIntentHolder(
    //             userId: data.addedUserId, userName: data.user.userName));
    //   },
    // );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //_imageWidget,
        Container(
          width: 50,
          height: 50,
          child: PsNetworkCircleImageForUser(
            photoKey: '',
            imagePath: data.user.userProfilePhoto,
            // width: 50,
            // height: 50,
            boxfit: BoxFit.cover,
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.userDetail,
                  // arguments: data.addedUserId
                  arguments: UserIntentHolder(
                      userId: data.addedUserId, userName: data.user.userName));
            },
          ),
        ),
        const SizedBox(
          width: PsDimens.space12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  data.user.userName == ''
                      ? Utils.getString(context, 'default__user_name')
                      : data.user.userName,
                  style: Theme.of(context).textTheme.subtitle2),
              _spacingWidget,
              if (itemDetail.itemDetail.data.user.isShowPhone == '1')
                Visibility(
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.phone,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                      InkWell(
                        child: Text(
                          data.user.userPhone,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        onTap: () async {
                          if (data.user.userPhone != null &&
                              data.user.userPhone != '') {
                            if (await canLaunch(
                                'tel://${data.user.userPhone}')) {
                              await launch('tel://${data.user.userPhone}');
                            } else {
                              throw 'Could not Call Phone Number 1';
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                 if (itemDetail.itemDetail.data.user.isShowEmail == '1')
                Visibility(
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.email,
                      ),
                      const SizedBox(
                        width: PsDimens.space8,
                      ),
                    
                        Text(
                          data.user.userEmail,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                       
                      
                    ],
                  ),
                ),
              _spacingWidget,
              _RatingWidget(
                data: data,
              ),
              _spacingWidget,
              InkWell(
                child: Text(
                  data.user.addedDate == ''
                      ? ''
                      : Utils.getDateFormat(data.user.addedDate),
                  style: Theme.of(context).textTheme.bodyText1.copyWith(),
                ),
                onTap: () async {},
              ),
              _spacingWidget,
              _VerifiedWidget(
                data: data,
              )
            ],
          ),
        )
      ],
    );
  }
}

class _RatingWidget extends StatelessWidget {
  const _RatingWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Product data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          data.user.overallRating,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RoutePaths.ratingList,
                arguments: data.user.userId);
          },
          child: SmoothStarRating(
              key: Key(data.user.ratingDetail.totalRatingValue),
              rating: double.parse(data.user.ratingDetail.totalRatingValue),
              allowHalfRating: false,
              isReadOnly: true,
              starCount: 5,
              size: PsDimens.space16,
              color: Colors.yellow,
              borderColor: Colors.blueGrey[200],
              onRated: (double v) async {},
              spacing: 0.0),
        ),
        const SizedBox(
          width: PsDimens.space8,
        ),
        Text(
          '( ${data.user.ratingCount} )',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ],
    );
  }
}

class _VerifiedWidget extends StatelessWidget {
  const _VerifiedWidget({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Product data;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          Utils.getString(context, 'seller_info_tile__verified'),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        if (data.user.facebookVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.facebook_official,
            ),
          )
        else
          Container(),
        if (data.user.googleVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.google,
            ),
          )
        else
          Container(),
        if (data.user.phoneVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              FontAwesome.phone,
            ),
          )
        else
          Container(),
        if (data.user.emailVerify == '1')
          const Padding(
            padding:
                EdgeInsets.only(left: PsDimens.space4, right: PsDimens.space4),
            child: Icon(
              MaterialCommunityIcons.email,
            ),
          )
        else
          Container(),
      ],
    );
  }
}
