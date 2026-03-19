import 'package:flutter/material.dart';

enum FieldType { name, email, phone, password, confirmPassword }

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final FieldType fieldType;
  final TextEditingController? passwordController;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    required this.fieldType,
    this.passwordController,
    this.isPassword = false,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  bool isObscure = true;

  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    switch (widget.fieldType) {
      case FieldType.name:
        if (value.length < 3) {
          return 'Name is too short';
        }
        break;

      case FieldType.email:
        if (!value.contains("@") || !value.contains(".")) {
          return 'Please enter a valid email';
        }
        break;

      case FieldType.phone:
        if (value.length != 11) {
          return 'Phone number must be 11 digits';
        }
        break;

      case FieldType.password:
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        break;

      case FieldType.confirmPassword:
        if (value != widget.passwordController?.text) {
          return 'Passwords do not match';
        }
        break;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword ? isObscure : false,
      maxLength: widget.fieldType == FieldType.phone ? 11 : null,
      validator: validate,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        counterText: "",
        prefixIcon: Icon(widget.icon, color: Colors.white),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Color(0xFF2A2A2A),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0XFFF6BD00), width: 2),
        ),
      ),
    );
  }
}
