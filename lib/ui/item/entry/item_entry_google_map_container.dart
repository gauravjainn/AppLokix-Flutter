// import 'package:flutterbuyandsell/config/ps_colors.dart';
// import 'package:flutterbuyandsell/config/ps_config.dart';
// import 'package:flutterbuyandsell/ui/item/entry/item_entry_google_map_view.dart';
// import 'package:flutterbuyandsell/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutterbuyandsell/viewobject/product.dart';

// class ItemEntryGoogleMapContainerView extends StatefulWidget {
//   const ItemEntryGoogleMapContainerView({
//     @required this.flag,
//     @required this.item,
//   });
//   final String flag;
//   final Product item;
//   @override
//   ItemEntryGoogleMapContainerViewState createState() => ItemEntryGoogleMapContainerViewState();
// }

// class ItemEntryGoogleMapContainerViewState extends State<ItemEntryGoogleMapContainerView>
//     with SingleTickerProviderStateMixin {
//   AnimationController animationController;
//   @override
//   void initState() {
//     animationController =
//         AnimationController(duration: PsConfig.animation_duration, vsync: this);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Future<bool> _requestPop() {
//       animationController.reverse().then<dynamic>(
//         (void data) {
//           if (!mounted) {
//             return Future<bool>.value(false);
//           }
//           Navigator.pop(context, true);
//           return Future<bool>.value(true);
//         },
//       );
//       return Future<bool>.value(false);
//     }

//     print(
//         '............................Build UI Again ............................');
//     return WillPopScope(
//       onWillPop: _requestPop,
//       child: Scaffold(
//         appBar: AppBar(
//           brightness: Utils.getBrightnessForAppBar(context),
//           backgroundColor: PsColors.backgroundColor,
//           iconTheme: Theme.of(context)
//               .iconTheme
//               .copyWith(color: PsColors.mainColorWithWhite),
//           title: Text(
//             Utils.getString(context, 'item_entry__listing_entry'),
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.headline6.copyWith(
//                 fontWeight: FontWeight.bold,
//                 color: PsColors.mainColorWithWhite),
//           ),
//           elevation: 0,
//         ),
//         body: ItemEntryGoogleMapView(
//           animationController: animationController,
//           flag: widget.flag,
//           item: widget.item,
//         ),
//       ),
//     );
//   }
// }
