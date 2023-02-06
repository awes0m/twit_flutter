// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color textColor;
  final Color backGroundColor;
  const RoundedSmallButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.textColor,
    required this.backGroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
        backgroundColor: backGroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      ),
    );
  }
}
