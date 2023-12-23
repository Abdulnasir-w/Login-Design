import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final bool isPassField;
  final Color color;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.color,
    this.textStyle,
    this.isPassField = false,
    this.keyboardType,
    this.prefixIcon,
    this.validator,
    this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassField ? isVisible : false,
      style: widget.textStyle,
      keyboardType: widget.keyboardType,
      decoration: InputDecoration(
        hintText: widget.labelText,
        hintStyle: widget.textStyle,
        filled: true,
        fillColor: widget.color,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        prefixIcon: widget.prefixIcon != null
            ? Icon(
                widget.prefixIcon,
                color: Colors.black,
              )
            : null,
        suffixIcon: widget.isPassField
            ? IconButton(

                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                style: ButtonStyle(
                  //backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                  foregroundColor: MaterialStateProperty.resolveWith((states) => Colors.red),
                 // overlayColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
                ),
                icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black,
                ))
            : null,
      ),
      validator: widget.validator,
    );
  }
}
