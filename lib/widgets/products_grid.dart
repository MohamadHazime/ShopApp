import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductsGrid extends StatelessWidget {
  final List<Product> products;
  final bool showOnlyFavorite;
  final String productNameSearch;
  final page;

  const ProductsGrid(
      this.products, this.showOnlyFavorite, this.productNameSearch, this.page);

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    // var products =
    //     showOnlyFavorite ? productsData.favoriteItems : productsData.items;
    // products = products
    //     .where((element) => element.title
    //         .toLowerCase()
    //         .contains(productNameSearch.toLowerCase()))
    //     .toList();
    return products.length == 0
        ? Container(
            child: Center(
              child: Text('No Products'),
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: 6,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: i + (page * 6) >= products.length
                  ? products[0]
                  : products[i + (page * 6)],
              child: i + (page * 6) >= products.length
                  ? Container()
                  : ProductItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          );
  }
}
