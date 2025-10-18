import 'package:flutter_riverpod/legacy.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/products/domain/entities/product.dart';
import 'package:teslo_shop/features/products/presentation/providers/products_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProdcutFromNotifier, ProdcutFromState, Products>(
  (ref, product) {
    final createUpdateCallBack =
        ref.watch(productsProvider.notifier).createOrUpdateProduct;
    return ProdcutFromNotifier(
        product: product, onSubmitCallbac: createUpdateCallBack);
  },
);

class ProdcutFromNotifier extends StateNotifier<ProdcutFromState> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallbac;
  ProdcutFromNotifier({this.onSubmitCallbac, required Products product})
      : super(ProdcutFromState(
            id: product.id,
            title: Title.dirty(product.title),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            size: product.sizes,
            gender: product.gender,
            inStock: Stock.dirty(product.stock),
            description: product.description,
            tags: product.tags.join(', '),
            images: product.images));

  Future<bool> onFormSubmit() async {
    _touchdEverithing();
    if (!state.isFormVali) return false;
    if (onSubmitCallbac == null) return false;
    final productLike = {
      'id': (state.id == 'new') ? null : state.id,
      'title': state.title.value,
      'price': state.price.value,
      'description': state.description,
      'slug': state.slug.value,
      'stock': state.inStock.value,
      'sizes': state.size,
      'gender': state.gender,
      'tags': state.tags.split(','),
      'images': state.images
          .map(
            (e) => e.replaceAll('${Environment.apiurl}/files/product/', ''),
          )
          .toList()
    };
    try {
      return onSubmitCallbac!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchdEverithing() {
    state = state.copyWith(
        isFormVali: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value)
    ]));
  }

  void onTitleChange(String value) {
    state = state.copyWith(
        title: Title.dirty(value),
        isFormVali: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onSlugChange(String value) {
    state = state.copyWith(
        slug: Slug.dirty(value),
        isFormVali: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onPriceChange(double value) {
    state = state.copyWith(
        price: Price.dirty(value),
        isFormVali: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onStockChange(int value) {
    state = state.copyWith(
        inStock: Stock.dirty(value),
        isFormVali: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value)
        ]));
  }

  void onSizeChange(List<String> sizes) {
    state = state.copyWith(size: sizes);
  }

  void onGenderChange(String gender) {
    state = state.copyWith(gender: gender);
  }

  void onDescripcionChange(String description) {
    state = state.copyWith(description: description);
  }

  void onTagsChange(String tags) {
    state = state.copyWith(tags: tags);
  }
}

class ProdcutFromState {
  final bool isFormVali;
  final String id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> size;
  final String gender;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProdcutFromState(
      {this.isFormVali = false,
      required this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.size = const [],
      this.gender = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProdcutFromState copyWith({
    bool? isFormVali,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? size,
    String? gender,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProdcutFromState(
        isFormVali: isFormVali ?? this.isFormVali,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        size: size ?? this.size,
        gender: gender ?? this.gender,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
