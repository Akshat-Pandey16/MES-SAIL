import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mes_app/apiurl.dart';
import 'package:mes_app/core/utils/image_constant.dart';
import 'package:mes_app/core/utils/size_utils.dart';
import 'package:mes_app/presentation/report_screen.dart';
import 'package:mes_app/routes/app_routes.dart';
import 'package:mes_app/theme/app_decoration.dart';
import 'package:mes_app/theme/app_style.dart';
import 'package:mes_app/widgets/custom_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        visualDensity: VisualDensity.standard,
        useMaterial3: true, // Enable Material 3
      ),
      title: 'mes_app',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginScreen,
      routes: AppRoutes.routes,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cacheAssets();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundlogin.png', // Ensure this path is correct
              fit: BoxFit.cover,
            ),
          ),
          buildContent(),
        ],
      ),
    );
  }

  Widget buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: getHorizontalSize(42),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: getVerticalSize(326)),
            child: Text(
              "MES APP",
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppStyle.txtPoppinsExtraBold35,
            ),
          ),
          Text(
            "LOGIN",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsBold48,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: getVerticalSize(16)),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  buildInputField(
                    ImageConstant.imgPngtreevector,
                    "Username",
                    EdgeInsets.only(
                      top: getVerticalSize(5),
                      right: getHorizontalSize(2),
                    ),
                  ),
                  buildInputField(
                    ImageConstant.imgKeyicon266001,
                    "Password",
                    EdgeInsets.only(
                      top: getVerticalSize(10),
                      right: getHorizontalSize(2),
                    ),
                    isPasswordField: true,
                  ),
                  CustomButton(
                    height: getVerticalSize(72),
                    text: "LOGIN",
                    margin: EdgeInsets.only(top: getVerticalSize(24)),
                    onTap: () {
                      onTapLogin(context);
                    },
                  ),
                  buildForgotPasswordText(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(
    String imagePath,
    String hintText,
    EdgeInsets margin, {
    bool isPasswordField = false,
  }) {
    return Container(
      margin: margin,
      padding: EdgeInsets.fromLTRB(
        isPasswordField ? getHorizontalSize(8) : getHorizontalSize(16),
        getVerticalSize(15),
        getHorizontalSize(16),
        getVerticalSize(15),
      ),
      decoration: AppDecoration.fillBlue50.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder25,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: imagePath,
            height: getVerticalSize(30),
            width: isPasswordField
                ? getHorizontalSize(43)
                : getHorizontalSize(
                    23), // Adjust the width for the password field
          ),
          Expanded(
            child: Padding(
              padding: isPasswordField
                  ? EdgeInsets.only(
                      left: getHorizontalSize(0), bottom: getVerticalSize(2))
                  : EdgeInsets.only(
                      left: getHorizontalSize(10), bottom: getVerticalSize(2)),
              child: TextField(
                controller:
                    isPasswordField ? _passwordController : _usernameController,
                obscureText: isPasswordField && !_isPasswordVisible,
                decoration: InputDecoration.collapsed(
                  hintText: hintText,
                  hintStyle: AppStyle.txtPoppinsSemiBold16
                      .copyWith(color: Colors.grey),
                ),
              ),
            ),
          ),
          if (isPasswordField)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  Widget buildForgotPasswordText() {
    return Padding(
      padding:
          EdgeInsets.only(top: getVerticalSize(28), bottom: getVerticalSize(5)),
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            // Handle forgot password
          },
          child: Text(
            "Forgot Password?",
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppStyle.txtPoppinsBold18.copyWith(
              decoration: TextDecoration.underline,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void cacheAssets() async {
    await precacheImage(const AssetImage('assets/images/background.png'),
        context); // Replace with your actual image path
    await precacheImage(AssetImage(ImageConstant.imgSaillogo1), context);
    await precacheImage(AssetImage(ImageConstant.imgPngtreevector), context);
    await precacheImage(AssetImage(ImageConstant.imgKeyicon266001), context);
  }

  void onTapLogin(BuildContext context) async {
    // Navigator.pushNamed(context, AppRoutes.landingPageScreen);
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    if (username.isNotEmpty && password.isNotEmpty) {
      // Replace the API endpoint with your own
      final url = Uri.parse('$apiUrl/login');

      try {
        final response = await http.post(url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
            }));

        if (response.statusCode == 200) {
          // Login successful, navigate to the landing page
          Navigator.pushNamed(context, AppRoutes.landingPageScreen);
        } else {
          // Login failed, show an error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: const Text('Login failed. Please try again.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Error: $e');
        // Handle the error appropriately
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a username and password.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}