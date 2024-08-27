import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final Icon icon;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.icon,
    required this.hintText,
    required this.obscureText,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: TextField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Icon(
              widget.icon.icon,
              color: Colors.grey,
            ),
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: _toggleObscureText,
                )
              : null,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF7BB442)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xFF7BB442)),
          ),
          fillColor: const Color(0xFFE8FFD1),
          filled: true,
          hintText: widget.hintText,
          hintStyle:
              TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        ),
      ),
    );
  }
}
