import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:taste_adda/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  String? newUrl; //for profilepicture

  late final Dio _dio;
  final _baseUrl =
      kIsWeb
          ? 'https://dingo-proper-mistakenly.ngrok-free.app/'
          : 'https://dingo-proper-mistakenly.ngrok-free.app/';

  UserViewModel() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  // ───────── single user ─────────
  UserModel? _user;
  UserModel? get user => _user;

  Future<void> fetchUser(String idToken) async {
    try {
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );
      print("............................................");

      debugPrint(' RAW RESPONSE: ${response.data}');
      print("............................................");
      debugPrint(' DATA TYPE: ${response.data['data'].runtimeType}');

      print("Final ID Token: $idToken");
      if (response.statusCode == 200 && response.data['error'] == false) {
        final userData = response.data['data'];
        debugPrint(" User data type: ${userData.runtimeType}");

        if (userData != null && userData is Map<String, dynamic>) {
          _user = UserModel.fromJson(userData);
          notifyListeners();
          debugPrint("User loaded inside VM: ${user?.userName}");
        } else {
          debugPrint('User data is null or invalid format');
        }
      } else {
        debugPrint('API error: ${response.data}');
      }
    } on DioException catch (dioError) {
      debugPrint('Dio error during fetchUser: ${dioError.message}');
    } catch (e) {
      debugPrint('Unexpected error during fetchUser: $e');
    }
  }
  // ───────── list of users (optional) ─────────
  // List<UserModel> _users = [];
  // List<UserModel> get users => _users;

  // Future<void> fetchAllUsers() async {
  //   try {
  //     final res = await _dio.get('/users');
  //     if (res.statusCode == 200 && res.data['error'] == false) {
  //       _users = (res.data['data'] as List<dynamic>)
  //           .map((e) => UserModel.fromJson(e))
  //           .toList(growable: false);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint('fetchAllUsers failed: $e');
  //   }
  // }

  // ───────── add new user (optional) ─────────
  Future<UserModel?> addUser(Map<String, dynamic> body, String idToken) async {
    try {
      final res = await _dio.post(
        '/users',
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (res.statusCode == 200 && res.data['error'] == false) {
        final user = UserModel.fromJson(res.data['data']);
        _user = user;
        notifyListeners();
        return user;
      } else {
        debugPrint(' addUser failed: API error: ${res.data}');
      }
    } catch (e) {
      debugPrint(' addUser failed: $e');
    }
    return null;
  }

  //Update user

  Future<UserModel?> updateUser(
    Map<String, dynamic> body,
    String idToken,
  ) async {
    try {
      final res = await _dio.put(
        '/users/${body["_id"]}', //users/{uid} jokhon uid primary key
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $idToken'}),
      );

      if (res.statusCode == 200 && res.data['error'] == false) {
        final user = UserModel.fromJson(res.data['data']);
        _user = user;
        notifyListeners();
        return user;
      } else {
        debugPrint('updateUser failed: ${res.data}');
      }
    } catch (e) {
      debugPrint('updateUser failed: $e');
    }
    return null;
  }





  Future<String?> uploadProfilePicture(File imageFile) async {
  try {
    String fileName = imageFile.path.split('/').last;

    FormData formData = FormData.fromMap({
      "profilePicture": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    final res = await _dio.post(
      '/upload',
      data: formData,
      options: Options(
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      ),
    );

    if (res.statusCode == 200) {
      final url = res.data['url'];
      debugPrint(' Uploaded URL: $url');
      return url;
    } else {
      debugPrint(' uploadProfilePicture failed: ${res.statusCode}');
    }
  } catch (e) {
    debugPrint(' uploadProfilePicture failed: $e');
  }
  return null;
}

}
