import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:works_book_app/common/style.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'お仕事手帳',
                style: TextStyle(
                  color: kBaseColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SpinKitFadingCircle(color: kBaseColor),
            ],
          ),
        ),
      ),
    );
  }
}
