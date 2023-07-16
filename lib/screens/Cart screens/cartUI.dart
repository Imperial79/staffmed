import 'package:apollo/screens/Cart%20screens/ordersCheckoutUI.dart';
import 'package:apollo/screens/Profile%20Screen/myAddressUI.dart';
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
  bool isloading = false;

  double total = 0.0;
  double totalPayable = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  calculateBillSummary() {
    total = 0;
    totalPayable = 0;

    for (var i = 0; i < cartProducts.length; i++) {
      total += stockMap[cartProducts[i]['id']] *
          double.parse(cartProducts[i]['price'].toString());

      totalPayable += stockMap[cartProducts[i]['id']] *
          double.parse(cartProducts[i]['discountedPrice'].toString());
    }

    setState(() {});
  }

  fetchCartItems() async {
    setState(() {
      isloading = true;
    });
    var dataResult = await ApiCallback(
        uri: '/products/fetch-cart.php', body: {'userId': UserData.id});
    if (!dataResult['error']) {
      cartProducts = dataResult['response'];
      cartProductIds = dataResult['idsArray'];

      cartProductIds.forEach((element) {
        if (!stockMap.containsKey(element)) {
          stockMap[element] = 1;
        }
      });

      setState(() {
        isloading = false;
      });
    }

    calculateBillSummary();
  }

  removeProduct(String prodId) async {
    setState(() {
      isloading = true;
    });
    var dataResult = await ApiCallback(
        uri: '/products/remove-from-cart.php',
        body: {'userId': UserData.id, 'productId': prodId});

    cartProducts.remove(prodId);
    cartProductIds.remove(prodId);

    ShowSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);

    fetchCartItems();
    setState(() {
      isloading = false;
    });

    calculateBillSummary();
  }

  @override
  Widget build(BuildContext context) {
    isCartEmpty = cartProducts.length == 0;
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(
          context,
          title: 'My cart',
        ),
      ),
      body: Stack(
        children: [
          Visibility(
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
                    '${cartProducts.length} items added',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 15),
                    ),
                  ),
                  height20,
                  ListView.builder(
                    itemCount: cartProducts.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return productTile(cartProducts[index]);
                    },
                  ),
                  Divider(),
                  height10,
                  Text(
                    'Bill summary',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  height10,
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Item total',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '₹ ' + total.toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Total discount',
                                  style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                '- ₹ ' +
                                    (total - totalPayable).toStringAsFixed(2),
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Delivery fee',
                                  style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                'Free',
                                style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  height10,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Total payable',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: sdp(context, 13)),
                          ),
                        ),
                        Text(
                          '₹ ' + totalPayable.toStringAsFixed(2),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: sdp(context, 13)),
                        ),
                      ],
                    ),
                  ),
                  // height10,
                  // Divider(),
                  // height10,
                  // UserData.addresses.isNotEmpty
                  //     ? deliveryAddress(context)
                  //     : KOutlinedButton.expanded(
                  //         onPressed: () {
                  //           Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => MyAddresUI()));
                  //         },
                  //         label: 'Add Address'),
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
          Visibility(
            visible: isloading,
            child: fullScreenLoading(context),
          ),
        ],
      ),
      bottomNavigationBar: Visibility(
        visible: !isCartEmpty,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Total payable'),
                          Text(
                            '₹ ' + totalPayable.toStringAsFixed(2),
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    width10,
                    ElevatedButton(
                      onPressed: () {
                        // if (UserData.addresses.isEmpty) {
                        //   ShowSnackBar(context,
                        //       content: 'Please add an address first!');
                        // } else {
                        navPush(
                          context,
                          ordersCheckoutUI(
                              totalPayable: totalPayable.toStringAsFixed(2)),
                        );
                        // }
                      },
                      child: Text('Continue'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget productTile(Map data) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
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
                      onTap: () {
                        if (stockMap[data['id']] > 1) {
                          setState(() {
                            stockMap[data['id']] -= 1;
                          });
                          calculateBillSummary();
                        }
                      },
                      child: Icon(
                        Icons.horizontal_rule,
                        size: sdp(context, 13),
                      ),
                    ),
                    width10,
                    Text(
                      stockMap[data['id']].toString(),
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    width10,
                    InkWell(
                      onTap: () {
                        if (stockMap[data['id']] < 5) {
                          setState(() {
                            stockMap[data['id']] += 1;
                          });

                          calculateBillSummary();
                        }
                      },
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
          // height10,
          InkWell(
            onTap: () {
              removeProduct(data['id']);
            },
            child: Text(
              'Remove',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: sdp(context, 10)),
            ),
          ),
        ],
      ),
    );
  }
}
