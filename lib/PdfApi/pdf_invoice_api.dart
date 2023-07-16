import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  // static var orderDetail;
  static Future<File> generate(var orderDetail) async {
    // final ByteData companyLogoBytes =
    //     await rootBundle.load('./lib/assets/images/arLogo.png');
    // final Uint8List companyLogo = companyLogoBytes.buffer.asUint8List();

    // final ByteData authSignBytes =
    //     await rootBundle.load('./lib/assets/images/authsign.png');
    // final Uint8List authSign = authSignBytes.buffer.asUint8List();

    // var url = orderDetail['productImg'];
    // var response = await get(Uri.parse(url));
    // var data = response.bodyBytes;

    // PdfInvoiceApi.orderDetail = orderDetail;

    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      build: (context) => [
        // buildHeader(companyLogo),
        buildInvoiceDetails(),
        buildInvoiceTable(),
        // buildOtherInfo(authSign),
      ],
      footer: (context) => buildFooter(),
    ));
    return saveDocument(name: 'Invoice_' + 'ABCD' + '.pdf', pdf: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();
    final dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;
    OpenFile.open(url);
  }

  static Widget buildHeader(companyLogo) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            children: [
              Image(
                MemoryImage(
                  companyLogo,
                ),
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 3 * PdfPageFormat.mm),
              Text(
                "Staffmed",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(
            "Kolkata",
            style: TextStyle(fontSize: 10),
          ),
          Row(
            children: [
              Text(
                "1800 876 6678",
                style: TextStyle(fontSize: 10),
              ),
              // SizedBox(width: 0.3 * PdfPageFormat.cm),
              Spacer(),
              Text(
                "GSTIN: GSXP2Y10098",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
        ],
      );

  static Widget buildInvoiceDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableHelper.fromTextArray(
            headers: [
              'Order Id: !Dskjhdajhd',
              'Invoice Date: 12 Jul, 2023',
            ],
            data: [],
            border: null,
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
            },
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildText(title: "Bill To", value: ""),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text("Avishek", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Aesby More"),
          Text("Mobile: 9093047658"),
          Divider()
        ],
      );

  static Widget buildInvoiceTable() => Column(children: [
        // Invoice Table
        TableHelper.fromTextArray(
          headers: [
            'Name',
            'Dose',
            'Quantity',
            'Sale price',
            'Discount',
            'Total',
          ],
          data: [
            [
              "Paracetamol\nDelta",
              '20mg',
              '1pc',
              'Rs. 200',
              'Applied',
              'Rs. 190',
            ]
          ],
          border: null,
          headerStyle: TextStyle(fontWeight: FontWeight.bold),
          headerDecoration: BoxDecoration(color: PdfColors.grey300),
          cellHeight: 30,
          cellAlignments: {
            0: Alignment.centerLeft,
            1: Alignment.center,
            2: Alignment.centerRight,
            3: Alignment.centerRight,
            4: Alignment.centerRight,
            5: Alignment.centerRight,
          },
        ),
        Divider(),
        buildTotal(),
        Divider(),
      ]);

  static Widget buildTotal() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 5),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: 'Rs. 190',
                  unite: true,
                ),
                Text(
                  '(Includes GST and Making Charge)',
                  style: TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#808080'),
                  ),
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                // Column(
                //   children: List.generate(
                //     orderDetail['orderPayments'].length,
                //     (index) => buildText(
                //       title: 'Paid ' +
                //           orderDetail['orderPayments'][index]['txnDate']
                //               .split(',')[0],
                //       titleStyle: TextStyle(fontWeight: FontWeight.normal),
                //       value: 'Rs. 100',
                //       unite: true,
                //     ),
                //   ),
                // ),
                Divider(),

                SizedBox(height: 3 * PdfPageFormat.mm),
                Text("Invoice Amount (in words)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                // Text(
                //   NumberToWord()
                //           .convert(
                //             'en-in',
                //             int.parse(orderDetail['amount']),
                //           )
                //           .toUpperCase() +
                //       "RUPEES",
                // ),
                SizedBox(height: 3 * PdfPageFormat.cm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOtherInfo(authSign) => Column(children: [
        // Terms and Conditions and Barcode and Signature
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Invoice QR Code"),
                  SizedBox(height: 0.3 * PdfPageFormat.cm),
                  // Container(
                  //   height: 50,
                  //   width: 50,
                  //   child: BarcodeWidget(
                  //     barcode: Barcode.qrCode(),
                  //     data: "https://aryagold.co.in/orderInvoice?orderId=" +
                  //         orderDetail['orderId'],
                  //   ),
                  // ),
                  SizedBox(height: 0.3 * PdfPageFormat.cm),
                  Text(
                    "TERMS & CONDITIONS:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "1. Goods once sold will not be taken back or exchanged",
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    "2. All disputes are subject to [Durgapur] jurisdiction only",
                    style: TextStyle(fontSize: 10),
                  )
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Image(
                    MemoryImage(
                      authSign,
                    ),
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 3 * PdfPageFormat.mm),
                  Text("AUTHORISED SIGNATORY FOR\nArya Gold & Jewellery"),
                ],
              ),
            )
          ],
        ),
      ]);

  static Widget buildFooter() => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'Visit our website', value: "https://aryagold.co.in"),
        ],
      );

  static buildSimpleText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      TextStyle? titleStyle,
      bool unite = false}) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
