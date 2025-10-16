import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsRepository {
  Future<List<Products>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Products> getProductsById(String id);
  Future<List<Products>> searchProductByTerm(String term);
  Future<Products> createUpdateProduct(Map<String,dynamic> product);
}
