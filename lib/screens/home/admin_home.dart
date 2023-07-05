import 'package:trattamento/constants/routes.dart';
import 'package:trattamento/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/screens/category_view/admin_category_view.dart';
import 'package:trattamento/screens/expiration_screen.dart';
import 'package:trattamento/screens/order_screen/order_list.dart';
import 'package:trattamento/screens/product_details/admin_product_view.dart';
import 'package:trattamento/screens/product_details/product_quantities.dart';
import 'package:trattamento/widgets/single_dash_item.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool isLoading = false;

  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    await appProvider.callBackFunction();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              crossAxisCount: 2,
              children: [
                SingleDashItem(
                  title: appProvider.getCategoriesList.length.toString(),
                  subtitle: "categories",
                  onPressed: () {
                    Routes.instance.push(
                      widget: const AdminCategoriesView(),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: appProvider.getProducts.length.toString(),
                  subtitle: "product",
                  onPressed: () {
                    Routes.instance.push(
                      widget: const AdminProductView(),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: "0".toString(),
                  subtitle: "Remaining Quantity",
                  onPressed: () {
                    Routes.instance.push(
                      widget: LowQuantityProductsScreen(),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: appProvider.getPendingOrderList.length.toString(),
                  subtitle: "Pending order",
                  onPressed: () {
                    Routes.instance.push(
                      widget: OrderList(
                        title: "Pending",
                        orderModelList: appProvider.getPendingOrderList,
                      ),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: appProvider.getCompleteOrderList.length.toString(),
                  subtitle: "completed order",
                  onPressed: () {
                    Routes.instance.push(
                      widget: OrderList(
                        title: "Completed",
                        orderModelList: appProvider.getCompleteOrderList,
                      ),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: appProvider.getCancelOrderList.length.toString(),
                  subtitle: "cancel order",
                  onPressed: () {
                    Routes.instance.push(
                      widget: OrderList(
                        title: "Cancel",
                        orderModelList: appProvider.getCancelOrderList,
                      ),
                      context: context,
                    );
                  },
                ),
                SingleDashItem(
                  title: "${appProvider.getTotalEarning} LE",
                  subtitle: "earning",
                  onPressed: () {},
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
