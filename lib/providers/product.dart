import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  /// i will not using final with isFavorite because this is change able ;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavorite(bool newFavorite) {
    isFavorite = newFavorite;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = "https://flutter-update-9c07a.firebaseio.com/products/$id.json";
    try {
     final response =  await http.patch(
        url,
        body: jsonEncode(
          {
            'isFavorite': isFavorite,
          },
        ),
      );
      if(response.statusCode >= 400) {
        _setFavorite(oldFavorite);
      }
    } catch (error) {
      _setFavorite(oldFavorite);
    }
  }
}
