import 'package:apollo/utils/colors.dart';
import 'package:apollo/utils/components.dart';
import 'package:apollo/utils/constants.dart';
import 'package:apollo/utils/sdp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyAddresUI extends StatefulWidget {
  const MyAddresUI({super.key});

  @override
  State<MyAddresUI> createState() => _MyAddresUIState();
}

class _MyAddresUIState extends State<MyAddresUI> {
  bool showAddress = false;

  bool isLoading = false;

  final pincode = TextEditingController();
  final address = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();

//  ------------------------------------------------->

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  Future<void> fetchAddress() async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
      uri: '/users/fetch-address.php',
      body: {
        'userId': UserData.id,
      },
    );

    if (!dataResult['error']) {
      UserData.addresses = dataResult['response'];
      setState(() {});
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addAddress() async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
      uri: '/users/add-address.php',
      body: {
        'userId': UserData.id,
        'pincode': pincode.text,
        'address': address.text,
        'recipient': name.text,
        'phone': phone.text,
        'isDefault': 'false',
      },
    );

    ShowSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);

    setState(() {
      isLoading = false;
      showAddress = false;
    });
  }

  Future<void> removeAddress(String addId) async {
    setState(() {
      isLoading = true;
    });
    var dataResult = await ApiCallback(
      uri: '/users/delete-address.php',
      body: {
        'userId': UserData.id,
        'addressId': addId,
      },
    );

    ShowSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    pincode.dispose();
    address.dispose();
    name.dispose();
    phone.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kBackButton(context),
        title: kAppbarTitle(context, title: 'My Addresses'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  alignment: Alignment.topCenter,
                  curve: Curves.ease,
                  reverseDuration: Duration(milliseconds: 300),
                  duration: Duration(milliseconds: 300),
                  child: showAddress
                      ? addressForm()
                      : KOutlinedButton.expanded(
                          onPressed: () {
                            setState(() {
                              showAddress = true;
                            });
                          },
                          label: 'Add new address'),
                ),
                height20,
                Text(
                  'Recently added addresses',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                height10,
                ListView.builder(
                  itemCount: UserData.addresses.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return addressCard(index, UserData.addresses[index]);
                  },
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

  Widget addressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add address details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        height20,
        Text('Pincode'),
        height10,
        kTextField(context,
            controller: pincode,
            hintText: 'eg., 713201',
            keyboardType: TextInputType.number),
        height20,
        Text('House number, floor, building name, locality'),
        height10,
        kTextField(context,
            controller: address,
            keyboardType: TextInputType.streetAddress,
            maxLength: 100,
            maxLines: 4),
        height20,
        Text('Recipient\'s name'),
        height10,
        kTextField(context, controller: name, keyboardType: TextInputType.name),
        height20,
        Text('Phone number'),
        height10,
        kTextField(context,
            controller: phone,
            prefixText: '+91',
            maxLength: 10,
            keyboardType: TextInputType.phone),
        height20,
        kSubmitButton(
          context,
          onTap: () {
            addAddress();
          },
          label: 'Add address',
        ),
        height10,
        Divider(),
      ],
    );
  }

  Widget addressCard(int index, Map data) {
    bool isSelected = defaultAddress == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          defaultAddress = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.amber.shade600 : Colors.transparent,
              width: 2),
          color: kCardColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Address ${index + 1}",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                InkWell(
                  onTap: () {
                    removeAddress(data['id']);
                    UserData.addresses.removeAt(index);
                  },
                  child: SvgPicture.asset(
                    'lib/assets/icons/remove.svg',
                    height: sdp(context, 16),
                    colorFilter: svgColor(Colors.red),
                  ),
                )
              ],
            ),
            height10,
            Text(
              data['recipient'],
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: sdp(context, 12),
              ),
            ),
            Text(
              data['address'] + " - " + data['pincode'],
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: sdp(context, 10),
              ),
            ),
            height5,
            Text(
              data['phone'],
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: sdp(context, 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
