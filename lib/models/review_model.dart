class ReviewModel {
  final String id;
  final String? attachment;
  final String description;
  final String user;
  final String rating;
  final String profilepic;

  ReviewModel({
    required this.id,
    this.attachment,
    required this.description,
    required this.user,
    required this.rating,
    required this.profilepic,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      attachment: json['attachment'] ?? '',
      description: json['description'] ?? '',
      rating: json['rating']?.toString() ?? ' ',
      profilepic: json['profilepic']?? '',
    );
  }
}
