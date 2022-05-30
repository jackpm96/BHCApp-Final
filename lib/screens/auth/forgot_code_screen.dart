import 'package:black_history_calender/const/colors.dart';
import 'package:black_history_calender/screens/auth/provider/auth_provider.dart';
import 'package:black_history_calender/screens/auth/sign_in_screen.dart';
import 'package:black_history_calender/widget/snackbar_widget.dart';
import 'package:black_history_calender/widget/text_field_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ForgotCodeScreen extends StatefulWidget {
  final String email;
  const ForgotCodeScreen({Key key, @required this.email}) : super(key: key);

  @override
  _ForgotCodeScreenState createState() => _ForgotCodeScreenState(email);
}

class _ForgotCodeScreenState extends State<ForgotCodeScreen> {
  _ForgotCodeScreenState(this.email);
  String email;
  TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  FocusNode _codeFocus = new FocusNode();
  FocusNode _emailFocus = new FocusNode();
  FocusNode _passFocus = new FocusNode();

  String token;
  bool isEnabled = true;

  @override
  void initState() {
    _emailController = TextEditingController(text: email);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _emailFocus.unfocus();
          _codeFocus.unfocus();
          _passFocus.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: SingleChildScrollView(
            child: Container(
          decoration: BoxDecoration(gradient: backGradient),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Container(
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                      'assets/images/bhc_logo.png',
                    ))),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        topLeft: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Reset Your Password',
                        style: GoogleFonts.montserrat(
                            color: Color(0xff666666),
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFieldSideBorder(
                        tfieldController: _emailController,
                        focus: _emailFocus,
                        hint: "Email",
                        enabled: false,
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      TextFieldSideBorder(
                        tfieldController: _passwordController,
                        focus: _passFocus,
                        hint: "New Password",
                        enabled: true,
                        icon: Icons.person,
                        keyboardType: TextInputType.name,
                      ),
                      TextFieldSideBorder(
                        tfieldController: _codeController,
                        focus: _codeFocus,
                        hint: "Enter Code",
                        enabled: true,
                        icon: Icons.person,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () => resetPassword(),
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Color(0xff0891d9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Continue',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                  color: white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w300),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()));
                            },
                            child: Text(
                              'Sign In Now',
                              style: TextStyle(
                                  color: lightBlue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ))
            ],
          ),
        )),
      ),
    );
  }

  Future resetPassword() async {
    EasyLoading.show(dismissOnTap: false);
    var response = await Provider.of<AuthProvider>(context, listen: false)
        .resetPassword(_emailController.text.trim(),
            _passwordController.text.trim(), _codeController.text.trim());

    if (response != null) {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, response.message);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignInScreen()));
    } else {
      EasyLoading.dismiss();
      CommonWidgets.buildSnackbar(context, "Something went wrong");
    }
  }
}
