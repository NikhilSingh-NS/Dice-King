import 'package:dice_app/ui/utils/colors.dart';
import 'package:dice_app/ui/utils/size_config.dart';
import 'package:dice_app/ui/view/base_view.dart';
import 'package:dice_app/ui/widgets/animate_counter.dart';
import 'package:dice_app/ui/widgets/circular_widget.dart';
import 'package:dice_app/ui/widgets/image_loader.dart';
import 'package:dice_app/ui/widgets/text_dialog.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/view_model/base_model.dart';
import 'package:dice_app/view_model/home_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Widget getTextWidgetForStatText(String text, {Color color = whiteColor}) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: SizeConfig.getTextSize(3.5)),
      textAlign: TextAlign.center,
    );
  }

  Widget getHeaderText(String text) {
    return Text(
      text,
      style: TextStyle(
          color: textColor,
          fontSize: SizeConfig.getTextSize(6),
          fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(body: BaseView<HomeScreenProvider>(builder:
        (BuildContext context, HomeScreenProvider provider, Widget child) {
      provider.getUserStats();
      return provider.isReady
          ? provider.networkState == NETWORK_STATUS.SUCCESS
              ? Container(
                  color: homeBgColor,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  EdgeInsets.only(top: SizeConfig.getHeight(2)),
                              child: Stack(children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        tryLogOut(provider);
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left:
                                                      SizeConfig.getWidth(5.0),
                                                  top:
                                                      SizeConfig.getWidth(1.0)),
                                              child: Icon(Icons.exit_to_app,
                                                  color: nextIconColor,
                                                  size:
                                                      SizeConfig.getHeight(3))),
                                          SizedBox(
                                            height: SizeConfig.getHeight(0.5),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: SizeConfig.getWidth(5.0),
                                                top: SizeConfig.getWidth(1.0)),
                                            child: Center(
                                                child: Text('log_out'.tr(),
                                                    style: TextStyle(
                                                      color: textColor,
                                                      fontSize: SizeConfig
                                                          .getTextSize(4),
                                                    ))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Center(
                                        child: Text('app_name'.tr(),
                                            style: TextStyle(
                                                color: textColor,
                                                fontSize:
                                                    SizeConfig.getTextSize(8),
                                                fontWeight: FontWeight.w500))),
                                    SizedBox(
                                      height: SizeConfig.getHeight(0.5),
                                    ),
                                    Center(
                                        child: Text('(${provider.versionName})',
                                            style: TextStyle(
                                              color: textColor,
                                              fontSize:
                                                  SizeConfig.getTextSize(4),
                                            ))),
                                  ],
                                )
                              ]),
                            ),
                            buildUserInfo(provider),
                            buildUserStatsInfo(provider),
                            SizedBox(
                              height: SizeConfig.getHeight(2),
                            ),
                            Center(
                                child: GestureDetector(
                                    onTap: () {
                                      Routes().navigateTo(
                                          context, LEADERBOARD_SCREEN);
                                    },
                                    child: buildStadiumBorderWidget(
                                        'check_leaderboard'.tr(),
                                        width: SizeConfig.getWidth(60))))
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: 7,
                              child: Container(
                                child: Center(
                                  child: provider.state == ViewState.Idle
                                      ? Text(
                                          provider.userStats.lastScore
                                              .toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.getTextSize(25)),
                                        )
                                      : CircularProgressIndicator(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: buildRollButton(provider),
                            ),
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Center(
                  child: provider.networkState == NETWORK_STATUS.NO_INTERNET
                      ? Text('pls_connect_to_internet'.tr())
                      : Text('something_went_wrong'.tr()),
                )
          : Center(
              child: CircularProgressIndicator(),
            );
    }));
  }

  Widget buildUserInfo(HomeScreenProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.getWidth(5.0)),
            child: CircularWidget(
              borderColor: whiteColor,
              borderStrokeWidth: 0.5,
              height: SizeConfig.getWidth(30.0),
              width: SizeConfig.getWidth(30.0),
              child: ImageLoader().load(sampleImageUrl),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(SizeConfig.getWidth(1.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                getHeaderText(provider.userStats.name),
                SizedBox(
                  height: SizeConfig.getHeight(2),
                ),
                buildStadiumBorderWidget(
                  '#${provider.userStats.username}',
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildStadiumBorderWidget(String lbl, {double width}) {
    return Container(
      height: SizeConfig.getHeight(5),
      width: width == null ? SizeConfig.getWidth(38) : width,
      decoration: ShapeDecoration(
          shape: StadiumBorder(
              side: BorderSide(
            color: ratingBorderColor,
          )),
          color: Colors.white),
      padding: EdgeInsets.all(SizeConfig.getWidth(2)),
      child: Text(
        lbl,
        style: TextStyle(
            color: ratingTextBlueColor,
            fontSize: SizeConfig.getTextSize(4.5),
            fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildUserStatsInfo(HomeScreenProvider provider) {
    return Container(
      height: SizeConfig.getHeight(9.0),
      //padding: EdgeInsets.all(SizeConfig.getWidth(1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0))),
            child: Container(
              width: SizeConfig.getWidth(28),
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
                  AnimatedCount(
                      count: provider.userStats.totalScore,
                      duration: Duration(milliseconds: 500)),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText('total_score'.tr()),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1.0,
          ),
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            child: Container(
              width: SizeConfig.getWidth(28),
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
                  AnimatedCount(
                    count: provider.userStats.attemptLeft,
                    duration: Duration(milliseconds: 500),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText('attempt_left'.tr()),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 1.0,
          ),
          Card(
            elevation: 3.0,
            margin: EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
            ),
            child: Container(
              width: SizeConfig.getWidth(28),
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
                  AnimatedCount(
                    count: provider.userStats.maxScore,
                    duration: Duration(milliseconds: 500),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  getTextWidgetForStatText('session_max'.tr()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void tryLogOut(HomeScreenProvider provider) {
    TextDialog.showTextDialog(context, 'log_out_msg'.tr(),
        title: 'log_out'.tr(), onPressed: () async {
      await provider.logout();
      Routes().navigateWithReplace(LOGIN_SCREEN);
    },
        isNeedToAvoidOnPressCallOnBackPress: true,
        cancelButtonText: 'cancel'.tr());
  }

  Widget buildRollButton(HomeScreenProvider provider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
      ),
      child: GestureDetector(
        onTap: () async {
          if (provider.userStats.attemptLeft > 0 &&
              provider.state == ViewState.Idle) {
            bool status = await provider.rollTheDice();
            if (!status) {
              TextDialog.showTextDialog(
                  context,
                  provider.networkState == NETWORK_STATUS.FAILURE
                      ? 'something_went_wrong'.tr()
                      : 'pls_connect_to_internet'.tr());
            }
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
          width: SizeConfig.getWidth(80),
          height: SizeConfig.getHeight(7),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  provider.userStats.attemptLeft == 0
                      ? Colors.grey.withOpacity(0.9)
                      : initialBlueColor,
                  provider.userStats.attemptLeft == 0
                      ? Colors.grey.withOpacity(0.2)
                      : endBlueColor
                ],
              )),
          child: Center(
            child: Text(
              'roll_a_dice'.tr(),
              style: TextStyle(
                  color: provider.userStats.attemptLeft == 0
                      ? Colors.grey.withOpacity(0.6)
                      : whiteColor,
                  fontSize: SizeConfig.getTextSize(5.5),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
