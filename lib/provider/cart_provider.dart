import 'package:flutter/foundation.dart';
import 'package:pancake_resto/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  final List<CartModel> _cart = [];
  List<CartModel> get cart => _cart;
  late int _total = 0;
  int get total => _total;

  void addRemoveCart(String name, int menuId, bool isAdd) {
    if (_cart.where((element) => menuId == element.menuId).isEmpty) {
      _cart.add(CartModel(menuId: menuId, quantity: 1, name: name));
      _total++;
    } else {
      var index = _cart.indexWhere((element) => element.menuId == menuId);
      _cart[index].quantity = isAdd
          ? _cart[index].quantity + 1
          : _cart[index].quantity > 0
              ? _cart[index].quantity - 1
              : 0;

      _total = isAdd
          ? _total + 1
          : _total > 0
              ? _total - 1
              : 0;
    }
    notifyListeners();
  }
}
