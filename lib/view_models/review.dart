import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:taste_adda/models/review_model.dart';

class ReviewViewModel extends ChangeNotifier {
  final Dio _dio = Dio();
   List<ReviewModel> _review = [];
  
  Future<void>? _reviewFuture;
 List<ReviewModel> get review => _review;
  Future<void> get reviewFuture => _reviewFuture ??= fetchReview();

  

  Future<void> fetchReview() async {
    try {
      final response = await _dio.get("https://api.npoint.io/9ccd52794dfaa0a98ad1");
      if (response.statusCode == 200 && response.data['error'] == false) {
        final List<dynamic> dataList = response.data['data'];
        _review = dataList.map((json) => ReviewModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }
}
