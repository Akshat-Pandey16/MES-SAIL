// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mes_app/apiurl.dart';
import 'package:mes_app/core/utils/color_constant.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/theme/app_decoration.dart';
import 'package:mes_app/theme/app_style.dart';
import 'package:mes_app/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController groupsixteenController = TextEditingController();
  File? pickedImage;

  Future<void> _openCamera() async {
    final imagePicker = ImagePicker();
    final pickedImageFile =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (pickedImageFile != null) {
      setState(() {
        pickedImage = File(pickedImageFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (pickedImage == null) {
      Fluttertoast.showToast(
        msg: 'Please upload image!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
      return;
    }

    const url = '$apiUrl/upload';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files
        .add(await http.MultipartFile.fromPath('image', pickedImage!.path));
    request.fields['description'] = groupsixteenController.text;
    request.fields['location'] = locationController.text;
    request.fields['time'] = timeController.text;

    try {
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Report uploaded successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to upload report!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
        );
      }
    } catch (error) {
      print('Error uploading image: $error');
      Fluttertoast.showToast(
        msg: 'An error occurred while uploading report!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return GestureDetector(
      onTap: () {
        // Unfocus any active text fields when tapping outside
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        // backgroundColor: ColorConstant.gray10001,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background1.png', // Replace with your actual image path
                fit: BoxFit.cover,
              ),
            ),
            //body:
            SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 46,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 1),
                      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: getHorizontalSize(162),
                            margin: const EdgeInsets.only(
                                left: 9, top: 5, bottom: 2),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "GRIEVANCE\n",
                                    style: TextStyle(
                                      color: ColorConstant.black900,
                                      fontSize: getFontSize(28),
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "REPORT",
                                    style: TextStyle(
                                      color: ColorConstant.blue50001,
                                      fontSize: getFontSize(28),
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
                            width: getHorizontalSize(81),
                            height: getVerticalSize(83),
                            margin: const EdgeInsets.only(top: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: CustomImageView(
                              imagePath: ImageConstant.img2448914383x81,
                              radius:
                                  BorderRadius.circular(getHorizontalSize(22)),
                              height: 0.0,
                              width: 0.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.fromLTRB(19, 0, 17, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: ColorConstant.blue50,
                        ),
                        child: CustomTextFormField(
                          focusNode: FocusNode(),
                          autofocus: true,
                          controller: locationController,
                          initialValue: "",
                          hintText: "Location",
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin: const EdgeInsets.fromLTRB(19, 7, 17, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: ColorConstant.blue50,
                        ),
                        child: CustomTextFormField(
                          focusNode: FocusNode(),
                          autofocus: true,
                          controller: timeController,
                          initialValue: "",
                          hintText: "Time of event",
                          margin: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      margin: const EdgeInsets.fromLTRB(19, 7, 17, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: CustomTextFormField(
                        focusNode: FocusNode(),
                        autofocus: true,
                        controller: groupsixteenController,
                        initialValue: "",
                        hintText: "Describe briefly",
                        margin: EdgeInsets.zero,
                        padding: TextFormFieldPadding.PaddingT27,
                        textInputAction: TextInputAction.done,
                        maxLines: 4,
                      ),
                    ),
                    Container(
                      width: getHorizontalSize(261),
                      margin: const EdgeInsets.fromLTRB(35, 12, 35, 0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "\nClick ",
                              style: TextStyle(
                                color: ColorConstant.indigo500,
                                fontSize: getFontSize(24),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: "below image to capture image of event",
                              style: TextStyle(
                                color: ColorConstant.gray80001,
                                fontSize: getFontSize(24),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: getVerticalSize(220),
                      width: getHorizontalSize(210),
                      margin: const EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: _openCamera,
                        child: CustomImageView(
                          imagePath: pickedImage != null
                              ? pickedImage!.path
                              : ImageConstant.imgUploadimage1,
                          radius: BorderRadius.circular(20),
                          height: 0.0,
                          width: 0.0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        _uploadImage();
                      },
                      child: Container(
                        width: getHorizontalSize(296),
                        margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: AppDecoration.txtFillBlue900.copyWith(
                          borderRadius: BorderRadiusStyle.txtRoundedBorder25,
                        ),
                        child: Center(
                          child: Text(
                            "SUBMIT",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: AppStyle.txtPoppinsBold31,
                          ),
                        ),
                      ),
                    ),

                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomImageView extends StatelessWidget {
  final String? imagePath;
  final BorderRadius? radius;
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final Alignment? alignment;

  const CustomImageView({
    super.key,
    required this.imagePath,
    required this.height,
    required this.width,
    this.radius,
    this.margin,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.startsWith('assets')) {
      // Image is an asset
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      );
    } else {
      // Image is a file
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: width,
          height: height,
        ),
      );
    }
  }
}
