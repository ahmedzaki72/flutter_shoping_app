import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.amount, this.products, this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId,this._order);

  List<OrderItem> get order {
    return [..._order];
  }

  Future<void> fetchSetOrder() async {
    final url = "https://flutter-update-9c07a.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    if(extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrder.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (e) => CartItem(
                  id: e['id'],
                  title: e['title'],
                  price: e['price'],
                  quantity: e['quantity'],
                ),
              )
              .toList(),
        ),
      );
    });
    _order = loadedOrder.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> orderProduct, double total) async {
    final url = "https://flutter-update-9c07a.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': orderProduct
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList(),
        },
      ),
    );
    _order.insert(
      0,
      OrderItem(
        id: jsonDecode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: orderProduct,
      ),
    );
    notifyListeners();
  }
}
