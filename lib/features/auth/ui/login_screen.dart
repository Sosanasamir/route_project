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
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
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
      child: Builder(
        builder: (context) {
          return BlocListener<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0XFF121312),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          Image.asset(
                            'assets/images/logo.png',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 155,
                          ),
                          const SizedBox(height: 35),
                          CustomTextfield(
                            hintText: 'Email'.tr(),
                            icon: Icons.email,
                            controller: email,
                            keyboardType: TextInputType.emailAddress,
                            fieldType: FieldType.email,
                          ),
                          const SizedBox(height: 15),
                          CustomTextfield(
                            hintText: 'Password'.tr(),
                            icon: Icons.lock,
                            controller: password,
                            keyboardType: TextInputType.text,
                            isPassword: true,
                            fieldType: FieldType.password,
                          ),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  'forget_password_view',
                                );
                              },
                              child: Text(
                                'Forget_Password'.tr(),
                                style: const TextStyle(
                                  color: Color(0XFFF6BD00),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFF6BD00),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: state is AuthLoading
                                      ? null
                                      : () {
                                          if (formKey.currentState!
                                              .validate()) {
                                            context.read<AuthCubit>().login(
                                              email.text,
                                              password.text,
                                            );
                                          }
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: state is AuthLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.black,
                                          )
                                        : Text(
                                            'Login'.tr(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 15),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Dont_Have_Account'.tr(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Create_One'.tr(),
                                  style: const TextStyle(
                                    color: Color(0XFFF6BD00),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildOrDivider(),
                          const SizedBox(height: 15),
                          _buildGoogleLoginButton(context),
                          const SizedBox(height: 30),
                          _buildLanguageSwitcher(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          width: 100,
          child: Divider(color: Color(0XFFF6BD00), thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'OR'.tr(),
            style: const TextStyle(color: Color(0XFFF6BD00), fontSize: 14),
          ),
        ),
        const SizedBox(
          width: 100,
          child: Divider(color: Color(0XFFF6BD00), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildGoogleLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0XFFF6BD00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () {
          FirebaseFunctions.signInWithGoogle(
            onSuccess: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
            onError: (message) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.red, content: Text(message)),
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.google,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Login_With_Google'.tr(),
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0XFFF6BD00), width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _langIcon('assets/images/en.png', 'en', const Locale('en', 'US')),
          const SizedBox(width: 12),
          _langIcon('assets/images/ar.png', 'ar', const Locale('ar', 'EG')),
        ],
      ),
    );
  }

  Widget _langIcon(String path, String langCode, Locale locale) {
    bool isSelected = selectedLang == langCode;
    return GestureDetector(
      onTap: () {
        setState(() => selectedLang = langCode);
        context.setLocale(locale);
      },
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(color: const Color(0XFFF6BD00), width: 2)
              : null,
          shape: BoxShape.circle,
        ),
        child: Image.asset(path, height: 30, width: 30),
      ),
    );
  }
}
