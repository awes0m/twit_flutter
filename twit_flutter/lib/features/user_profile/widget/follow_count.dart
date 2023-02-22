import 'package:flutter/material.dart';
import 'package:twit_flutter/theme/theme.dart';

class FollowCount extends StatelessWidget {
  final int count;
  final String text;
  const FollowCount({
    Key? key,
    required this.count,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '$count',
          style: const TextStyle(
            color: Pallete.whiteColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: Pallete.greyColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
