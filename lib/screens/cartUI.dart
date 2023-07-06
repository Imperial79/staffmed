import 'dart:developer';

import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartUI extends StatefulWidget {
  const CartUI({super.key});

  @override
  State<CartUI> createState() => _CartUIState();
}

class _CartUIState extends State<CartUI> {
  bool isCartEmpty = true;

  @override
  Widget build(BuildContext context) {
    isCartEmpty = cartList.length == 0;
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(
          context,
          title: 'My cart',
        ),
      ),
      body: Visibility(
        visible: !isCartEmpty,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recently added products',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              height20,
              Text(
                '${cartList.length} items added',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: sdp(context, 15),
                ),
              ),
              height20,
              ListView.builder(
                itemCount: cartList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return productTile(cartList[index]);
                },
              ),
            ],
          ),
        ),
        replacement: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/assets/icons/empty-cart.svg',
                height: sdp(context, 200),
              ),
              Text('Add products to the cart')
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: !isCartEmpty,
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total'),
                    Text(
                      '₹290',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              width10,
              ElevatedButton(
                onPressed: () {},
                child: Text('Continue'),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget productTile(Map data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            height: sdp(context, 35),
            width: sdp(context, 60),
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(data['image']), fit: BoxFit.contain),
            ),
          ),
          width5,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sdp(context, 10),
                  ),
                ),
                Text(
                  data['dose'] + "mg",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: sdp(context, 9),
                  ),
                ),
                height5,
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '₹' + data['discountedPrice'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 11),
                      ),
                    ),
                    width5,
                    Text(
                      '₹' + data['price'],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                        fontSize: sdp(context, 9),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    width10,
                    Text(
                      data['discount'] + "% off",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 48, 137, 51),
                        fontSize: sdp(context, 9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          width10,
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: primaryColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.horizontal_rule,
                    size: sdp(context, 13),
                  ),
                ),
                width10,
                Text(
                  "10",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                width10,
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.add,
                    size: sdp(context, 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
