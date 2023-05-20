// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/screens/profile/profile.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';
import 'package:myblog/widget/postdetails.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:myblog/service/firestore_method.dart';
import 'package:timeago/timeago.dart' as timeago;

class Poster extends StatefulWidget {
  final Post post;
  const Poster({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<Poster> createState() => _PosterState();
}

// ignore: camel_case_types
class _PosterState extends State<Poster> {
  bool isLike = false;
  List likes = [];
  //get like
  getLike() async {
    likes = widget.post.likes;
    // ignore: unnecessary_this
    if (this.mounted) {
      setState(() {
        if (likes.contains(FirebaseAuth.instance.currentUser!.uid)) {
          isLike = true;
        } else {
          isLike = false;
        }
      });
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getLike();
  }

  @override
  Widget build(BuildContext context) {
    try {
      final userLogin = FirebaseAuth.instance.currentUser!;
      return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) => Dialog.fullscreen(
                  child: PostDetails(postID: widget.post.postId)));
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: double.infinity),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: secondColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Tooltip(
                    message: 'View @${widget.post.user.displayName} profile',
                    child: InkWell(
                      onTap: () {
                        Future.delayed(Duration.zero, () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (
                              context,
                            ) =>
                                    Profile(
                                      uid: widget.post.user.uid!,
                                    )),
                          );
                        });
                      },
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey)),
                        child: ClipOval(
                            child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.network(
                            widget.post.user.photoURL!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              //loading image
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white60,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                              text: widget.post.user.displayName!,
                              style: bodyText,
                              children: [
                                TextSpan(
                                  text:
                                      '  •  ${timeago.format(widget.post.datePublished, allowFromNow: true)}',
                                  style: smallText,
                                )
                              ]),
                        ),
                        Text(widget.post.user.email!, style: smallText)
                      ],
                    ),
                  ),
                  const Spacer(),
                  // widget.post.uid.contains(widget.userID)
                  PopupMenuButton(
                    color: backgroundColor,
                    icon: const Icon(
                      FontAwesomeIcons.ellipsis,
                      size: 20,
                      color: Colors.white,
                    ),
                    itemBuilder: (context) {
                      if (widget.post.uid == userLogin.uid) {
                        return [
                          PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                "Edit",
                                style: bodyText,
                              )),
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                  () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: backgroundColor,
                                      title: Text(
                                        'Delete Posts',
                                        style: bodyText,
                                      ),
                                      content: Text(
                                        'Are you sure you want to delete this posts ?',
                                        style: bodyText,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: bodyText,
                                            )),
                                        TextButton(
                                            onPressed: () {
                                              FireStoreMethod().deletePost(
                                                  widget.post.postId,
                                                  widget.post.postImage);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Delete",
                                              style: bodyText,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "Delete this posts",
                                style: bodyText,
                              )),
                        ];
                      } else {
                        //
                        return [
                          widget.post.postImage != ""
                              ? PopupMenuItem(
                                  onTap: () {},
                                  child:
                                      Text("Download image", style: bodyText))
                              : PopupMenuItem(
                                  height: 0,
                                  enabled: false,
                                  child: Container()),
                          PopupMenuItem(
                              onTap: () {},
                              child: Text(
                                "Add post to your list",
                                style: bodyText,
                              )),
                          PopupMenuItem(
                              onTap: () {
                                Future.delayed(const Duration(seconds: 0), () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (
                                        context,
                                      ) =>
                                              Profile(uid: widget.post.uid)));
                                });
                              },
                              child: Text(
                                "View @${widget.post.user.displayName} profile",
                                style: bodyText,
                              )),
                        ];
                      }
                    },
                  )
                ],
              ),
              //title
              widget.post.title != ""
                  ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: widget.post.title.length > 400
                          ? ExpandableNotifier(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expandable(
                                    collapsed: SelectableLinkify(
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
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
                                      maxLines: 6,
                                      text: widget.post.title,
                                      style: bodyText,
                                      linkStyle: linkText,
                                    ),
                                    expanded: SelectableLinkify(
                                      scrollPhysics:
                                          const NeverScrollableScrollPhysics(),
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
                                      text: widget.post.title,
                                      style: bodyText,
                                      linkStyle: linkText,
                                    ),
                                  ),
                                  Builder(
                                    builder: (context) {
                                      var controller = ExpandableController.of(
                                          context,
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
                                          style: linkText,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            )
                          : SelectableLinkify(
                              onOpen: (link) async {
                                if (await canLaunchUrl(Uri.parse(link.url))) {
                                  await launchUrl(Uri.parse(link.url),
                                      mode: LaunchMode
                                          .externalNonBrowserApplication);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              text: widget.post.title,
                              style: bodyText,
                              linkStyle: linkText,
                            ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: widget.post.postImage == ""
                      ? null
                      : Center(
                          child: Image.network(
                            widget.post.postImage,
                            loadingBuilder: (context, child, loadingProgress) {
                              //loading image
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white60,
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
              const Divider(
                color: Colors.white54,
              ),
              //footer
              Padding(
                padding: const EdgeInsets.only(right: 50, left: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Tooltip(
                      message: isLike ? 'Unlike' : 'Like',
                      child: LikeButton(
                        size: 30,
                        likeCount: widget.post.likes.length,
                        countPostion: CountPostion.right,
                        onTap: (isLiked) async {
                          isLike = await FireStoreMethod()
                              .likePost(userLogin.uid, widget.post.postId);
                          if (mounted) {
                            setState(() {
                              isLiked = isLike;
                            });
                          }
                          return isLiked;
                        },
                        likeBuilder: (isLiked) {
                          isLiked = isLike;
                          return Icon(
                            isLiked
                                ? FontAwesomeIcons.solidHeart
                                : FontAwesomeIcons.heart,
                            color: isLiked ? likeColor : Colors.white60,
                            size: 17,
                          );
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Reply',
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.comment,
                            size: 17,
                            color: Colors.white60,
                          )),
                    ),
                    Tooltip(
                      message: 'Bookmark',
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.bookmark,
                            size: 17,
                            color: Colors.white60,
                          )),
                    ),
                    Tooltip(
                      message: 'Share',
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            FontAwesomeIcons.share,
                            size: 17,
                            color: Colors.white60,
                          )),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    } catch (_) {
      return Container();
    }
  }
}
