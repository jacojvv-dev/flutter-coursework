import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userId;
  List<OrderItem> _orders = [];

  Orders(this._orders, this.authToken, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final decodedResponse = json.decode(response.body) as Map<String, dynamic>;
    if (decodedResponse == null) {
      return;
    }

    decodedResponse.forEach((k, v) {
      loadedOrders.add(
        OrderItem(
          id: k,
          amount: v['amount'],
          dateTime: DateTime.parse(v['dateTime']),
          products: (v['products'] as List<dynamic>)
              .map(
                (i) => CartItem(
                  id: i['id'],
                  price: i['price'],
                  quantity: i['quantity'],
                  title: i['title'],
                ),
              )
              .toList(),
        ),
      );
    });

    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken";

    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (p) => {
                  'id': p.id,
                  'title': p.title,
                  'quantity': p.quantity,
                  'price': p.price,
                },
              )
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
