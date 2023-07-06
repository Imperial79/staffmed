import 'package:apollo/screens/Prescription%20Screens/uploadUI.dart';
import 'package:apollo/screens/cartUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  List<dynamic> popularMedicines = [];

  @override
  void initState() {
    super.initState();
    fetchPopularMedicines();
  }

  fetchPopularMedicines() async {
    var dataResult = await ApiCallback(uri: '/products/fetch-populars.php');

    popularMedicines = dataResult['response'];

    setState(() {});
  }

  addToCart(String prodId) async {
    var dataResult = await ApiCallback(
        uri: '/products/add-to-cart.php',
        body: {'userId': UserData.id, 'productId': prodId});

    // print(dataResult);
    ShowSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColorAccent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height20,
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello,',
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  UserData.fullname,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: sdp(context, 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          width10,
                          Badge(
                            isLabelVisible: cartList.length != 0,
                            label: Text(cartList.length.toString()),
                            child: IconButton(
                              onPressed: () {
                                navPush(context, CartUI());
                              },
                              icon:
                                  SvgPicture.asset('lib/assets/icons/cart.svg'),
                            ),
                          ),
                        ],
                      ),
                      height20,
                      searchBar(),
                      height20,
                      CarouselSlider(
                        options: CarouselOptions(
                          height: sdp(context, 100),
                          autoPlay: true,
                          enlargeCenterPage: false,
                          autoPlayInterval: Duration(seconds: 4),
                          viewportFraction: 1,
                        ),
                        items: List.generate(
                          5,
                          (index) => Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'https://assets.telegraphindia.com/telegraph/2022/Aug/1661017334_medicine.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              height20,
              presBanner(),
              height20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    Text(
                      'Popular medicines',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: sdp(context, 12),
                      ),
                    ),
                    ListView.builder(
                      itemCount: popularMedicines.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return productListTile(popularMedicines[index]);
                      },
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

  Widget presBanner() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order with prescription',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Save upto 25%',
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          width10,
          ElevatedButton(
            onPressed: () {
              navPush(context, UploadPresUI());
            },
            child: Text('Order now'),
          ),
        ],
      ),
    );
  }

  Widget productListTile(Map data) {
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
                        if (!cartList.contains(data)) {
                          addToCart(data['id']);

                          setState(() {
                            cartList.add(data);
                          });

                          ShowSnackBar(context,
                              content: 'Product added to cart successfully!');
                        } else {
                          navPush(context, CartUI());
                        }
                      }
                    },
                    child: CircleAvatar(
                      backgroundColor: cartList.contains(data)
                          ? primaryColorAccent
                          : Colors.green,
                      child: cartList.contains(data)
                          ? SvgPicture.asset(
                              'lib/assets/icons/cart.svg',
                              colorFilter: svgColor(cartList.contains(data)
                                  ? primaryColor
                                  : Colors.green),
                            )
                          : Icon(
                              Icons.add,
                              color: cartList.contains(data)
                                  ? Colors.green
                                  : Colors.white,
                            ),
                    ),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 10),
                    //   height: sdp(context, 70),
                    //   width: sdp(context, 37),
                    //   alignment: Alignment.center,
                    //   decoration: BoxDecoration(
                    //       color: data['availability'] == 'Out-of-Stock'
                    //           ? Colors.red
                    //           : cartList.contains(data)
                    //               ? Colors.transparent
                    //               : Colors.green,
                    //       borderRadius:
                    //           BorderRadius.horizontal(right: Radius.circular(7))),
                    //   child: data['availability'] == 'Out-of-Stock'
                    //       ? FittedBox(
                    //           child: Text(
                    //             'Out\nof\nstock',
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //               color: Colors.white,
                    //               fontWeight: FontWeight.w600,
                    //               fontSize: sdp(context, 7),
                    //             ),
                    //           ),
                    //         )
                    //       : cartList.contains(data)
                    //           ? SvgPicture.asset(
                    //               'lib/assets/icons/cart.svg',
                    //               colorFilter: svgColor(Colors.green),
                    //             )
                    //           : Icon(
                    //               Icons.add,
                    //               color: cartList.contains(data)
                    //                   ? Colors.green
                    //                   : Colors.white,
                    //             ),
                    // ),
                  ),
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'lib/assets/icons/search.svg',
            height: sdp(context, 15),
            colorFilter: svgColor(Colors.grey),
          ),
          width10,
          Flexible(
            child: TextField(
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
}
