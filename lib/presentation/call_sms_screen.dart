// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';
import 'package:mes_app/apiurl.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/callsms_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/theme/app_decoration.dart';

class CallSmsScreen extends StatefulWidget {
  const CallSmsScreen({super.key});

  @override
  _CallSmsScreenState createState() => _CallSmsScreenState();
}

class _CallSmsScreenState extends State<CallSmsScreen> {
  double appBarHeight = 260; // Initial height of the app bar
  List<dynamic> _tableData = [];
  @override
  void initState() {
    super.initState();
    fetchTableData();
  }

  Future<void> fetchTableData() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/call_data'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _tableData = jsonData;
        });
      } else {
        print('Failed to fetch table data. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred while fetching table data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background1.png', // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(height: getVerticalSize(140)),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: getHorizontalSize(22),
                        vertical: getVerticalSize(16),
                      ),
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: getVerticalSize(12));
                        },
                        itemCount: _tableData.length,
                        itemBuilder: (context, index) {
                          String name = '';
                          String position = '';
                          String phoneNumber = '';
                          final nameintable = _tableData[index][0].toString();
                          final positionintable =
                              _tableData[index][1].toString();
                          final phonenumberintable =
                              _tableData[index][2].toString();
                          name = nameintable;
                          position = positionintable;
                          phoneNumber = phonenumberintable;
                          return CallsmsItemWidget(
                            name: name,
                            position: position,
                            phoneNumber: phoneNumber,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 43,
                left: 13,
                right: 13,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(getVerticalSize(140)),
                  child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification) {
                          setState(() {
                            appBarHeight =
                                160 - scrollNotification.metrics.pixels;
                            if (appBarHeight < 80) {
                              appBarHeight = 80;
                            }
                          });
                        }
                        return true;
                      },
                      child: Container(
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
                                top: 5,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "CALL/SMS\n",
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
                                      text: "PEERS",
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
                                imagePath: ImageConstant.imgCall178x78,
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
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
