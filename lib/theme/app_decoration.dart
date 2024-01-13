import 'package:flutter/material.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';

class AppDecoration {
  static BoxDecoration get fillGray10001 => BoxDecoration(
        color: ColorConstant.gray10001,
      );
  static BoxDecoration get txtFillBlue100 => BoxDecoration(
        color: ColorConstant.blue100,
      );
  static BoxDecoration get fillBlue50 => BoxDecoration(
        color: ColorConstant.blue50,
      );
  static BoxDecoration get outlineBlack9003f => BoxDecoration(
        color: ColorConstant.whiteA700,
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
      );
  static BoxDecoration get txtFillBlue900 => BoxDecoration(
        color: ColorConstant.blue900,
      );
  static BoxDecoration get outlineBlack9003f3 => BoxDecoration(
        color: ColorConstant.blue5001,
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
      );
  static BoxDecoration get outlineBlack9003f2 => BoxDecoration(
        color: ColorConstant.blue200,
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
      );
  static BoxDecoration get fillGray100 => BoxDecoration(
        color: ColorConstant.gray100,
      );
  static BoxDecoration get fillWhiteA700 => BoxDecoration(
        color: ColorConstant.whiteA700,
      );
}

class BorderRadiusStyle {
  static BorderRadius roundedBorder25 = BorderRadius.circular(
    getHorizontalSize(
      25,
    ),
  );

  static BorderRadius roundedBorder13 = BorderRadius.circular(
    getHorizontalSize(
      13,
    ),
  );

  static BorderRadius roundedBorder32 = BorderRadius.circular(
    getHorizontalSize(
      32,
    ),
  );

  static BorderRadius roundedBorder22 = BorderRadius.circular(
    getHorizontalSize(
      22,
    ),
  );

  static BorderRadius circleBorder43 = BorderRadius.circular(
    getHorizontalSize(
      43,
    ),
  );

  static BorderRadius roundedBorder11 = BorderRadius.circular(
    getHorizontalSize(
      11,
    ),
  );

  static BorderRadius roundedBorder40 = BorderRadius.circular(
    getHorizontalSize(
      40,
    ),
  );

  static BorderRadius roundedBorder17 = BorderRadius.circular(
    getHorizontalSize(
      17,
    ),
  );

  static BorderRadius txtRoundedBorder25 = BorderRadius.circular(
    getHorizontalSize(
      25,
    ),
  );

  static BorderRadius txtRoundedBorder18 = BorderRadius.circular(
    getHorizontalSize(
      18,
    ),
  );
} //end

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
