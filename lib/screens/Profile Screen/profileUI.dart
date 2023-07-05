import 'package:apollo/screens/Profile%20Screen/ordersUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                'John Doe',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: sdp(context, 17),
                ),
              ),
              Text(
                '+91 909XXXX234',
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
                        onTap: () {},
                        icon: 'address',
                        size: 25,
                        label: 'My Addresses',
                      ),
                      settingsTile(
                        onTap: () {},
                        icon: 'order',
                        label: 'My Orders',
                      ),
                      height10,
                      Divider(),
                      height10,
                      settingsTile(label: 'About Us'),
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
          padding: const EdgeInsets.all(10.0),
          child: kSubmitButton(context,
              label: 'Log Out', buttonColor: Color.fromARGB(255, 182, 48, 38)),
        ),
      ),
    );
  }

  Widget settingsTile({
    void Function()? onTap,
    String? icon,
    required String label,
    double? size,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
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
    );
  }
}
