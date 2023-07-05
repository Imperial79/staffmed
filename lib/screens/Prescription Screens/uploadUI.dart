import 'package:apollo/screens/Prescription%20Screens/confirmPrescriptionUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UploadPresUI extends StatefulWidget {
  const UploadPresUI({super.key});

  @override
  State<UploadPresUI> createState() => _UploadPresUIState();
}

class _UploadPresUIState extends State<UploadPresUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your prescriptions',
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: sdp(context, 13)),
            ),
            height5,
            Text(
              'and let us arrange the medicines for you',
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            height20,
            Center(
              child: SvgPicture.asset(
                'lib/assets/icons/prescription.svg',
                height: sdp(context, 150),
              ),
            ),
            height20,
            Center(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  presImage(context),
                  presImage(context),
                  // presImage(context),
                  // presImage(context),
                ],
              ),
            ),
            height10,
            Center(
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Upload more prescription',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            height20,
            ElevatedButton(
              onPressed: () {
                navPush(context, ConfirmPrescriptionUI());
              },
              child: Container(
                width: double.infinity,
                child: Text(
                  'Upload prescription',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            height20,
            Card(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  'All prescriptions uploaded are encrypted & visible only to our trusted pharmacists.\n\nAny prescription yopu upload is validated before processing the order.',
                  style: TextStyle(
                    fontSize: sdp(context, 10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container presImage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      height: sdp(context, 140),
      width: sdp(context, 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          image: NetworkImage(
              'https://www.myopd.in/blog/wp-content/uploads/2020/02/myopd-sample-rx-eng.png'),
        ),
      ),
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 13,
        child: FittedBox(
          child: Icon(
            Icons.close,
            size: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
