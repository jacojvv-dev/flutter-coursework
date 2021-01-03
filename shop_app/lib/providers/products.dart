import 'package:flutter/material.dart';
import 'package:shop_app/exceptions/http_exception.dart';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String authToken;
  final String userId;

  Products(this._items, this.authToken, this.userId);

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((p) => p.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((i) => i.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? "&orderBy=\"creatorId\"&equalTo=\"$userId\"" : "";
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/products.json?auth=$authToken$filterString";
    try {
      final response = await http.get(url);
      final decodedData = json.decode(response.body) as Map<String, dynamic>;
      if (decodedData == null) {
        return;
      }

      final favoriteData = await http.get(
          "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken");

      final decodedFavoriteData =
          json.decode(favoriteData.body) as Map<String, dynamic>;

      final List<Product> loadedProducts = [];
      decodedData.forEach((k, v) {
        loadedProducts.add(Product(
          id: k,
          title: v['title'],
          description: v['description'],
          price: v['price'],
          imageUrl: v['imageUrl'],
          isFavorite: decodedFavoriteData == null
              ? false
              : decodedFavoriteData[k] ?? false,
        ));

        _items = loadedProducts;
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/products.json?auth=$authToken";

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );

      _items.add(Product(
        id: json.decode(response.body)['name'],
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      var index = _items.indexWhere((p) => p.id == id);
      if (index >= 0) {
        _items[index] = newProduct;
        notifyListeners();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        "https://flutter-course-d0cfd-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken";

    final existingProductIndex = _items.indexWhere((p) => p.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete product.");
    }
    existingProduct = null;
  }
}
