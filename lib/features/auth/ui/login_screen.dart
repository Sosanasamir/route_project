import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/utils/firebase_functions.dart';
import 'package:movie_app/features/movies/ui/home_screen.dart';
import 'package:movie_app/core/widgets/custom_textfield.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_app/features/auth/logic/auth_cubit.dart';
import 'package:movie_app/features/auth/logic/auth_sates.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String selectedLang = 'en';
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => AuthCubit(),
    // Use Builder to create a context that contains AuthCubit
    child: Builder(
      builder: (context) {
        return BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
        child: Scaffold(
          backgroundColor: Color(0XFF121312),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                        height: 150,
                        width: 155,
                      ),
                      SizedBox(height: 35),
                      CustomTextfield(
                        hintText: 'Email'.tr(),
                        icon: Icons.email,
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        fieldType: FieldType.email,
                      ),
                      SizedBox(height: 15),
                      CustomTextfield(
                        hintText: 'Password'.tr(),
                        icon: Icons.lock,
                        controller: password,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        fieldType: FieldType.password,
                      ),
                      SizedBox(height: 15),
                      Align(
                        alignment: AlignmentGeometry.topRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'forgetpassword');
                          },
                          child: Text(
                            'Forget_Password'.tr(),
                            style: TextStyle(
                              color: Color(0XFFF6BD00),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0XFFF6BD00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                             // Inside LoginScreen's ElevatedButton
                              onPressed: state is AuthLoading
                                  ? null
                                  : () {
                                      if (formKey.currentState!.validate()) {
                                        context.read<AuthCubit>().login(
                                          email.text,
                                          password.text,
                                        );
                                      }
                                    },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: state is AuthLoading
                                    ? CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Text(
                                        'Login'.tr(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Dont_Have_Account'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Create_One'.tr(),
                              style: TextStyle(
                                color: Color(0XFFF6BD00),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Divider(
                              color: Color(0XFFF6BD00),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              'OR'.tr(),
                              style: TextStyle(
                                color: Color(0XFFF6BD00),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Divider(
                              color: Color(0XFFF6BD00),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFF6BD00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            FirebaseFunctions.signInWithGoogle(
                              onSuccess: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(),
                                  ),
                                );
                              },
                              onError: (message) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      message,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.black,
                                  size: 20,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Login_With_Google'.tr(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Color(0XFFF6BD00),
                            width: 3,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLang = 'en';
                                });
                                context.setLocale(Locale('en', 'US'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: selectedLang == "en"
                                      ? Border.all(
                                          color: Color(0XFFF6BD00),
                                          width: 4,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.asset(
                                  'assets/images/en.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedLang = 'ar';
                                });
                                context.setLocale(Locale('ar', 'EG'));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: selectedLang == "ar"
                                      ? Border.all(
                                          color: Color(0XFFF6BD00),
                                          width: 4,
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.asset(
                                  'assets/images/ar.png',
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        );
      },
    )
    );
  }
}
