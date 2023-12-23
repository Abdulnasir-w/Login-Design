import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool loading;
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 260,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.black,
            width: 1,
          )),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          // backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.transparent),
          overlayColor:
              MaterialStateProperty.resolveWith((states) => Colors.transparent),
        ),
        child: loading
            ? const CircularProgressIndicator(strokeWidth: 3,color: Colors.black,)
            : Text(
                title,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
      ),
    );
  }
}
