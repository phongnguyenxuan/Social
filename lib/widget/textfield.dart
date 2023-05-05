// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';

class MyTextField extends StatefulWidget {
  final double width;
  final double? height;
  final String text;
  final Widget? icon;
  final TextEditingController controller;
  final double radius;
  final bool isPass;
  final bool? isEmpty;
  final int? maxLength;
  final String? initValue;
  final Function(String)? onChanged;
  const MyTextField({
    Key? key,
    required this.width,
    this.height,
    required this.text,
    this.icon,
    this.maxLength,
    this.initValue,
    this.onChanged,
    required this.controller,
    required this.isPass,
    this.isEmpty,
    required this.radius,
  }) : super(key: key);

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool isHide = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      style: bodyText,
      cursorColor: mainTextColor,
      maxLines: null,
      obscureText: isHide,
      maxLength: widget.maxLength,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        if (widget.isEmpty != true &&
            widget.controller.text == '' &&
            widget.initValue != null) {
          setState(() {
            widget.controller.text = widget.initValue!;
          });
          //dismiss keyboard
          FocusScope.of(context).unfocus();
        }
      },
      decoration: InputDecoration(
          prefixIcon: widget.icon,
          // hintText: 'type something',
          filled: true,
          fillColor: inputFieldColor,
          hintStyle: smallText,
          labelText: widget.text,
          counterStyle: bodyText,
          labelStyle: bodyText,
          suffixIcon: widget.isPass
              ? InkWell(
                  onTap: () {
                    setState(() {
                      isHide = !isHide;
                    });
                  },
                  child: isHide
                      ? const Icon(
                          FontAwesomeIcons.eyeSlash,
                          color: unselectedTextColor,
                          size: 15,
                        )
                      : const Icon(
                          FontAwesomeIcons.eye,
                          color: unselectedTextColor,
                          size: 15,
                        ),
                )
              : null,
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: inputFieldColor)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: inputFieldColor)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.radius),
              borderSide: const BorderSide(color: inputFieldColor))),
    );
  }
}
