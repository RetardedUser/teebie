class Resenia {
  final String slug, restaurant, email, comments, created;
  final int rating;

  Resenia(
      {required this.slug,
      required this.restaurant,
      required this.email,
      required this.comments,
      required this.rating,
      required this.created});

  factory Resenia.fromJson(Map<String, dynamic> json) {
    return Resenia(
      slug: json['slug'],
      restaurant: json['restaurant'],
      email: json['email'],
      comments: json['comments'],
      rating: json['rating'],
      created: json['created'],
    );
  }

  dynamic toJson() => {
        'slug': '$slug',
        'restaurant': '$restaurant',
        'email': '$email',
        'comments': '$comments',
        'rating': '$rating',
        'created': '$created',
      };

  static dynamic fromToJSON(Map<String, dynamic> json) {
    return Resenia.fromJson(json).toJson();
  }
}
