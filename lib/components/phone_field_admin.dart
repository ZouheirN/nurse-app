import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneFieldAdmin extends StatefulWidget {
  final String initialCountryCode;
  final TextEditingController? controller;

  const PhoneFieldAdmin({
    super.key,
    this.initialCountryCode = 'LB',
    this.controller,
  });

  @override
  _PhoneFieldAdminState createState() => _PhoneFieldAdminState();
}

class _PhoneFieldAdminState extends State<PhoneFieldAdmin> {
  late bool _isFocused;

  @override
  void initState() {
    super.initState();
    _isFocused = false;
  }

  void _onFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Phone Number',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Expanded(
            child: Focus(
              onFocusChange: _onFocusChange,
              child: IntlPhoneField(
                controller: widget.controller,
                initialCountryCode: widget.initialCountryCode,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF7BB442)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(0xFF7BB442)),
                  ),
                  fillColor: _isFocused
                      ? const Color(0xFFE8FFD1)
                      : const Color(0xFFE8FFD1),
                  filled: true,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                style: const TextStyle(
                  fontSize: 16,
                ),
                dropdownTextStyle: const TextStyle(
                  fontSize: 16,
                ),
                dropdownDecoration: BoxDecoration(
                  color: _isFocused
                      ? const Color(0xFFE8FFD1)
                      : const Color(0xFFE8FFD1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  border: const Border(
                    left: BorderSide(color: Color(0xFF7BB442)),
                    top: BorderSide(color: Color(0xFF7BB442)),
                    bottom: BorderSide(color: Color(0xFF7BB442)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
// class PhoneFieldAdmin extends StatefulWidget {
//   final String initialCountryCode;
//   final TextEditingController? controller;
//
//   const PhoneFieldAdmin({
//     super.key,
//     this.initialCountryCode = 'LB',
//     this.controller,
//   });
//
//   @override
//   _PhoneFieldAdminState createState() => _PhoneFieldAdminState();
// }
//
// class _PhoneFieldAdminState extends State<PhoneFieldAdmin> {
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
//       height: 90,
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 40),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Phone Number',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Expanded(
//             child: Focus(
//               onFocusChange: _onFocusChange,
//               child: InternationalPhoneNumberInput(
//                 onInputChanged: (PhoneNumber number) {
//                   print(number.phoneNumber);
//                 },
//                 textFieldController: widget.controller,
//                 initialValue: PhoneNumber(isoCode: widget.initialCountryCode),
//                 inputDecoration: InputDecoration(
//                   enabledBorder: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: Color(0xFF7BB442)),
//                   ),
//                   focusedBorder: const OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                     borderSide: BorderSide(color: Color(0xFF7BB442)),
//                   ),
//                   fillColor: _isFocused
//                       ? const Color(0xFFE8FFD1)
//                       : const Color(0xFFE8FFD1),
//                   filled: true,
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                 ),
//                 textStyle: const TextStyle(
//                   fontSize: 16,
//                 ),
//                 selectorTextStyle: const TextStyle(
//                   fontSize: 16,
//                 ),
//                 // dropdownDecoration: BoxDecoration(
//                 //   color: _isFocused
//                 //       ? const Color(0xFFE8FFD1)
//                 //       : const Color(0xFFE8FFD1),
//                 //   borderRadius: const BorderRadius.only(
//                 //     topLeft: Radius.circular(10),
//                 //     bottomLeft: Radius.circular(10),
//                 //   ),
//                 //   border: const Border(
//                 //     left: BorderSide(color: Color(0xFF7BB442)),
//                 //     top: BorderSide(color: Color(0xFF7BB442)),
//                 //     bottom: BorderSide(color: Color(0xFF7BB442)),
//                 //   ),
//                 // ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
