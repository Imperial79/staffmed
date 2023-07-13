import 'package:apollo/screens/Profile%20Screen/aboutusUI.dart';
import 'package:apollo/screens/Profile%20Screen/myAddressUI.dart';
import 'package:apollo/screens/Profile%20Screen/ordersUI.dart';
import 'package:apollo/screens/welcomeUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                UserData.fullname,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: sdp(context, 17),
                ),
              ),
              Text(
                '+91 ${UserData.phone}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              height20,
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      settingsTile(
                        onTap: () {
                          navPush(context, OrdersUI());
                        },
                        icon: 'order',
                        label: 'My Orders',
                      ),
                      settingsTile(
                        onTap: () {},
                        icon: 'presOrder',
                        size: 25,
                        label: 'Prescription Orders',
                      ),
                      settingsTile(
                        onTap: () {
                          navPush(context, MyAddresUI());
                        },
                        icon: 'address',
                        size: 25,
                        label: 'My Addresses',
                      ),
                      // settingsTile(
                      //   onTap: () {},
                      //   icon: 'order',
                      //   label: 'My Orders',
                      // ),
                      height10,
                      Divider(),
                      height10,
                      settingsTile(
                        onTap: () {
                          navPush(context, AboutusUI());
                        },
                        label: 'About Us',
                      ),
                      settingsTile(label: 'Privacy Policy'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: kSubmitButton(
            context,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return confirmLogout();
                },
              );
            },
            label: 'Log Out',
            buttonColor: kDangerColor,
          ),
        ),
      ),
    );
  }

  Widget confirmLogout() {
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      titlePadding: EdgeInsets.all(15),
      title: Text(
        'Do you really want to logout?',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: sdp(context, 15),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'No',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            await Hive.deleteBoxFromDisk('userData');
            Box userbox = await Hive.openBox('userData');
            print(userbox.get('phone'));
            navPopUntilPush(context, WelcomeUI());
          },
          child: Text('Yes'),
        ),
      ],
    );
  }

  Widget settingsTile({
    void Function()? onTap,
    String? icon,
    required String label,
    double? size,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              icon != null
                  ? Container(
                      width: sdp(context, 50),
                      padding: EdgeInsets.only(right: 20.0),
                      child: SvgPicture.asset(
                        'lib/assets/icons/$icon.svg',
                        height: sdp(context, size ?? 20),
                      ),
                    )
                  : SizedBox(),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 13,
              )
            ],
          ),
        ),
      ),
    );
  }
}
