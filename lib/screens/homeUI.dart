import 'package:apollo/screens/Prescription%20Screens/uploadUI.dart';
import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
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
                                  'Avishek Verma',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: sdp(context, 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          width10,
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset('lib/assets/icons/cart.svg'),
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
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return productListTile();
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

  Widget productListTile() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Container(
            height: sdp(context, 55),
            width: sdp(context, 80),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  image: NetworkImage(
                      'https://5.imimg.com/data5/SELLER/Default/2022/8/QM/AX/SS/129887935/paracetamol-tablets-1000x1000.jpeg'),
                  fit: BoxFit.cover),
            ),
          ),
          width10,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paracetamol',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '50mg',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          width5,
          GestureDetector(
            onTap: () {},
            child: Container(
              child: Icon(Icons.add),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              child: SvgPicture.asset(
                'lib/assets/icons/remove.svg',
                height: sdp(context, 15),
              ),
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
