import 'dart:developer';

import 'package:flutter/foundation.dart' as foundation;

import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7;

class AppStateModel extends foundation.ChangeNotifier {
  // All the available products.
  final List<Product> _availableProducts = [];

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final _productsInCart = <String, int>{};

  Map<String, int> get productsInCart {
    return Map.from(_productsInCart);
  }

  void loadProducts() async {
    try {
      final res = await http.get(
        Uri.parse("https://shopping-api.deta.dev/products/all"),
      );

      final Map<String, dynamic> body = convert.jsonDecode(res.body);
      final data = body["data"] as List<dynamic>;
      _availableProducts.clear();
      for (var product in data) {
        _availableProducts.add(Product(
          category: Category.all,
          id: product["product_id"],
          name: product["name"],
          price: product["price"],
          imageUrl: product["image"],
          isFeatured: false,
        ));
      }
      notifyListeners();
    } catch (err) {
      log(err.toString());
    }
  }

  // The IDs and quantities of products currently in the favourites.
  final _productsInFavourites = <String, int>{};

  Map<String, int> get productsInFavourites {
    return Map.from(_productsInFavourites);
  }

  // Total number of items in the cart.
  int get totalCartQuantity {
    return _productsInCart.values.fold(0, (accumulator, value) {
      return accumulator + value;
    });
  }

  Category get selectedCategory {
    return _selectedCategory;
  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys.map((id) {
      // Extended price for product line
      return getProductById(id).price * _productsInCart[id]!;
    }).fold(0, (accumulator, extendedPrice) {
      return accumulator + extendedPrice;
    });
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (accumulator, itemCount) {
          return accumulator + itemCount;
        });
  }

  // Sales tax for the items in the cart
  double get tax {
    return subtotalCost * _salesTaxRate;
  }

  // Total cost to order everything in the cart.
  double get totalCost {
    return subtotalCost + shippingCost + tax;
  }

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_selectedCategory == Category.all) {
      return List.from(_availableProducts);
    } else {
      return _availableProducts.where((p) {
        return p.category == _selectedCategory;
      }).toList();
    }
  }

  // Search the product catalog
  List<Product> search(String searchTerms) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchTerms.toLowerCase());
    }).toList();
  }

  // Adds a product to the cart.
  void addProductToCart(String productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      _productsInCart[productId] = _productsInCart[productId]! + 1;
    }

    notifyListeners();
  }

  // Adds a product to favourites.
  void addProductToFavourites(String productId) {
    if (!_productsInFavourites.containsKey(productId)) {
      _productsInFavourites[productId] = 1;
    }

    notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(String productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        _productsInCart[productId] = _productsInCart[productId]! - 1;
      }
    }

    notifyListeners();
  }

// Removes an item from the favourites.
  void removeItemFromFavourites(String productId) {
    if (_productsInFavourites.containsKey(productId)) {
      if (_productsInFavourites[productId] == 1) {
        _productsInFavourites.remove(productId);
      }
    }

    notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(String id) {
    return _availableProducts.firstWhere((p) => p.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Removes everything from favourites.
  void clearFavourites() {
    _productsInCart.clear();
    notifyListeners();
  }

  // Loads the list of available products from the repo.

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    notifyListeners();
  }
}
