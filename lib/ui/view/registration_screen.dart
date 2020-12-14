import 'package:dice_app/ui/utils/colors.dart';
import 'package:dice_app/ui/utils/size_config.dart';
import 'package:dice_app/ui/widgets/text_dialog.dart';
import 'package:dice_app/utils/constants.dart';
import 'package:dice_app/view_model/base_model.dart';
import 'package:dice_app/view_model/registration_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';
import 'base_view.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegistrationScreenState();
  }
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController userNameController;
  TextEditingController nameController;
  TextEditingController passwordController;
  TextEditingController rePasswordController;

  GlobalKey _formKey;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    userNameController = TextEditingController();
    passwordController = TextEditingController();
    rePasswordController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return BaseView<RegistrationProvider>(
      builder:
          (BuildContext context, RegistrationProvider provider, Widget child) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.all(SizeConfig.getWidth(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Routes().pop('');
                    },
                    child: Icon(Icons.arrow_back_ios,
                        color: nextIconColor, size: SizeConfig.getHeight(3)),
                  ),
                  Expanded(
                      child: Center(
                          child: Text('registration'.tr(),
                              style: TextStyle(
                                  color: ratingTextBlueColor,
                                  fontSize: SizeConfig.getTextSize(6),
                                  fontWeight: FontWeight.w500)))),
                ]),
                SizedBox(
                  height: SizeConfig.getHeight(10),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      buildTextField('enter_username'.tr(), false,
                          userNameController, 'username'),
                      SizedBox(
                        height: SizeConfig.getHeight(2),
                      ),
                      buildTextField(
                          'enter_name'.tr(), false, nameController, 'name'),
                      SizedBox(
                        height: SizeConfig.getHeight(2),
                      ),
                      buildTextField('enter_password'.tr(), true,
                          passwordController, 'password'),
                      SizedBox(
                        height: SizeConfig.getHeight(2),
                      ),
                      buildTextField('enter_re_password'.tr(), true,
                          rePasswordController, 're-password'),
                      SizedBox(
                        height: SizeConfig.getHeight(2),
                      ),
                      buildRegisterButton(provider),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildTextField(
    String hintText,
    bool isPassword,
    TextEditingController controller,
    String key,
  ) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: SizeConfig.getWidth(3)),
          width: SizeConfig.getWidth(72),
          height: SizeConfig.getHeight(6),
          child: Center(
            child: TextFormField(
              key: ValueKey(key),
              textAlignVertical: TextAlignVertical.center,
              keyboardType: TextInputType.text,
              controller: controller,
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
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
                return validatorUtil(value, key);
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

  String validatorUtil(String val, String key) {
    String result;
    switch (key) {
      case 'username':
        if (val.isEmpty)
          result = 'pls_enter_username'.tr();
        else if (val.length < 3) result = 'username_must_3_length'.tr();
        break;
      case 'name':
        if (val.isEmpty) result = 'pls_enter_name'.tr();
        else if(val.length < 3) result = 'name_must_3_length'.tr();
        break;
      case 'password':
        if (val.isEmpty)
          result = 'pls_enter_password'.tr();
        else if (val.length < 4) result = 'password_must_4_length'.tr();
        break;
      case 're-password':
        if (val.isEmpty)
          result = 'pls_enter_re_password'.tr();
        else if (val.length < 4) result = 'password_must_4_length'.tr();
        break;
    }
    return result;
  }

  Widget buildRegisterButton(RegistrationProvider provider) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(SizeConfig.getWidth(2.0))),
      ),
      child: GestureDetector(
        onTap: () async {
          if ((_formKey.currentState as FormState).validate() &&
              provider.state == ViewState.Idle) {
            if (passwordController.text.toString() ==
                rePasswordController.text.toString()) {
              bool status = await provider.trySignUp(
                  userNameController.text.toString(),
                  nameController.text.toString(),
                  passwordController.text.toString());
              if (status) {
                TextDialog.showTextDialog(context, 'user_register_success'.tr(),
                    title: 'register'.tr(),
                    barrierDismissible: false, onPressed: () {
                  Routes().pop('');
                });
              } else {
                TextDialog.showTextDialog(
                    context,
                    provider.networkState == NETWORK_STATUS.NO_INTERNET
                        ? 'pls_connect_to_internet'.tr()
                        : provider.isUserAlreadyExists
                            ? 'username_already_exists'.tr()
                            : 'something_went_wrong');
              }
            } else {
              TextDialog.showTextDialog(context, 'password_not_match'.tr());
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
              provider.state == ViewState.Idle
                  ? 'register'.tr()
                  : 'pls_wait'.tr(),
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
    rePasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
