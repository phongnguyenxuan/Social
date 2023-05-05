import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/screens/profile/profile.dart';
import 'package:myblog/utils/my_color.dart';

class UserCard extends StatelessWidget {
  final model.User user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (
              context,
            ) =>
                    Profile(
                      uid: user.uid!,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        constraints: const BoxConstraints(maxHeight: double.infinity),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondColor,
            border: Border.all(color: Colors.white30)),
        child: Row(
          children: [
            //profile image
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey)),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                      child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Image.network(
                      user.photoURL!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        //loading image
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white60,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  )),
                ),
              ),
            ),
            //username
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: user.displayName,
                      style: GoogleFonts.nunitoSans(
                          color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(
                          text:
                              user.nickname != "" ? " (${user.nickname})" : "",
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white54, fontSize: 12),
                        )
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "@${user.displayName!}",
                      style: GoogleFonts.nunitoSans(
                          color: Colors.white54, fontSize: 12),
                      children: [
                        TextSpan(
                          text: " • ${user.followers!.length} followers",
                          style: GoogleFonts.nunitoSans(
                              color: Colors.white54, fontSize: 12),
                        )
                      ]),
                ),
              ],
            ),
            user.uid!.contains(FirebaseAuth.instance.currentUser!.uid)
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("( You )",
                        style: GoogleFonts.nunitoSans(
                            color: Colors.white54, fontSize: 15)),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
