import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;
  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.error != null) {
            return Center(
              child: Text(
                "An error occured",
              ),
            );
          } else {
            return Consumer<Orders>(
              builder: (ctx, data, child) => ListView.builder(
                itemCount: data.orders.length,
                itemBuilder: (ctx, i) => OrderItem(
                  data.orders[i],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
