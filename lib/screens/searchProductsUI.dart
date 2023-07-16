import 'dart:developer';

import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/colors.dart';
import '../utils/sdp.dart';
import 'Cart screens/cartUI.dart';

class SearchProductsUI extends StatefulWidget {
  const SearchProductsUI({super.key});

  @override
  State<SearchProductsUI> createState() => _SearchProductsUIState();
}

class _SearchProductsUIState extends State<SearchProductsUI> {
  final searchKey = TextEditingController();
  bool isLoading = false;

  searchProduct(String val) async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
        uri: '/products/fetch-by-search.php', body: {'searchKey': val});
    log(dataResult.toString());
    if (!dataResult['error']) {
      searchedProductList = dataResult['response'];
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();

    searchKey.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 249, 252),
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'Search'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                searchBar(),
                height10,
                searchedProductList.length > 0
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Products found',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          width10,
                          Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(
                              minWidth: sdp(context, 23),
                              minHeight: sdp(context, 20),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: primaryColor),
                            child: FittedBox(
                              child: Text(
                                '${searchedProductList.length}',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                height20,
                searchedProductList.length > 0
                    ? ListView.builder(
                        itemCount: searchedProductList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return productListTile(
                              context, searchedProductList[index]);
                        },
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.5,
                              child: SvgPicture.asset(
                                'lib/assets/icons/search-medicines.svg',
                                height: sdp(context, 200),
                              ),
                            ),
                            height20,
                            Text(
                              "Search medicines",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: sdp(context, 16),
                                color: Colors.blueGrey.shade200,
                              ),
                            )
                          ],
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
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
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
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search medicines',
                hintStyle: TextStyle(
                  fontSize: sdp(context, 11),
                ),
              ),
            ),
          ),
          width10,
          TextButton(
            onPressed: () {
              searchProduct(searchKey.text);
            },
            child: Text('Search'),
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
