import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

SizedBox get height5 => SizedBox(height: 5);
SizedBox get height10 => SizedBox(height: 10);
SizedBox get height15 => SizedBox(height: 15);
SizedBox get height20 => SizedBox(height: 20);
SizedBox get height50 => SizedBox(height: 50);

SizedBox get width5 => SizedBox(width: 5);
SizedBox get width10 => SizedBox(width: 10);
SizedBox get width15 => SizedBox(width: 15);
SizedBox get width20 => SizedBox(width: 20);

navPush(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

navPushReplacement(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

systemColors() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
      overlays: [SystemUiOverlay.top]);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
}

Widget kSubmitButton(
  BuildContext context, {
  void Function()? onTap,
  required String label,
  Color? buttonColor,
  Color? textColor,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: buttonColor ?? primaryColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Container(
        width: double.infinity,
        child: Text(
          label,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: sdp(context, 12),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

Widget kTextField(
  BuildContext context, {
  TextEditingController? controller,
  String? hintText,
  TextInputType? keyboardType,
  String? prefixText,
  bool obscureText = false,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: Colors.grey.shade600),
    ),
    child: Row(
      children: [
        prefixText != null
            ? Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Text(
                  prefixText,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: sdp(context, 11),
                  ),
                ),
              )
            : SizedBox(),
        Flexible(
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: sdp(context, 11),
              fontWeight: FontWeight.w500,
            ),
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: sdp(context, 11),
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
