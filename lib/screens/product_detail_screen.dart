import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = 'product_Detail';
  // final String title;
  //
  // ProductDetailScreen({this.title});
  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context).settings.arguments as String;
    // final loadedProduct = Provider.of<Products>(context).items.firstWhere((element) => element.id == productId);
    /// you can using filter inside class products providers
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    print(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background:  Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  '\$${loadedProduct.price}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '${loadedProduct.description}',
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800,),
              ],
            ),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 300,
      //         width: double.infinity,
      //         child: Hero(
      //           tag: loadedProduct.id,
      //           child: Image.network(
      //             loadedProduct.imageUrl,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Text(
      //         '\$${loadedProduct.price}',
      //         style: TextStyle(
      //           color: Colors.grey,
      //           fontSize: 20,
      //         ),
      //       ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       Container(
      //         width: double.infinity,
      //         padding: EdgeInsets.symmetric(horizontal: 10),
      //         child: Text(
      //           '${loadedProduct.description}',
      //           textAlign: TextAlign.center,
      //           softWrap: true,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
