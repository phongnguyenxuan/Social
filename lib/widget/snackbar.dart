// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:myblog/utils/my_color.dart';

// ignore: camel_case_types
class cSnackBar extends StatelessWidget {
  String title;
  String message;
  bool isErrorBanner;
  cSnackBar({
    Key? key,
    required this.title,
    required this.message,
    required this.isErrorBanner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
          color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 600,
            height: 100,
            decoration: BoxDecoration(
                color: isErrorBanner ? errorColor : successColor,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: (60) - (160 / 3),
            left: 10,
            child: SizedBox(
                width: 60,
                height: 60,
                child: isErrorBanner
                    ? Image.asset('assets/images/error.png')
                    : Image.asset('assets/images/success.png')),
          ),
        ],
      ),
    );
  }
}
