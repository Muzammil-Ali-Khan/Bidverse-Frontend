class UserModel {
  String? id;
  String name;
  String email;
  String number;
  String image;
  List<String> favourites;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.number,
    required this.image,
    required this.favourites,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] as String,
      name: json["name"] as String,
      email: json["email"] as String,
      number: json["number"] as String,
      image: json["image"] as String,
      favourites: (json["favourites"] as List).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "number": number,
      "image": image,
      "favourites": favourites,
    };
  }
}
