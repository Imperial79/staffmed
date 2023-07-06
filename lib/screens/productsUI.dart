import 'dart:developer';

import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/colors.dart';
import '../utils/sdp.dart';
import 'cartUI.dart';

class ProductsUI extends StatefulWidget {
  const ProductsUI({super.key});

  @override
  State<ProductsUI> createState() => _ProductsUIState();
}

class _ProductsUIState extends State<ProductsUI> {
  final searchKey = TextEditingController();

  searchProduct(String val) async {
    var dataResult = await ApiCallback(
        uri: '/products/fetch-by-search.php', body: {'searchKey': val});
    log(dataResult.toString());
    if (!dataResult['error']) {
      searchedProductList = dataResult['response'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 228, 235, 238),
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'Search'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchBar(),
            height10,
            Text(
              'Products found (${searchedProductList.length})',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            height20,
            ListView.builder(
              itemCount: searchedProductList.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return productListTile(context, searchedProductList[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'search',
            child: SvgPicture.asset(
              'lib/assets/icons/search.svg',
              height: sdp(context, 15),
              colorFilter: svgColor(Colors.grey),
            ),
          ),
          width10,
          Flexible(
            child: TextField(
              controller: searchKey,
              autofocus: true,
              onSubmitted: (val) {
                searchProduct(val);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search medicines',
                hintStyle: TextStyle(
                  fontSize: sdp(context, 11),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget productListTile(BuildContext context, Map data) {
    bool inCart = cartProductIds.contains(data['id'].toString());

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: sdp(context, 55),
                    width: sdp(context, 80),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.contain),
                    ),
                  ),
                  width10,
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          data['company'],
                          style: TextStyle(
                            fontSize: sdp(context, 8),
                          ),
                        ),
                        Text(
                          data['dose'] + 'mg',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: sdp(context, 9),
                            color: Colors.grey.shade600,
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
                  width5,
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: data['availability'] == 'Out-of-Stock'
                ? Text(
                    'Out\nof\nstock',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 7),
                        color: Colors.red),
                    textAlign: TextAlign.center,
                  )
                : GestureDetector(
                    onTap: () {
                      if (data['availability'] != 'Out-of-Stock') {
                        if (!inCart) {
                          addToCart(context, data['id'], setState);

                          setState(() {
                            cartProductIds.add(data['id'].toString());
                          });
                        } else {
                          navPush(context, CartUI());
                        }
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor:
                          inCart ? primaryColorAccent : Colors.green,
                      child: inCart
                          ? SvgPicture.asset(
                              'lib/assets/icons/cart.svg',
                              colorFilter: svgColor(
                                  inCart ? primaryColor : Colors.green),
                            )
                          : Icon(
                              Icons.add,
                              color: inCart ? Colors.green : Colors.white,
                            ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
