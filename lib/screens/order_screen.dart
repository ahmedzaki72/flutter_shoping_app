import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../providers/order.dart' show Orders;
import '../widgets/order_item.dart';

// class OrderScreen extends StatefulWidget {
//   static const String routeName = 'order_screen';
//
//   @override
//   _OrderScreenState createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     /// if i adding listen false i will not need adding Future.delayed
//     // Future.delayed(Duration.zero).then((_) async {
//     //   setState(() {
//     //     _isLoading = true;
//     //   });
//     //  await Provider.of<Orders>(context, listen: false).fetchSetOrder();
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     // });
//     /// i can using this code if i adding listen false
//     _isLoading = true;
//     Provider.of<Orders>(context, listen: false).fetchSetOrder().then((_) {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final orderData = Provider.of<Orders>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Your Orders'),
//       ),
//       drawer: AppDrawer(),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : ListView.builder(
//               itemCount: orderData.order.length,
//               itemBuilder: (ctx, index) => OrderItem(
//                 orderData.order[index],
//               ),
//             ),
//     );
  // }
// }
//

/// i will using stateless and not using initState but i will using FutureBuilder widget and improve code

class OrderScreen extends StatelessWidget {
  static const String routeName = 'order_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
           future: Provider.of<Orders>(context, listen: false).fetchSetOrder(),
          builder: (ctx, dataSnapshot){
            if(dataSnapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              if(dataSnapshot.error != null ){
                return Center(child: Text('An error occured'),);
              }else {
               return Consumer<Orders>(
                  builder: (ctx, orderData ,child) => ListView.builder(
                    itemCount: orderData.order.length,
                    itemBuilder: (ctx, index) => OrderItem(
                      orderData.order[index],
                    ),
                  ),
               );
              }
            }

      })
    );
  }
}



