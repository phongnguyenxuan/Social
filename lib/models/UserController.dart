// ignore_for_file: file_names
import 'package:myblog/models/user.dart' as model;
import 'package:get/get.dart';
import 'package:myblog/service/auth.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  Rx<model.User>? _user;
  model.User get getUser => _user!.value;
  // model.User? _user;
  final AuthMethods _authMethods = AuthMethods();
  Future<void> refreshUser() async {
    model.User user = await _authMethods.getUserDetails();
    _user = user.obs;
  }
}
