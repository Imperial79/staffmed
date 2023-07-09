import 'dart:developer';

import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersUI extends StatefulWidget {
  const OrdersUI({super.key});

  @override
  State<OrdersUI> createState() => _OrdersUIState();
}

class _OrdersUIState extends State<OrdersUI> {
  bool isLoading = false;
  List seeAllList = [];

  @override
  void initState() {
    super.initState();
    fetchOrdersHistory();
  }

  fetchOrdersHistory() async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
      uri: '/orders/fetch-order-history.php',
      body: {
        'userId': UserData.id,
      },
    );

    log(dataResult['response'][0].toString());

    if (!dataResult['error']) {
      orderHistoryList = dataResult['response'];
      setState(() {});
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
        title: kAppbarTitle(
          context,
          title: 'My Orders',
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Previously Ordered items',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sdp(context, 13),
                  ),
                ),
                height20,
                ListView.builder(
                  itemCount: orderHistoryList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ordersTile(orderHistoryList[index]);
                  },
                )
              ],
            ),
          ),
          Visibility(
            visible: isLoading,
            child: fullScreenLoading(context),
          ),
        ],
      ),
    );
  }

  Widget ordersTile(Map data) {
    String status = '';

    if (data['isPaid'] == 'Pending') {
      status = "Paymant Pending";
    } else {
      status = data['status'];
    }
    return AnimatedSize(
      alignment: Alignment.bottomCenter,
      curve: Curves.ease,
      duration: Duration(milliseconds: 300),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ordered on ' +
                  DateFormat('yMMMd').format(DateTime.parse(data['date'])),
            ),
            Text(
              status,
              style: TextStyle(
                color: status == 'Delivered'
                    ? Colors.green.shade700
                    : Color.fromARGB(255, 208, 156, 35),
                fontWeight: FontWeight.w600,
              ),
            ),
            height10,
            ListView.builder(
              itemCount: data['orderedProducts'].length > 2 &&
                      !seeAllList.contains(data['id'])
                  ? 2
                  : data['orderedProducts'].length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return orderedProductTile(data['orderedProducts'][index]);
              },
            ),
            Align(
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () {
                  setState(() {
                    if (seeAllList.contains(data['id'])) {
                      seeAllList.remove(data['id']);
                    } else {
                      seeAllList.add(data['id']);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: kButtonColor),
                  child: Text(
                    seeAllList.contains(data['id']) ? 'See Less' : 'See All',
                    style: TextStyle(
                      fontSize: sdp(context, 8),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order total',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  "₹ " + data['amount'],
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Divider(),
            height10,
            Visibility(
              visible: seeAllList.contains(data['id']),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Address',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 10)),
                  ),
                  Text(
                    data['shippingAddress'],
                    style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: sdp(context, 8)),
                  ),
                ],
              ),
            ),
            height10,
            KOutlinedButton.expanded(onPressed: () {}, label: 'Invoice'),
          ],
        ),
      ),
    );
  }

  Widget orderedProductTile(Map data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: sdp(context, 50),
                  height: sdp(context, 40),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        data['image'],
                      ),
                    ),
                  ),
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sdp(context, 11)),
                      ),
                      Text(
                        '${data['dose']}mg | ${data['quantity']} pc',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: sdp(context, 8.7)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          width10,
          Text(
            "₹ " + data['salePrice'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
