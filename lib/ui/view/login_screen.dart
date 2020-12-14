import 'package:dice_app/ui/utils/colors.dart';
import 'package:dice_app/ui/utils/size_config.dart';
import 'package:dice_app/ui/widgets/image_loader.dart';
import 'package:dice_app/ui/widgets/text_dialog.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/view_model/login_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';
import 'base_view.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController;
  TextEditingController passwordController;

  GlobalKey _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<LoginScreenProvider>(
      builder:
          (BuildContext context, LoginScreenProvider provider, Widget child) {
        return Stack(children: <Widget>[
          Opacity(
            opacity: 0.3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              //child: ImageLoader().loadFromAssets('bg.jpg')
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: ImageLoader().loadFromAssets('logo.png',
                        width: SizeConfig.getWidth(20),
                        height: SizeConfig.getWidth(20)),
                  ),
                  SizedBox(
                    height: SizeConfig.getWidth(3),
                  ),
                  Text(
                    'app_name'.tr(),
                    style: TextStyle(
                        fontSize: SizeConfig.getTextSize(10),
                        fontWeight: FontWeight.bold,
                        color: initialBlueColor),
                  ),
                  SizedBox(
                    height: SizeConfig.getHeight(10),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        buildTextField(
                            'enter_username'.tr(), false, userNameController),
                        SizedBox(
                          height: SizeConfig.getHeight(2),
                        ),
                        buildTextField(
                            'enter_password'.tr(), true, passwordController),
                        SizedBox(
                          height: SizeConfig.getHeight(2),
                        ),
                        buildLoginButton(provider),
                        SizedBox(
                          height: SizeConfig.getHeight(1),
                        ),
                        GestureDetector(
                          onTap: (){
                            Routes().navigateTo(context, REGISTRATION_SCREEN);
                          },
                          child: Center(
                            child: Text(
                              'not_sign_up_yet'.tr(),
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: ratingTextBlueColor,
                                  fontSize: SizeConfig.getTextSize(4.0),
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]);
      },
    );
  }

  Widget buildTextField(
    String hintText,
    bool isPassword,
    TextEditingController controller,
  ) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
          width: SizeConfig.getWidth(72),
          height: SizeConfig.getHeight(6),
          /*decoration: BoxDecoration(
              border: Border.all(
                  color: ratingBorderColor, width: SizeConfig.getWidth(0.5)),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
              color: whiteColor),*/
          child: Center(
            child: TextFormField(
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.symmetric(vertical: SizeConfig.getHeight(1)),
                isDense: true,
                hintText: hintText,
                //border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: SizeConfig.getTextSize(4.5),
                    color: nextIconColor),
              ),
              style: TextStyle(
                fontSize: SizeConfig.getTextSize(4.5),
              ),
              maxLines: 1,
              obscureText: isPassword,
              validator: (String value) {
                if (value.isEmpty)
                  return isPassword
                      ? 'Please enter password!'.tr()
                      : 'Please enter username!'.tr();
                return null;
              },
            ),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget buildLoginButton(LoginScreenProvider provider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
      ),
      child: GestureDetector(
        onTap: () async {
          if ((_formKey.currentState as FormState).validate()) {
            bool status = await provider.tryLoggingIn(
                userNameController.text.toString(),
                passwordController.text.toString());
            if (status) {
              Routes().navigateWithReplace(HOME_SCREEN);
            } else {
              TextDialog.showTextDialog(
                  context,
                  provider.networkState == NETWORK_STATUS.FAILURE
                      ? 'invalid_credentials'.tr()
                      : 'pls_connect_to_internet'.tr());
            }
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
          width: SizeConfig.getWidth(72),
          height: SizeConfig.getHeight(7),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [initialOrangeColor, endOrangeColor])),
          child: Center(
            child: Text(
              'login'.tr(),
              style: TextStyle(
                  color: whiteColor,
                  fontSize: SizeConfig.getTextSize(5.5),
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
