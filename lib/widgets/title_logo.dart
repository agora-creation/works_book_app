import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class TitleLogo extends StatelessWidget {
  const TitleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(
          Icons.menu_book,
          color: kBaseColor,
          size: 40,
        ),
        Text(
          'お仕事手帳',
          style: TextStyle(
            color: kBaseColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        Text(
          'WORKS BOOK',
          style: TextStyle(
            color: kGreyColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }
}
