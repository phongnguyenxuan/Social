import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';

class SettingsApp extends StatefulWidget {
  const SettingsApp({super.key});

  @override
  State<SettingsApp> createState() => _SettingsAppState();
}

class _SettingsAppState extends State<SettingsApp> {
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Settings", style: titleText),
      ),
      body: Container(
        constraints: BoxConstraints(minHeight: size.height),
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage your font size, color, and background. These settings affect all the accounts on this device.',
              style: bodyText,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Divider(
                thickness: 1,
                height: 1,
                color: Colors.white30,
              ),
            ),
            Text(
              'Color',
              style: titleText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.blue),
                      child: null,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.yellow),
                      child: null,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.pink),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.purple),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.orange),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              thickness: 1,
              height: 1,
              color: Colors.white30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Theme mode',
                style: titleText,
              ),
            ),
            Flex(
              direction:
                  size.width >= webScreenSize ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black),
                        shape: BoxShape.rectangle,
                        color: Colors.white),
                    child: Center(
                      child: Text(
                        'Light mode',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                            color: Colors.black, fontSize: bodyTextSize),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.rectangle,
                        color: secondColor),
                    child: Center(
                      child: Text(
                        'Dark mode',
                        textAlign: TextAlign.center,
                        style: bodyText,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 60,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                        shape: BoxShape.rectangle,
                        color: backgroundColor),
                    child: Center(
                        child: Text('System mode',
                            textAlign: TextAlign.center, style: bodyText)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
