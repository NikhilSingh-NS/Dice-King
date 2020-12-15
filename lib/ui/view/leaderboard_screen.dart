import 'package:dice_app/model/user_stats.dart';
import 'package:dice_app/ui/utils/colors.dart';
import 'package:dice_app/ui/utils/size_config.dart';
import 'package:dice_app/ui/view/base_view.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/view_model/leaderboard_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class LeaderBoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LeaderBoardScreenState();
  }
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<LeaderBoardProvider>(
        onModelReady: (LeaderBoardProvider provider) {
      provider.setUserStatsList();
    }, builder:
            (BuildContext context, LeaderBoardProvider provider, Widget child) {
      return provider.isReady
          ? provider.networkState == NETWORK_STATUS.SUCCESS
              ? Container(
                  margin: EdgeInsets.fromLTRB(SizeConfig.getWidth(2),
                      SizeConfig.getHeight(1), SizeConfig.getWidth(2), 0),
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Routes().pop('');
                          },
                          child: Icon(Icons.arrow_back_ios,
                              color: nextIconColor,
                              size: SizeConfig.getHeight(3)),
                        ),
                        Expanded(
                            child: Center(
                                child: Text('leader_board'.tr(),
                                    style: TextStyle(
                                        color: ratingTextBlueColor,
                                        fontSize: SizeConfig.getTextSize(6),
                                        fontWeight: FontWeight.w500)))),
                      ]),
                      SizedBox(
                        height: SizeConfig.getHeight(4),
                      ),
                      buildList(provider)
                    ],
                  ),
                )
              : Center(
                  child: provider.networkState == NETWORK_STATUS.NO_INTERNET
                      ? Text('pls_connect_to_internet'.tr())
                      : Text('something_went_wrong'.tr()),
                )
          : Center(child: CircularProgressIndicator());
    });
  }

  Widget buildList(LeaderBoardProvider leaderBoardProvider) {
    return Container(
      height: SizeConfig.getHeight(84),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        elevation: 3.0,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: controller,
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.getHeight(8.0)),
                child: ListView.separated(
                    shrinkWrap: true,
                    controller: controller,
                    itemCount: leaderBoardProvider.userStatsList.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 0.5,
                        color: Colors.black,
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      UserStats userStats =
                          leaderBoardProvider.userStatsList[index];
                      final bool isCurrentUser = userStats.username ==
                          leaderBoardProvider.currentUserName;
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: SizeConfig.getWidth(4.0)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: getListTextItem(
                                    '#${(index + 1).toString()}',
                                    isCurrentUser)),
                            Expanded(
                                flex: 2,
                                child: getListTextItem(
                                    userStats.username, isCurrentUser)),
                            Expanded(
                                flex: 2,
                                child: getListTextItem(
                                    userStats.name, isCurrentUser)),
                            Expanded(
                                flex: 1,
                                child: getListTextItem(
                                    userStats.totalScore.toString(),
                                    isCurrentUser))
                          ],
                        ),
                      );
                    }),
              ),
            ),
            buildHeader(leaderBoardProvider)
          ],
        ),
      ),
    );
  }

  Widget buildHeader(LeaderBoardProvider provider) {
    return Container(
      height: SizeConfig.getHeight(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Card(
              elevation: 3.0,
              margin: EdgeInsets.all(1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(20.0))),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[initialOrangeColor, endOrangeColor],
                        tileMode: TileMode.repeated)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getTextWidgetForStatText('rank'.tr()),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 3.0,
              margin: EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[initialBlueColor, endBlueColor],
                        tileMode: TileMode.repeated)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getTextWidgetForStatText('user_name'.tr()),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Card(
              elevation: 3.0,
              margin: EdgeInsets.all(1.0),
              child: Container(
                decoration: BoxDecoration(
                    //borderRadius:BorderRadius.only(topLeft: Radius.circular(20.0), bottomLeft: Radius.circular(20.0)),
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[initialBlueColor, endBlueColor],
                        tileMode: TileMode.repeated)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getTextWidgetForStatText('name'.tr()),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Card(
              elevation: 3.0,
              margin: EdgeInsets.all(1.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: <Color>[initialPeachColor, endPeachColor],
                        tileMode: TileMode.repeated)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    getTextWidgetForStatText('score'.tr()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getTextWidgetForStatText(String text, {Color color = whiteColor}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: SizeConfig.getTextSize(3.5)),
      textAlign: TextAlign.center,
    );
  }

  Widget getListTextItem(String text, bool isCurrentUser) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.getHeight(2.0)),
      child: Text(
        text,
        style: TextStyle(
            color: isCurrentUser
                ? ratingTextBlueColor
                : Colors.black.withOpacity(0.8),
            fontSize: SizeConfig.getTextSize(4.5),
            fontWeight: isCurrentUser ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
