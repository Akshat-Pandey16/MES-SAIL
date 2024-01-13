// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mes_app/apiurl.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/theme/app_decoration.dart';

import '../../widgets/custom_button.dart';

void main() => runApp(const QrCodeScreen());

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({Key? key}) : super(key: key);

  @override
  QrCodeScreenState createState() => QrCodeScreenState();
}

class QrCodeScreenState extends State<QrCodeScreen> {
  String _scanBarcode = '';
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      debugPrint(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Future<void> sendQRDataToServer() async {
    if (_scanBarcode.isNotEmpty) {
      final url = Uri.parse(
          '$apiUrl/qrdata'); // Replace with your Node.js server endpoint
      final headers = {'Content-Type': 'application/json'};
      final body = json.encode({'data': _scanBarcode});

      try {
        final response = await http.post(url, headers: headers, body: body);
        if (response.statusCode == 200) {
          // Successful request
          Fluttertoast.showToast(
            msg: 'QR Data sent successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
          );
          print('QR data sent successfully');
        } else {
          Fluttertoast.showToast(
            msg: 'QR Data failed to upload to Database',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
          );
          print('Error sending QR data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error sending QR data',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        print('Error sending QR data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.gray10001,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background1.png', // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.maxFinite,
              padding: getPadding(
                left: 13,
                top: 54,
                right: 13,
                bottom: 44,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: getPadding(
                      left: 18,
                      top: 4,
                      right: 18,
                      bottom: 4,
                    ),
                    decoration: AppDecoration.outlineBlack9003f.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: getHorizontalSize(
                            154,
                          ),
                          margin: getMargin(
                            left: 5,
                            top: 2,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "QR CODE\n",
                                  style: TextStyle(
                                    color: ColorConstant.black900,
                                    fontSize: getFontSize(
                                      32,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: "SCANNER",
                                  style: TextStyle(
                                    color: ColorConstant.blue50001,
                                    fontSize: getFontSize(
                                      32,
                                    ),
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: CustomImageView(
                            imagePath: ImageConstant.imgQrcode2,
                            height: getVerticalSize(
                              95,
                            ),
                            width: getHorizontalSize(
                              81,
                            ),
                            radius: BorderRadius.circular(
                              getHorizontalSize(
                                22,
                              ),
                            ),
                            margin: getMargin(
                              top: 5,
                              bottom: 6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      scanQR();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(getHorizontalSize(40)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: -20,
                            blurRadius: 7,
                            offset: const Offset(32, 35), // Modify this line
                          ),
                        ],
                      ),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgQrscan1,
                        height: getVerticalSize(327),
                        width: getHorizontalSize(267),
                        radius: BorderRadius.circular(getHorizontalSize(40)),
                        margin: getMargin(top: 72),
                      ),
                    ),
                  ),
                  Container(
                    width: getHorizontalSize(
                      287,
                    ),
                    margin: getMargin(
                      left: 23,
                      top: 49,
                      right: 24,
                      bottom: 5,
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Click ",
                            style: TextStyle(
                              color: ColorConstant.indigo500,
                              fontSize: getFontSize(
                                32,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "above image to scan ",
                            style: TextStyle(
                              color: ColorConstant.gray800,
                              fontSize: getFontSize(
                                32,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: "QR",
                            style: TextStyle(
                              color: ColorConstant.indigo500,
                              fontSize: getFontSize(
                                32,
                              ),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (_scanBarcode != "-1" &&
                              _scanBarcode
                                  .isNotEmpty) // Only show when _scanBarcode is not empty
                            TextSpan(
                              text: "\n\n\nQR OUTPUT: \n$_scanBarcode",
                              style: TextStyle(
                                color: ColorConstant.indigo500,
                                fontSize: getFontSize(22),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (_scanBarcode != "-1" && _scanBarcode.isNotEmpty)
                    CustomButton(
                      height: getVerticalSize(72),
                      text: "Upload QR Data",
                      margin: EdgeInsets.only(top: getVerticalSize(24)),
                      onTap: () {
                        sendQRDataToServer();
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
