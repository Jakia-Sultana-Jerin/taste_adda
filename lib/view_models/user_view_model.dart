import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taste_adda/models/user_model.dart';

class UserViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
  UserModel? _user;
  // Future<void>? _recipeFuture;

  UserModel? get user => _user;

  Future<void> fetchUser({required String id}) async {
    try {
      final response = await _dio.get(
        "https://api.npoint.io/334431f16da0567a151d",
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Extract userJson from the response data
        final userJson = data;

        if (userJson != null) {
          _user = UserModel.fromJson(userJson);
          notifyListeners();
        } else {
          print("User not found with id: $id");
        }
      } else {
        print("API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  
}
