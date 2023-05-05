// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetails extends StatefulWidget {
  final String postID;
  const PostDetails({
    Key? key,
    required this.postID,
  }) : super(key: key);

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Posts')
          .where('postId', isEqualTo: widget.postID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        if (snapshot.hasData) {
          Post post = Post.fromJson(snapshot.data!.docs.first);
          return SafeArea(
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: AppBar(
                backgroundColor: backgroundColor,
              ),
              body: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                        child: post.postImage != ""
                            ? Image.network(
                                post.postImage,
                                fit: BoxFit.scaleDown,
                              )
                            : null),
                    //title
                    post.title != ""
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: post.title.length > 400
                                ? ExpandableNotifier(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expandable(
                                          collapsed: SelectableLinkify(
                                            scrollPhysics:
                                                const NeverScrollableScrollPhysics(),
                                            onOpen: (link) async {
                                              if (await canLaunchUrl(
                                                  Uri.parse(link.url))) {
                                                await launchUrl(
                                                    Uri.parse(link.url),
                                                    mode: LaunchMode
                                                        .externalNonBrowserApplication);
                                              } else {
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            maxLines: 6,
                                            text: post.title,
                                            style: GoogleFonts.nunitoSans(
                                                color: Colors.white,
                                                fontSize: 15),
                                            linkStyle: GoogleFonts.nunitoSans(
                                                color: Colors.blueAccent,
                                                fontSize: 15),
                                          ),
                                          expanded: SelectableLinkify(
                                            scrollPhysics:
                                                const NeverScrollableScrollPhysics(),
                                            onOpen: (link) async {
                                              if (await canLaunchUrl(
                                                  Uri.parse(link.url))) {
                                                await launchUrl(
                                                    Uri.parse(link.url),
                                                    mode: LaunchMode
                                                        .externalNonBrowserApplication);
                                              } else {
                                                throw 'Could not launch $link';
                                              }
                                            },
                                            text: post.title,
                                            style: GoogleFonts.nunitoSans(
                                                color: Colors.white,
                                                fontSize: 15),
                                            linkStyle: GoogleFonts.nunitoSans(
                                                color: Colors.blueAccent,
                                                fontSize: 15),
                                          ),
                                        ),
                                        Builder(
                                          builder: (context) {
                                            var controller =
                                                ExpandableController.of(context,
                                                    required: true)!;
                                            return InkWell(
                                              onTap: () {
                                                controller.toggle();
                                              },
                                              child: Text(
                                                controller.expanded
                                                    ? "show less..."
                                                    : "show more...",
                                                textAlign: TextAlign.start,
                                                style: GoogleFonts.nunitoSans(
                                                    color: Colors.blueAccent,
                                                    fontSize: 15),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                : SelectableLinkify(
                                    onOpen: (link) async {
                                      if (await canLaunchUrl(
                                          Uri.parse(link.url))) {
                                        await launchUrl(Uri.parse(link.url),
                                            mode: LaunchMode
                                                .externalNonBrowserApplication);
                                      } else {
                                        throw 'Could not launch $link';
                                      }
                                    },
                                    text: post.title,
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.white, fontSize: 15),
                                    linkStyle: GoogleFonts.nunitoSans(
                                        color: Colors.blueAccent, fontSize: 15),
                                  ),
                          )
                        : Container(),
                    //like and comment
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
