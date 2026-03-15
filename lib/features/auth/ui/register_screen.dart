import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/auth/logic/auth_cubit.dart';
import 'package:movie_app/features/auth/logic/auth_sates.dart';
import 'package:movie_app/core/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  String selectedLang = 'en';
  List<String> profile = [
    'assets/profile/person3.png',
    'assets/profile/person1.png',
    'assets/profile/person2.png',
  ];
  int currentIndex = 1;
  final formKey = GlobalKey<FormState>();

@override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, 'login');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        }, 
    child:Scaffold(
      backgroundColor: Color(0XFF121312),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0XFFF6BD00)),
        backgroundColor: Color(0XFF121312),
        centerTitle: true,
        title: Text(
          'Register'.tr(),
          style: TextStyle(
            color: Color(0XFFF6BD00),
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 180,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: profile.length,
                    controller: PageController(
                      viewportFraction: 0.4,
                      initialPage: 1,
                    ),
                    itemBuilder: (context, index) {
                      double scale = index == currentIndex ? 1.0 : 0.7;
                      return TweenAnimationBuilder(
                        tween: Tween<double>(begin: scale, end: scale),
                        duration: Duration(milliseconds: 300),
                        builder: (context, double value, child) {
                          return Transform.scale(
                            scale: value,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentIndex = index;
                                });
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.asset(
                                  profile[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Avatar'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 20),
                CustomTextfield(
                  hintText: 'Name'.tr(),
                  icon: Icons.person,
                  controller: name,
                  keyboardType: TextInputType.name,
                  fieldType: FieldType.name,
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  hintText: 'Email'.tr(),
                  icon: Icons.email,
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  fieldType: FieldType.email,
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  hintText: 'Password'.tr(),
                  icon: Icons.lock,
                  controller: password,
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  fieldType: FieldType.password,
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  hintText: 'Confirm_Password'.tr(),
                  icon: Icons.lock,
                  controller: confirmPassword,
                  keyboardType: TextInputType.text,
                  isPassword: true,
                  fieldType: FieldType.confirmPassword,
                  passwordController: password,
                ),
                SizedBox(height: 10),
                CustomTextfield(
                  hintText: 'Phone_Number'.tr(),
                  icon: Icons.phone,
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  fieldType: FieldType.phone,
                ),
                SizedBox(height: 20),
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
                            // If state is AuthLoading, disable the button (onPressed: null)
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (formKey.currentState!.validate()) {
                                      // This now calls the method we added to your AuthCubit!
                                      context.read<AuthCubit>().register(
                                        email.text,
                                        password.text,
                                        name.text,
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
                                      'Create_Account'.tr(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already_Have_Account'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Login'.tr(),
                        style: TextStyle(
                          color: Color(0XFFF6BD00),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Color(0XFFF6BD00), width: 3),
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
                            border: selectedLang == 'en'
                                ? Border.all(color: Color(0XFFF6BD00), width: 4)
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
                            border: selectedLang == 'ar'
                                ? Border.all(color: Color(0XFFF6BD00), width: 4)
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
  }
}
