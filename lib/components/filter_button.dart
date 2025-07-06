import 'package:flutter/material.dart';

class FilterButton extends StatefulWidget {
  final String filterText;
  final bool isSelected;
  final Function onTap;

  const FilterButton(
      {super.key,
      required this.filterText,
      required this.isSelected,
      required this.onTap});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  @override
  Widget build(BuildContext context) {
    bool isAll = widget.filterText == 'All';

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(19, 27, 10, 1),
            Color.fromRGBO(101, 148, 54, 1),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: widget.isSelected ? Colors.black : Colors.transparent,
          width: 1,
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isAll ? 15 : 5, vertical: 5),
      child: GestureDetector(
        onTap: () {
          widget.onTap();
        },
        child: Row(
          children: [
            if (!isAll) ...[
              Image.asset(
                'assets/images/Calendar.png',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              widget.filterText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
