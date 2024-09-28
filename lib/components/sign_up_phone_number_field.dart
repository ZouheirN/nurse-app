// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
// class SignUpPhoneNumberField extends StatefulWidget {
//   final String initialCountryCode;
//   final TextEditingController? controller;
//
//   const SignUpPhoneNumberField({
//     super.key,
//     this.initialCountryCode = 'LB',
//     this.controller,
//   });
//
//   @override
//   _SignUpPhoneNumberFieldState createState() => _SignUpPhoneNumberFieldState();
// }
//
// class _SignUpPhoneNumberFieldState extends State<SignUpPhoneNumberField> {
//   late bool _isFocused;
//
//   @override
//   void initState() {
//     super.initState();
//     _isFocused = false;
//   }
//
//   void _onFocusChange(bool hasFocus) {
//     setState(() {
//       _isFocused = hasFocus;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 27),
//       child: Focus(
//         onFocusChange: _onFocusChange,
//         child: InternationalPhoneNumberInput(
//           textFieldController: widget.controller,
//           validator: (value) {
//             if (value!.isEmpty) {
//               return 'Please enter your phone number';
//             }
//             return null;
//           },
//           initialValue: PhoneNumber(isoCode: widget.initialCountryCode),
//           onInputChanged: (value) {
//             print(value.phoneNumber);
//           },
//           inputDecoration: InputDecoration(
//             enabledBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide(color: Color(0xFF7BB442)),
//             ),
//             focusedBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide(color: Color(0xFF7BB442)),
//             ),
//             errorBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide(color: Colors.red),
//             ),
//             focusedErrorBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//               borderSide: BorderSide(color: Colors.red),
//             ),
//             fillColor: const Color(0xFFE8FFD1),
//             filled: true,
//             hintText: 'Phone Number',
//             hintStyle:
//                 TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w300),
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
//           ),
//           inputBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(
//               color: _isFocused ? const Color(0xFF7BB442) : Colors.white,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
