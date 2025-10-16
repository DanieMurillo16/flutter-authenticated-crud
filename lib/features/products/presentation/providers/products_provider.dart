import 'package:flutter_riverpod/legacy.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/producst_repository_providers.dart';


final productsProvider= StateNotifierProvider<ProductsNotifier,ProductsState>((ref) {
  final productsRepository=ref.watch(productsRepositoryProvider);
  return ProductsNotifier(productsRepository: productsRepository);
  
},);



class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({required this.productsRepository})
      : super(ProductsState()) {
    loandNexPage();
  }

  Future loandNexPage() async {
    if (state.isLoading || state.isLasPage) return;
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);
    if (products.isEmpty) {
      state.copyWhith(isLoading: false, isLasPage: true);
      return;
    }
    state = state.copyWhith(
        isLasPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...products]);
  }
}

class ProductsState {
  final bool isLasPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Products> products;

  ProductsState(
      {this.isLasPage = false,
      this.limit = 10,
      this.offset = 0,
      this.isLoading = false,
      this.products = const []});

  ProductsState copyWhith(
          {bool? isLasPage,
          int? limit,
          int? offset,
          bool? isLoading,
          List<Products>? products}) =>
      ProductsState(
        isLasPage: isLasPage ?? this.isLasPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        products: products ?? this.products,
      );
}
