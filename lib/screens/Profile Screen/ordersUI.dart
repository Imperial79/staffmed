import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';

class OrdersUI extends StatefulWidget {
  const OrdersUI({super.key});

  @override
  State<OrdersUI> createState() => _OrdersUIState();
}

class _OrdersUIState extends State<OrdersUI> {
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
      body: SingleChildScrollView(
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
            ordersTile(),
          ],
        ),
      ),
    );
  }

  Widget ordersTile() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              text: 'Delivered ',
              style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: sdp(context, 13)),
              children: [
                TextSpan(
                  text: 'on 19 Jan',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          height10,
          orderedProductTile(),
          orderedProductTile(),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {},
              child: Text(
                'See All',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
              ),
            ),
          ),
          Divider(),
          height10,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: kButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
                side: BorderSide(
                  color: kButtonColor,
                ),
              ),
            ),
            child: Text('Invoice'),
          ),
        ],
      ),
    );
  }

  Widget orderedProductTile() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Image.network(
            'https://5.imimg.com/data5/SELLER/Default/2022/8/QM/AX/SS/129887935/paracetamol-tablets-1000x1000.jpeg',
            height: sdp(context, 50),
          ),
          width10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paracetamol',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: sdp(context, 11)),
                ),
                Text(
                  '500mg | 1 Strip',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: sdp(context, 8.7)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
