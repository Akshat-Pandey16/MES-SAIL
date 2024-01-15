// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mes_app/apiurl.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/theme/app_decoration.dart';
import 'package:mes_app/presentation/millscreenwidget.dart';

class MillScreen extends StatefulWidget {
  const MillScreen({super.key});

  @override
  State<MillScreen> createState() => _MillScreenState();
}

class _MillScreenState extends State<MillScreen> {
  List<dynamic> _tableData = [];

  @override
  void initState() {
    super.initState();
    fetchTableData();
  }

  Future<void> fetchTableData() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/mill_data'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          _tableData = jsonData.values.toList(); // Convert Map values to a List
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: getPadding(
                left: 13,
                top: 61,
                right: 13,
                bottom: 41,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: getMargin(
                      bottom: 5,
                    ),
                    padding: getPadding(
                      left: 17,
                      top: 4,
                      right: 17,
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
                            90,
                          ),
                          margin: getMargin(
                            left: 6,
                            top: 2,
                          ),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "MILLS\n",
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
                                  text: "DATA",
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
                        CustomImageView(
                          imagePath: ImageConstant.img98591,
                          height: getVerticalSize(
                            79,
                          ),
                          width: getHorizontalSize(
                            83,
                          ),
                          radius: BorderRadius.circular(
                            getHorizontalSize(
                              22,
                            ),
                          ),
                          margin: getMargin(
                            top: 8,
                            bottom: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: getHorizontalSize(330),
                      decoration: AppDecoration.outlineBlack9003f3.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder13,
                        color: const Color.fromRGBO(180, 219, 255, 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20), // Add padding
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Align texts to start and end
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Align texts vertically in the middle
                        children: [
                          Text(
                            'MILL NAME',
                            style: TextStyle(
                              color: const Color.fromRGBO(23, 144, 255, 1),
                              fontSize: getFontSize(23),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'PRODUCTION',
                            style: TextStyle(
                              color: ColorConstant.black900,
                              fontSize: getFontSize(23),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: getHorizontalSize(12),
                          ),
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) {
                              return SizedBox(height: getVerticalSize(12));
                            },
                            itemCount: _tableData.length,
                            itemBuilder: (context, index) {
                              final millName = _tableData[index][0].toString();
                              final PRODUCTION =
                                  _tableData[index][1].toString();
                              String mill = '';
                              String production = '';
                              mill = millName;
                              production = PRODUCTION;

                              return MillScreenWidget(
                                mill: mill,
                                production: production,
                              );
                            },
                          ),
                        ),
                        //   ListView.builder(
                        //   shrinkWrap: true,
                        //   itemCount: _tableData.length,
                        //   itemBuilder: (context, index) {
                        //     final MILL_NAME = _tableData[index][0];
                        //     final PRODUCTION = _tableData[index][1];

                        //     return Padding(
                        //       padding: const EdgeInsets.symmetric(vertical: 1),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Text(
                        //             MILL_NAME,
                        //             style: const TextStyle(
                        //               fontSize: 20,
                        //             ),
                        //           ),
                        //           Text(
                        //             'Production: $PRODUCTION',
                        //             style: const TextStyle(
                        //               fontSize: 20,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
