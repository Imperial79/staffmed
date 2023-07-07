import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../screens/cartUI.dart';
import 'constants.dart';

SizedBox get height5 => SizedBox(height: 5);
SizedBox get height10 => SizedBox(height: 10);
SizedBox get height15 => SizedBox(height: 15);
SizedBox get height20 => SizedBox(height: 20);
SizedBox get height50 => SizedBox(height: 50);

SizedBox get width5 => SizedBox(width: 5);
SizedBox get width10 => SizedBox(width: 10);
SizedBox get width15 => SizedBox(width: 15);
SizedBox get width20 => SizedBox(width: 20);

Future<void> navPush(BuildContext context, Widget screen) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPushReplacement(BuildContext context, Widget screen) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

Future<void> navPopUntilPush(BuildContext context, Widget screen) {
  Navigator.popUntil(context, (route) => false);
  return navPush(context, screen);
}

Widget kBackButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      Navigator.pop(context);
    },
    icon: SvgPicture.asset(
      'lib/assets/icons/back.svg',
      height: sdp(context, 16),
    ),
  );
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
      systemNavigationBarIconBrightness: Brightness.dark,
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
        color: buttonColor ?? kButtonColor,
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
  int? maxLength,
  int? maxLines = 1,
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
            maxLength: maxLength,
            maxLines: maxLines,
            minLines: 1,
            decoration: InputDecoration(
              counterText: '',
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

Container fullScreenLoading(BuildContext context) {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    color: Colors.white.withOpacity(0.7),
    child: Lottie.asset(
      'lib/assets/icons/loading-animation.json',
      height: sdp(context, 100),
    ),
  );
}

void ShowSnackBar(
  BuildContext context, {
  required String content,
  bool? isDanger = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor:
          isDanger! ? const Color.fromARGB(255, 168, 28, 28) : primaryColor,
      dismissDirection: DismissDirection.vertical,
      content: Text(
        content,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    ),
  );
}

kAppbarTitle(BuildContext context, {required String title}) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: sdp(context, 13),
    ),
  );
}

class KOutlinedButton {
  static Widget short(
      {required void Function()? onPressed, required String label}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: kButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: kButtonColor,
          ),
        ),
      ),
      child: Text(label),
    );
  }

  static Widget expanded(
      {required void Function()? onPressed, required String label}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: kButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
          side: BorderSide(
            color: kButtonColor,
          ),
        ),
      ),
      child: Container(
        width: double.infinity,
        child: Text(
          label,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// Widget kOutlinedButton(
//     {required void Function()? onPressed, required String label}) {
//   return ElevatedButton(
//     onPressed: onPressed,
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.transparent,
//       foregroundColor: kButtonColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(7),
//         side: BorderSide(
//           color: kButtonColor,
//         ),
//       ),
//     ),
//     child: Text(label),
//   );
// }
