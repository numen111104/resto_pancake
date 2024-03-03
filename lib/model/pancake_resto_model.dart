import 'dart:convert';

List<RestoPancake> restoPancakeFromMap(String str) => List<RestoPancake>.from(
    json.decode(str).map((x) => RestoPancake.fromMap(x)));

String restoPancakeToMap(List<RestoPancake> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class RestoPancake {
  final int id;
  final String name;
  final int price;
  final String description;
  final String image;

  RestoPancake({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory RestoPancake.fromMap(Map<String, dynamic> json) => RestoPancake(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        description: json["description"],
        image: json["image"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "description": description,
        "image": image,
      };
}
