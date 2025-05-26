import 'package:taste_adda/models/user_model.dart';

class ReviewModel {
  final String id;
  final String? attachment;
  final String description;
  final String user;

  ReviewModel({
    required this.id,
    this.attachment,
    required this.description,
    required this.user,
  });


  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      attachment: json['attachment'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
