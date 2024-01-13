import 'package:flutter/material.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/theme/app_decoration.dart';

class MillScreenWidget extends StatelessWidget {
  final String mill;
  final String production;

  const MillScreenWidget({
    Key? key,
    required this.mill,
    required this.production,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 280, // Adjust the width according to your needs
        height: 50, // Adjust the height according to your needs
        decoration: AppDecoration.outlineBlack9003f3.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder17,
        ),
        child: Padding(
          padding: getPadding(
            left: 30,
            top: 10,
            right: 50,
            bottom: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                mill,
                style: TextStyle(
                  color: ColorConstant.blue50001,
                  fontSize: getFontSize(22),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ), // Add space between the texts
              Text(
                production,
                style: TextStyle(
                  color: ColorConstant.black900,
                  fontSize: getFontSize(22),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ));
  }
}
