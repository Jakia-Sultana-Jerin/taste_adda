import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:taste_adda/models/review_model.dart';




class ReviewViewModel extends ChangeNotifier {
  String? id;
  late Dio _dio;
  List<ReviewModel> _review = [];

  final baseUrl = 'https://eclectic-melba-274878.netlify.app/';

  ReviewViewModel() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
  }

  List<ReviewModel> get review => _review;

  Future<void> fetchRecipeById(id) async {
    try {
      final response = await _dio.get("/recipes/$id");
      if (response.statusCode == 200 && response.data['error'] == false) {
        final recipe = response.data['data'];
        final List<dynamic> reviewsJson = recipe['reviews'];
        _review = reviewsJson.map((json) => ReviewModel.fromJson(json)).toList();
        notifyListeners();

        print("Fetched reviews: ${response.data['data']['reviews']}");
      } else {
        print("Failed to fetch recipe: ${response.data}");
      }
    } catch (e) {
      print("Fetch error: $e");
    }
  }

  Future<void> submitReview({
    required String id,
    required String user,
    required String description,
    required double rating,
    String? profilePic,
  }) async {
    try {
      final reviewData = {
        "user": user,
        "description": description,
        "rating": rating.toString(),
        "profilepic": profilePic ?? "",
      };

      final response = await _dio.post(
        "/recipes/$id/reviews",
        data: reviewData,
      );

      if (response.statusCode == 200 && response.data['error'] == false) {
        print("Review submitted successfully!");
        await fetchRecipeById(id); // Submit er pore abar fetch
      } else {
        print("Failed to submit review: ${response.data}");
      }
    } catch (e) {
      print("Submit error: $e");
    }
  }
}

// class ReviewViewModel extends ChangeNotifier {
//   late Dio _dio;
//    List<ReviewModel> _review = [];

   
//   final baseUrl =
//       kIsWeb
//           ? 'https://dingo-proper-mistakenly.ngrok-free.app/'
//           : 'https://dingo-proper-mistakenly.ngrok-free.app/';

//   ReviewViewModel() {
//     _dio = Dio(
//       BaseOptions(
//         baseUrl: baseUrl,
//         connectTimeout: const Duration(seconds: 300),
//         receiveTimeout: const Duration(seconds: 300),
//       ),
//     );
//   }
  
//   Future<void>? _reviewFuture;
//  List<ReviewModel> get review => _review;
//   Future<void> get reviewFuture => _reviewFuture ??= fetchReview();

  

//   Future<void> fetchReview() async {
//     try {
//       final response = await _dio.get("/reviews");
//       if (response.statusCode == 200 && response.data['error'] == false) {
//         final List<dynamic> dataList = response.data['data'];
//         _review = dataList.map((json) => ReviewModel.fromJson(json)).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       print("Fetch error: $e");
//     }
//   }

//   Future<void> submitReview({
//     required String id,
//     required String user,
//     required String description,
//     required double rating,
   
//     String? profilePic,
//   }) async {
//     try {
//       final userreview = {
       
//         "user": user,
//         "description": description,

//         "rating": rating.toString(),
//         "profilepic": profilePic,
//       };

//       final response = await _dio.post(
//         "/recipes/$id/reviews",
//         data: userreview,
//       );

//       if (response.statusCode == 200 && response.data['error'] == false) {
//         print("Review submitted successfully!");

       
//         await fetchReview();
//       } else {
//         print("Failed to submit review: ${response.data}");
//       }
//     } catch (e) {
//       print("Submit error: $e");
//     }
//   }




// }
