import 'dart:convert';

import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:calender_picker/calender_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/constants.dart';
import 'checkoutUI.dart';

class DateAndTimeUI extends StatefulWidget {
  final String totalPayable;
  const DateAndTimeUI({super.key, required this.totalPayable});

  @override
  State<DateAndTimeUI> createState() => _DateAndTimeUIState();
}

class _DateAndTimeUIState extends State<DateAndTimeUI> {
  bool isLoading = false;
  String selectedTime = '6:00 AM';
  String selectedDate = '';
  String dateRange = '';

  getOrderId() async {
    setState(() {
      isLoading = true;
    });
    Map add = UserData.addresses[defaultAddress];
    String formattedAddress = add['recipient'] +
        ', ' +
        add['phone'] +
        ', ' +
        add['address'] +
        ' - ' +
        add['pincode'];
    var dataResult = await ApiCallback(uri: '/orders/place-order.php', body: {
      'userId': UserData.id,
      'amount': widget.totalPayable,
      'productArray': jsonEncode(cartProducts),
      'quantityArray': jsonEncode(stockMap),
      'orderTimeSlot': selectedTime,
      'orderDateRange': dateRange,
      'shippingAddress': formattedAddress,
    });
    print(dataResult);
    if (!dataResult['error']) {
      navPush(
          context,
          CheckoutUI(
            orderId: dataResult['referenceId'],
          ));
    }
    ShowSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);

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
                    'Select time slot',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 13)),
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
                      children: [
                        timeButton('6:00 AM'),
                        timeButton('8:00 AM'),
                        timeButton('2:00 PM'),
                        timeButton('4:00 PM'),
                        timeButton('10:00 PM'),
                      ],
                    ),
                  ),
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
      bottomNavigationBar: selectedDate == ''
          ? SizedBox()
          : SafeArea(
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
                            getOrderId();
                          },
                          child: Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
