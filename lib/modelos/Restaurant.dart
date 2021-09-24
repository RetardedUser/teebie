class Restaurant {
  final String slug, name, description;
  final String? logo;
  final double? rating;
  final List<dynamic> foodType;
  final List<dynamic> reviews;

  Restaurant(
      {required this.slug,
      required this.name,
      required this.description,
      required this.logo,
      required this.foodType,
      required this.rating,
      required this.reviews});

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      logo: json['logo'],
      foodType: json['food_type'],
      rating: json['rating'],
      reviews: json['reviews'],
    );
  }

  dynamic toJson() => {
        'slug': '$slug',
        'name': '$name',
        'infracciones': '$description',
        'logo': '$logo',
        'food_type': '$foodType',
        'rating': '$rating',
        'reviews': '$reviews',
      };

  static dynamic fromToJSON(Map<String, dynamic> json) {
    return Restaurant.fromJson(json).toJson();
  }
}
