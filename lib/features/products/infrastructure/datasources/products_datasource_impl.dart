import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/domain/products_datasource.dart';
import 'package:teslo_shop/features/products/infrastructure/mappers/product_mapper.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String accesToken;
  ProductsDatasourceImpl({required this.accesToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiurl,
            headers: {'Authorization': 'Bearer $accesToken'}));

  @override
  Future<Products> createUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';
      productLike.remove('id');
      final response = await dio.request(url,
          data: productLike, options: Options(method: method));
      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<Products> getProductsById(String id) async {
    try {
      final response = await dio.get('/products/$id');
      final Products product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      // 1. Manejo de error de Dio (ej: 404, 500)
      if (e.response?.statusCode == 404) {
        // Si el servidor responde con 404 (No Encontrado), lanza una excepción específica.
        throw Exception(
            'Error en el servidor, producto no encontrado: ${e.message}');
      }
      // Para cualquier otro error de Dio (problemas de conexión, 500, etc.)
      throw Exception('Error al obtener el producto: ${e.message}');
    } catch (e) {
      // 2. Manejo de errores de código (ej: error en la serialización del JSON)
      throw Exception('Error inesperado al cargar el producto.');
    }
  }

  @override
  Future<List<Products>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response =
        await dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Products> products = [];
    for (var product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Products>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
