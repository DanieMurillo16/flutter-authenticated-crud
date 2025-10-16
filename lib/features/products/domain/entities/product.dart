
import 'package:teslo_shop/features/auth/domain/entities/user.dart';

class Products {
    final String id;
    final String title;
    final double price;
    final String description;
    final String slug;
    final int stock;
    final List<String> sizes;
    final String gender;
    final List<String> tags;
    final List<String> images;
    final User? user;

    Products({
        required this.id,
        required this.title,
        required this.price,
        required this.description,
        required this.slug,
        required this.stock,
        required this.sizes,
        required this.gender,
        required this.tags,
        required this.images,
        this.user,
    });

    // factory Products.fromJson(Map<String, dynamic> json) => Products(
    //     id: json["id"],
    //     title: json["title"],
    //     price: json["price"],
    //     description: json["description"],
    //     slug: json["slug"],
    //     stock: json["stock"],
    //     sizes: List<String>.from(json["sizes"].map((x) => x)),
    //     gender: json["gender"],
    //     tags: List<String>.from(json["tags"].map((x) => tagValues.map[x]!)),
    //     images: List<String>.from(json["images"].map((x) => x)),
    //     user: User.fromJson(json["user"]),
    // );

}

