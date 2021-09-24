class TipoComida {
  final String slug;
  final String name;

  TipoComida({required this.slug, required this.name});

  factory TipoComida.fromJson(Map<String, dynamic> json) {
    return TipoComida(
      slug: json['slug'],
      name: json['name'],
    );
  }

  dynamic toJson() => {
        'slug': '$slug',
        'name': '$name',
      };

  static dynamic fromToJSON(Map<String, dynamic> json) {
    return TipoComida.fromJson(json).toJson();
  }
}
