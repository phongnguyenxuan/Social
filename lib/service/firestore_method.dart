import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/models/user.dart';
import 'package:myblog/utils/global_variable.dart';

class FireStoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _fireStorage = FirebaseStorage.instance;
  //follow user
  Future<void> followUser(String userLogin, String oUser) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(userLogin).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(oUser)) {
        await _firestore.collection('users').doc(oUser).update({
          'followers': FieldValue.arrayRemove([userLogin])
        });

        await _firestore.collection('users').doc(userLogin).update({
          'following': FieldValue.arrayRemove([oUser])
        });
      } else {
        await _firestore.collection('users').doc(oUser).update({
          'followers': FieldValue.arrayUnion([userLogin])
        });

        await _firestore.collection('users').doc(userLogin).update({
          'following': FieldValue.arrayUnion([oUser])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //like post
  Future<bool> likePost(String uid, String postID) async {
    bool res = false;
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Posts').doc(postID).get();
      List like = (snap.data()! as dynamic)['likes'];
      if (like.contains(uid)) {
        await _firestore.collection('Posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'likesPosts': FieldValue.arrayRemove([postID])
        });
        res = false;
      } else {
        await _firestore.collection('Posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('users').doc(uid).update({
          'likesPosts': FieldValue.arrayUnion([postID])
        });
        res = true;
      }
    } catch (e) {
      print(e.toString());
    }
    return res;
  }

  //delete post
  Future<void> deletePost(String postID, String postUrl) async {
    try {
      await _firestore.collection('Posts').doc(postID).delete();
      if (postUrl != "") {
        await _fireStorage.ref("Posts/$postID/").child("/image").delete();
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
