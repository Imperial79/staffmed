import 'package:apollo/utils/components.dart';
import 'package:flutter/material.dart';

class AboutusUI extends StatefulWidget {
  const AboutusUI({super.key});

  @override
  State<AboutusUI> createState() => _AboutusUIState();
}

class _AboutusUIState extends State<AboutusUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'About Us'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [],
          ),
        ),
      ),
    );
  }
}
