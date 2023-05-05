class User {
  String? uid;
  String? displayName;
  String? nickname;
  String? photoURL;
  String? coverPhoto;
  String? email;
  String? bio;
  List? followers;
  List? following;
  List? likesPosts;

  User({
    this.uid,
    this.displayName,
    this.nickname,
    this.photoURL,
    this.email,
    this.bio,
    this.followers,
    this.following,
    this.coverPhoto,
    this.likesPosts,
  });
  static User fromSnap(Map<String, dynamic> snapshot) {
    return User(
      uid: snapshot['uid'],
      displayName: snapshot['displayName'],
      nickname: snapshot['nickname'],
      photoURL: snapshot['photoURL'],
      coverPhoto: snapshot['coverPhoto'],
      email: snapshot['email'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      following: snapshot['following'],
      likesPosts: snapshot['likesPosts'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'displayName': displayName,
      'nickname': nickname,
      'photoURL': photoURL,
      'coverPhoto': coverPhoto,
      'email': email,
      'bio': bio,
      'followers': followers,
      'following': following,
      'likesPosts': likesPosts,
    };
  }
}
