import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/products_datasource.dart';
import 'package:teslo_shop/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDatasource datasource;
  ProductsRepositoryImpl(this.datasource);

  @override
  Future<Products> createUpdateProduct(Map<String, dynamic> product) {
    return datasource.createUpdateProduct(product);
  }

  @override
  Future<Products> getProductsById(String id) {
    return datasource.getProductsById(id);
  }

  @override
  Future<List<Products>> getProductsByPage({int limit = 10, int offset = 0}) {
    return datasource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Products>> searchProductByTerm(String term) {
    return datasource.searchProductByTerm(term);
  }
}
