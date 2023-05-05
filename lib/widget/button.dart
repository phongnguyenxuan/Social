// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:myblog/utils/my_font.dart';

class MyButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget? icon;
  final String title;
  final Color color;
  final Function() ontap;
  final Border? border;
  const MyButton({
    Key? key,
    required this.width,
    required this.height,
    this.icon,
    this.border,
    required this.title,
    required this.color,
    required this.ontap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ontap,
        child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
                border: border,
                color: color,
                borderRadius: BorderRadius.circular(15)),
            child: icon == null
                ? Center(
                    child: Text(
                      title,
                      style: bodyText,
                    ),
                  )
                : Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/icon-gg.png'),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(title),
                        )
                      ],
                    ),
                  )));
  }
}
