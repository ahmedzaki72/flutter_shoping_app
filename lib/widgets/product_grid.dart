import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';
import '../providers/products_provider.dart';


class ProductGrid extends StatelessWidget {
   final bool showFavorites;

   ProductGrid({this.showFavorites});

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavorites ? productData.favorites : productData.items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          // create: (c) => products[index],
          value: products[index],
          child: ProductItem(
            // id: products[index].id,
            // title: products[index].title,
            // imageUrl: products[index].imageUrl,
          ),
        );
      },
      itemCount: products.length,
    );
  }
}