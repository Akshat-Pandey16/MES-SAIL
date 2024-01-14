import 'package:flutter/material.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/theme/app_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

class CallsmsItemWidget extends StatelessWidget {
  final String name;
  final String position;
  final String phoneNumber;

  const CallsmsItemWidget({super.key, 
    Key? otherkey,
    required this.name,
    required this.position,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: getPadding(all: 8),
      decoration: AppDecoration.outlineBlack9003f3.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder22,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically
        children: [
          SizedBox(
            width: getHorizontalSize(181),
            child: Padding(
              padding: const EdgeInsets.only(top: 13, left: 10),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "$name\n",
                      style: TextStyle(
                        color: ColorConstant.blue50001,
                        fontSize: getFontSize(22),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: "$position\n",
                      style: TextStyle(
                        color: ColorConstant.black900,
                        fontSize: getFontSize(21),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () async {
                  Uri phoneUri = Uri.parse('tel:$phoneNumber');
                  if (await launchUrl(phoneUri)) {
                    // Dialer opened
                  } else {
                    // Dialer is not opened
                  }
                },
                child: CustomImageView(
                  imagePath: ImageConstant.imgCallicon1,
                  height: getVerticalSize(52),
                  width: getHorizontalSize(40),
                  radius: BorderRadius.circular(getHorizontalSize(11)),
                  margin: getMargin(top: 27, bottom: 14),
                ),
              ),
              SizedBox(width: getHorizontalSize(12)), // Add spacing between icons
              GestureDetector(
                onTap: () async {
                  Uri smsUri = Uri.parse('sms:$phoneNumber');
                  if (await launchUrl(smsUri)) {
                    // SMS app opened
                  } else {
                    // SMS app is not opened
                  }
                },
                child: CustomImageView(
                  imagePath: ImageConstant.imgSms1,
                  height: getSize(52),
                  width: getSize(52),
                  margin: getMargin(top: 27, bottom: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
