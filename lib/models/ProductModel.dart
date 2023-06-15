class ProductModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String userId;
  final String image;
  final DateTime endTime;
  final bool isFeatured;
  final List<Map<String, dynamic>> bidAmounts;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.userId,
    required this.image,
    required this.endTime,
    required this.isFeatured,
    required this.bidAmounts,
    required this.category,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      userId: json['userId'] as String,
      endTime: DateTime.parse(json['endTime'] as String),
      isFeatured: json['isFeatured'] as bool,
      category: json['category'] as String,
      image: json['image'] as String,
      bidAmounts: (json['bidAmounts'] as List).map((bid) => bid as Map<String, dynamic>).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'userId': userId,
      'image': image,
      "category": category,
      'isFeatured': isFeatured,
      'bidAmounts': bidAmounts,
      'endTime': endTime
    };
  }
}
