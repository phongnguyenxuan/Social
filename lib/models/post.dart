// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myblog/models/user.dart' as model;

class Post {
  final String title;
  final List likes;
  final String postId;
  final String uid;
  final String postImage;
  final model.User user;
  final DateTime datePublished;
  const Post({
    required this.title,
    required this.likes,
    required this.postId,
    required this.uid,
    required this.postImage,
    required this.datePublished,
    required this.user,
  });

  static Post fromJson(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      title: snapshot["title"],
      likes: snapshot["likes"],
      postId: snapshot["postId"],
      uid: snapshot["uid"],
      postImage: snapshot["postImage"],
      datePublished: snapshot["datePublished"].toDate(),
      user: model.User.fromSnap(snapshot["user"] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "likes": likes,
        "postId": postId,
        "postImage": postImage,
        "uid": uid,
        "datePublished": datePublished,
        "user": user.toJson(),
      };
}
