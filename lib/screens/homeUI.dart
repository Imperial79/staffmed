import 'package:apollo/screens/Prescription%20Screens/uploadUI.dart';
import 'package:apollo/screens/Cart%20screens/cartUI.dart';
import 'package:apollo/screens/searchProductsUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: primaryColorAccent,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                              'lib/assets/icons/staffmed-banner-white.png')),
                      height10,
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello,',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
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
                                backgroundColor: kButtonColor,
                                isLabelVisible: cartProductIds.length != 0,
                                label: Text(cartProductIds.length.toString()),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => CartUI()))
                                        .then((value) {
                                      setState(() {});
                                    });
                                  },
                                  icon: SvgPicture.asset(
                                      'lib/assets/icons/cart.svg'),
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
                              bannersList.length,
                              (index) => CachedNetworkImage(
                                imageUrl: bannersList[index]['image'],
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
                        return productListTile(
                            context, popularMedicines[index]);
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
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
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

  Widget searchBar() {
    return GestureDetector(
      onTap: () {
        navPush(context, SearchProductsUI());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            Text(
              'Search medicines',
              style: TextStyle(
                  fontSize: sdp(context, 11),
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
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

                          print(cartProductIds.length);
                        } else {
                          navPush(context, CartUI()).then((value) {
                            setState(() {
                              print('here');
                            });
                          });
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
