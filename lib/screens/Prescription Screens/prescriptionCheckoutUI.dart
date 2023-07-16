import 'dart:convert';

import 'package:apollo/screens/Prescription%20Screens/confirmPrescriptionUI.dart';
import 'package:calender_picker/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';
import '../../utils/components.dart';
import '../../utils/constants.dart';
import '../../utils/sdp.dart';
import '../Profile Screen/myAddressUI.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class PresCheckoutUI extends StatefulWidget {
  final List<XFile> imageDataList;
  const PresCheckoutUI({super.key, required this.imageDataList});

  @override
  State<PresCheckoutUI> createState() => _PresCheckoutUIState();
}

class _PresCheckoutUIState extends State<PresCheckoutUI> {
  bool isLoading = false;
  String selectedTime = '6:00';
  String selectedDate = '';
  String dateRange = '';

  Future<void> uploadImages() async {
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          'https://indiatvonline.in/staffmed/medicine-assets/upload-prescription-controller.php'),
    );

    for (var imagePath in widget.imageDataList) {
      var file = await http.MultipartFile.fromPath(
        'prescriptionsImgs[]',
        imagePath.path,
        contentType: MediaType.parse(lookupMimeType(imagePath.path)!),
      );
      request.files.add(file);
    }

    var response = await request.send();
    var dataResult = jsonDecode(await response.stream.bytesToString());

    if (!dataResult['error']) {
      List imageLinksList = dataResult['imageLinks'];
      Map add = UserData.addresses[defaultAddress];
      String formattedAddress = add['recipient'] +
          ', ' +
          add['phone'] +
          ', ' +
          add['address'] +
          ' - ' +
          add['pincode'];
      var res = await ApiCallback(
          uri: '/orders/place-prescription-orders.php',
          body: {
            'userId': UserData.id,
            'prescriptionArray': jsonEncode(imageLinksList),
            'orderTimeSlot': selectedTime,
            'orderDateRange': dateRange,
            'shippingAddress': formattedAddress,
          });
      if (!res['error']) {
        navPush(
          context,
          ConfirmPrescriptionUI(orderId: res['referenceId']),
        );
      }
      ShowSnackBar(context, content: res['message'], isDanger: res['error']);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'Schedule delivery'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                height20,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Select date\nas per your convienience',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 13)),
                  ),
                ),
                height20,
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CalenderPicker(
                    DateTime.now(),
                    daysCount: 6,
                    height: sdp(context, 70),
                    selectionColor: primaryColor,
                    onDateChange: (date) {
                      setState(() {
                        dateRange = date.toString().split(' ').first;
                        selectedDate = DateFormat('d MMMM').format(date);
                      });
                    },
                  ),
                ),
                height20,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Available time slot(s)',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 13),
                    ),
                  ),
                ),
                height20,
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        timeSlots.length,
                        (index) {
                          int adv4Hour =
                              DateTime.now().add(Duration(hours: 4)).hour;

                          if (DateTime.now().toString().split(" ").first ==
                              dateRange) {
                            if (adv4Hour <= timeSlots[index] && adv4Hour != 0) {
                              selectedTime =
                                  timeSlots[index].toString() + ":00";
                              return timeButton(
                                  timeSlots[index].toString() + ":00");
                            }
                            selectedTime = '0';
                            return SizedBox();
                          }

                          return timeButton(
                              timeSlots[index].toString() + ":00");
                        },
                      ),
                    ),
                  ),
                ),
                height20,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    'Select address',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 13),
                    ),
                  ),
                ),
                height10,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: UserData.addresses.isNotEmpty
                      ? deliveryAddress(context)
                      : KOutlinedButton.expanded(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyAddresUI()))
                                .then((value) {
                              setState(() {});
                            });
                          },
                          label: 'Add Address'),
                ),
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: fullScreenLoading(context),
          ),
        ],
      ),
      bottomNavigationBar: selectedDate != '' &&
              selectedTime != '0' &&
              UserData.addresses.isNotEmpty
          ? SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Divider(),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your order will be delivered by',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                selectedDate + ', ' + selectedTime,
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (!isLoading) {
                              uploadImages();
                            }
                          },
                          child: Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(),
    );
  }

  Widget deliveryAddress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'lib/assets/icons/delivery.svg',
              height: sdp(context, 20),
            ),
            width10,
            Text(
              'Delivery to',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            width10,
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyAddresUI()))
                    .then((value) {
                  setState(() {});
                });
              },
              child: Text('Change'),
            ),
          ],
        ),
        height5,
        Text(
          UserData.addresses[defaultAddress]['recipient'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: sdp(context, 10),
          ),
        ),
        Text(
          "+91 " + UserData.addresses[defaultAddress]['phone'],
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: sdp(context, 10),
          ),
        ),
        Text(
          UserData.addresses[defaultAddress]['address'] +
              " - " +
              UserData.addresses[defaultAddress]['pincode'],
          style: TextStyle(
            // fontWeight: FontWeight.w500,
            fontSize: sdp(context, 9),
          ),
        ),
      ],
    );
  }

  Widget timeButton(String label) {
    bool isSelected = selectedTime == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = label;
        });
      },
      child: Card(
        color: isSelected ? const Color.fromARGB(255, 96, 76, 14) : null,
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            label,
            style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
