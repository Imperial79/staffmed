import 'dart:typed_data';
import 'package:apollo/screens/Prescription%20Screens/prescriptionCheckoutUI.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class UploadPresUI extends StatefulWidget {
  const UploadPresUI({super.key});

  @override
  State<UploadPresUI> createState() => _UploadPresUIState();
}

class _UploadPresUIState extends State<UploadPresUI> {
  List<Uint8List>? _imageList = [];
  List<XFile> imgDataList = [];
  XFile? imgData;
  bool isLoading = false;

  pickImage() async {
    imgData = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imgData != null) {
      imgDataList.add(imgData!);
      _imageList!.add(await imgData!.readAsBytes());
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: kAppbarTitle(context, title: 'Order by prescription'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              _imageList!.isEmpty
                  ? Center(
                      child: SvgPicture.asset(
                        'lib/assets/icons/prescription.svg',
                        height: sdp(context, 150),
                      ),
                    )
                  : SizedBox(),
              height20,
              _imageList!.isNotEmpty
                  ? Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: List.generate(
                              _imageList!.length,
                              (index) =>
                                  presImage(context, _imageList![index], index),
                            ),
                          ),
                        ),
                        height10,
                        TextButton(
                          onPressed: () {
                            pickImage();
                          },
                          child: Text(
                            'Upload more prescription',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              height20,
              ElevatedButton(
                onPressed: () {
                  // navPush(context, ConfirmPrescriptionUI());
                  if (_imageList!.isEmpty) {
                    pickImage();
                  } else {
                    navPush(
                        context,
                        PresCheckoutUI(
                          imageDataList: imgDataList,
                        ));
                    // uploadImages();
                    // _imageList = [];
                    // setState(() {});
                  }
                },
                child: Container(
                  width: double.infinity,
                  child: Text(
                    _imageList!.isEmpty ? 'Upload prescription' : 'Proceed',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              height20,
              Card(
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'All prescriptions uploaded are encrypted & visible only to our trusted pharmacists.\n\nAny prescription you upload is validated before processing the order.',
                    style: TextStyle(
                        fontSize: sdp(context, 10),
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget presImage(BuildContext context, final image, int index) {
    return Container(
      padding: EdgeInsets.all(6),
      height: sdp(context, 140),
      width: sdp(context, 100),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          image: MemoryImage(image),
        ),
      ),
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _imageList!.removeAt(index);
            imgDataList.removeAt(index);
          });
        },
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
      ),
    );
  }
}
