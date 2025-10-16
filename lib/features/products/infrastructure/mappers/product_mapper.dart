import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infastructure/mappers/user_mappers.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';

class ProductMapper {
  static jsonToEntity(Map<String, dynamic> json) => Products(
      id: json['id'],
      title: json['title'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      slug: json['slug'],
      stock: json['stock'],
      sizes: List<String>.from(json['sizes'].map((x) => x)),
      gender: json['gender'],
      tags: List<String>.from(json['tags'].map((tags) => tags)),
      images: List<String>.from(json['images'].map((image) =>
          image.startsWith('http')
              ? image
              : '${Environment.apiurl}/files/product/$image')),
      user: UserMappers.userJsonEntity(json['user']));
}
