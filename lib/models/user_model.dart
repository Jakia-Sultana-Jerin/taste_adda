class UserModel {
  final String id;
  final String userName;
  final String description;
  final String email;
 
  final String phoneNumber;
  final String country;
  final String profilePicture;
   final String joined;

  UserModel({
    required this.id,
    required this.userName,
    required this.description,

    required this.email,
   
    
    required this.phoneNumber,
    required this.country,
    required this.profilePicture,
    required this.joined,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? "",
      userName: json['userName'] ?? "",
      description: json['description'] ?? "",
      email: json['email'] ?? "",
      phoneNumber: json['phoneNumber'] ?? "",
      country: json['country'] ?? "",
      profilePicture: json['profilePicture'] ?? "",
      joined: json['joined'] ?? "",
    );
  }
}
