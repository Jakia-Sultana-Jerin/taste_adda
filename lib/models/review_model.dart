import 'package:taste_adda/models/user_model.dart';

class ReviewModel {
  final String id;
  final String? attachment;
  final String descriptions;
  final UserModel user;

  ReviewModel({
    required this.id,
    this.attachment,
    required this.descriptions,
    required this.user,
  });
}
