import 'package:apollo/screens/homeUI.dart';
import 'package:apollo/utils/animated-indexed-stack.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  int activeTab = 0;

  List<Widget> screens = [
    HomeUI(),
    HomeUI(),
    HomeUI(),
  ];

  List<String> svIcons = [
    'lib/assets/icons/home-filled.svg',
    'lib/assets/icons/prescrip.svg',
    'lib/assets/icons/profile.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIndexedStack(
        index: activeTab,
        children: screens,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 100,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navIcon(0, 'home'),
              navIcon(1, 'upload'),
              navIcon(2, 'profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget navIcon(
    int index,
    String label,
  ) {
    bool isSelected = activeTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? primaryColor : Colors.transparent),
        child: SvgPicture.asset(
          svIcons[index],
          height: sdp(context, 20),
          colorFilter: svgColor(isSelected ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
