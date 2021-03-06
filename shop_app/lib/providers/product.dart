import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String userId, String authToken) async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken";

    isFavorite = !isFavorite;
    notifyListeners();

    var response = await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );

    if (response.statusCode >= 400) {
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException("Could not update product favourite status.");
    }
  }
}
