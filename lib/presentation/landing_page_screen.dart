// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/routes/app_routes.dart';
import 'package:mes_app/theme/app_decoration.dart';
import 'package:mes_app/theme/app_style.dart';

class LandingPageItemWidget extends StatelessWidget {
  const LandingPageItemWidget({
    Key? key,
    required this.onTap,
    required this.imagePath,
    required this.cardText,
    required this.backgroundColor,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String imagePath;
  final String cardText;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(getHorizontalSize(25)),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.black9003f,
              spreadRadius: getHorizontalSize(
                2,
              ),
              blurRadius: getHorizontalSize(
                2,
              ),
              offset: const Offset(
                0,
                4,
              ),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(),
              child: CustomImageView(
                imagePath: imagePath,
                margin: const EdgeInsets.fromLTRB(1, 15, 1, 15),
                height: getVerticalSize(149),
                width: getHorizontalSize(130),
                radius: BorderRadius.circular(getHorizontalSize(22)),
                alignment: Alignment.center,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              cardText,
              maxLines: 2, // Set a maximum number of lines for the text
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppStyle.txtPoppinsBold27,
            ),
          ],
        ),
      ),
    );
  }
}

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({Key? key}) : super(key: key);

  get StaggeredGridView => null;

  get StaggeredTile => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: ColorConstant.gray10001,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundlanding.png', // Replace with your actual image path
              fit: BoxFit.cover,
            ),
          ),
          //body:
          Container(
            padding: EdgeInsets.fromLTRB(
                14, MediaQuery.of(context).padding.top + 25, 14, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 1),
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                  decoration: AppDecoration.outlineBlack9003f.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder32,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: getHorizontalSize(147),
                        margin: const EdgeInsets.only(left: 7),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "WELCOME\n",
                                style: TextStyle(
                                  color: ColorConstant.black900,
                                  fontSize: getFontSize(29),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: "USER",
                                style: TextStyle(
                                  color: ColorConstant.blue50002,
                                  fontSize: getFontSize(29),
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
                        imagePath: ImageConstant.imgEllipse1,
                        height: getVerticalSize(87),
                        width: getHorizontalSize(71),
                        radius: BorderRadius.circular(getHorizontalSize(33)),
                        margin: const EdgeInsets.only(top: 5, bottom: 4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 1),
                Expanded(
                  child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: getHorizontalSize(11),
                    mainAxisSpacing: getHorizontalSize(11),
                    staggeredTileBuilder: (index) {
                      return StaggeredTile.fit(1);
                    },
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      VoidCallback? onTap;
                      String imagePath = '';
                      String cardText = '';
                      Color tileColor = Colors.blue;
                      if (index == 0) {
                        onTap = () => onTapColumnqrcodeone(context);
                        imagePath = ImageConstant.imgQrcode1;
                        cardText = "QR\nScanner";
                      } else if (index == 1) {
                        onTap = () => onTapColumnmilldata(context);
                        imagePath = ImageConstant.img98591;
                        cardText = "Mills\nReport";
                        tileColor = const Color.fromRGBO(158, 208, 255, 1);
                      } else if (index == 2) {
                        onTap = () => onTapColumnreport(context);
                        imagePath = ImageConstant.img2448914383x81;
                        cardText = "Grievance Report";
                        tileColor = const Color.fromRGBO(158, 208, 255, 1);
                      } else if (index == 3) {
                        onTap = () => onTapColumncallsms(context);
                        imagePath = ImageConstant.imgCall1;
                        cardText = "Call/SMS Peers";
                      }

                      return LandingPageItemWidget(
                        onTap: onTap,
                        imagePath: imagePath,
                        cardText: cardText,
                        backgroundColor: tileColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  onTapColumnqrcodeone(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.qrCodeScreen);
  }

  onTapColumnmilldata(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.millsScreen);
  }

  onTapColumnreport(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.reportScreen);
  }

  onTapColumncallsms(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.callSmsScreen);
  }
}