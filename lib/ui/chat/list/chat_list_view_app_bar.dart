import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutterbuyandsell/config/ps_colors.dart';
import 'package:flutterbuyandsell/constant/ps_dimens.dart';
import 'package:flutterbuyandsell/utils/utils.dart';

class ChatListViewAppBar extends StatefulWidget {
  const ChatListViewAppBar(
      {this.selectedIndex = 0,
      this.showElevation = true,
      this.iconSize = 24,
      @required this.items,
      @required this.onItemSelected})
      : assert(items != null),
        assert(items.length >= 2 && items.length <= 5),
        assert(onItemSelected != null);

  @override
  _ChatListViewAppBarState createState() {
    return _ChatListViewAppBarState(
        selectedIndexNo: selectedIndex,
        items: items,
        iconSize: iconSize,
        onItemSelected: onItemSelected);
  }

  final int selectedIndex;
  final double iconSize;
  final bool showElevation;
  final List<ChatListViewAppBarItem> items;
  final ValueChanged<int> onItemSelected;
}

class _ChatListViewAppBarState extends State<ChatListViewAppBar> {
  _ChatListViewAppBarState(
      {@required this.items,
      this.iconSize,
      this.selectedIndexNo,
      @required this.onItemSelected});

  final double iconSize;
  List<ChatListViewAppBarItem> items;
  int selectedIndexNo;

  ValueChanged<int> onItemSelected;

  Widget _buildItem(ChatListViewAppBarItem item, bool isSelected) {
    return AnimatedContainer(
      width: PsDimens.space160
      ,
      height: double.maxFinite,
      padding:const  EdgeInsets.all(16),
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: PsDimens.space12),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
            Utils.getShadow(context)
        ],
        color: isSelected
            ? PsColors.categoryBackgroundColor
            : Utils.isLightMode(context) ?Colors.white: PsColors.backgroundColor,
        // borderRadius: const BorderRadius.all(Radius.circular(50)),
      ),
      child: Center(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset('assets/images/icons/chat.svg',
              color: isSelected ? item.activeColor : item.inactiveColor, height: 18,),
          const SizedBox(
            width: PsDimens.space4,
          ),
          Text(
            item.title,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: isSelected ? item.activeColor : null),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    selectedIndexNo = widget.selectedIndex;
    return Container(
      decoration: BoxDecoration(
          color: PsColors.baseColor,
          boxShadow: <BoxShadow>[
            if (widget.showElevation)
              const BoxShadow(color: Colors.black12, blurRadius: 2)
          ]),
      child: Container(
            margin: const EdgeInsets.only(
                top: PsDimens.space16,bottom: PsDimens.space16,
                left: PsDimens.space8, right: PsDimens.space8 ),
            width: double.infinity,
            height: 48,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      onItemSelected(0);
                      setState(() {
                        selectedIndexNo = 0;
                      });
                    },
                    child: _buildItem(items[0], selectedIndexNo == 0),
                  ),
                  InkWell(
                    onTap: () {
                      onItemSelected(1);
                      setState(() {
                        selectedIndexNo = 1;
                      });
                    },
                    child: _buildItem(items[1], selectedIndexNo == 1),
                  )
              ],
            ),
            //  ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     shrinkWrap: true,
            //     itemCount: 2,
            //     itemBuilder: (BuildContext context, int index) {
            //       final ChatListViewAppBarItem item = items[index];
            //       return InkWell(
            //         onTap: () {
            //           onItemSelected(index);
            //           setState(() {
            //             selectedIndexNo = index;
            //           });
            //         },
            //         child: _buildItem(item, selectedIndexNo == index),
            //       );
            //     })

            //  Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: items.map((ChatListViewAppBarItem item) {
            //     final int index = items.indexOf(item);
            //     return InkWell(
            //       onTap: () {
            //         onItemSelected(index);
            //         setState(() {
            //           selectedIndexNo = index;
            //         });
            //       },
            //       child: _buildItem(item, selectedIndexNo == index),
            //     );
            //   }).toList(),
            // ),
            ),
    );
  }
}

class ChatListViewAppBarItem {
  ChatListViewAppBarItem(
      {@required this.title,
      Color activeColor,
      Color activeBackgroundColor,
      Color inactiveColor,
      Color inactiveBackgroundColor})
      : assert(title != null),
        activeColor = activeColor ?? PsColors.mainColor,
        activeBackgroundColor =
            activeBackgroundColor ?? PsColors.mainLightColor,
        inactiveColor = inactiveColor ?? PsColors.grey,
        inactiveBackgroundColor =
            inactiveBackgroundColor ?? PsColors.grey.withOpacity(0.2);

  final String title;
  final Color activeColor;
  final Color activeBackgroundColor;
  final Color inactiveColor;
  final Color inactiveBackgroundColor;
}
