import 'package:flutter/material.dart';

class BottomSheetItem extends StatelessWidget {
  const BottomSheetItem({
    Key? key,
    required this.label,
    required this.onTap,
    required this.clr,
  }) : super(key: key);

  final String label;
  final Function() onTap;
  final Color clr;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            primary: clr,
          ),
          onPressed: onTap,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}
