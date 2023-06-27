import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trattamento/constants/constants.dart';
import 'package:trattamento/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:trattamento/models/order_model/order_model.dart';
import 'package:trattamento/provider/app_provider.dart';

class SingleOrderWidget extends StatefulWidget {
  final OrderModel orderModel;

  const SingleOrderWidget({Key? key, required this.orderModel})
      : super(key: key);

  @override
  _SingleOrderWidgetState createState() => _SingleOrderWidgetState();
}

class _SingleOrderWidgetState extends State<SingleOrderWidget> {
  bool isButtonVisible = true;

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              collapsedShape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.3,
                ),
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2.3,
                ),
              ),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                    child: Image.network(
                      widget.orderModel.products[0].image,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.orderModel.products[0].name,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        if (widget.orderModel.products.length > 1)
                          SizedBox.fromSize(),
                        if (widget.orderModel.products.length == 1)
                          Column(
                            children: [
                              Text(
                                "Quantity: ${widget.orderModel.products[0].qty.toString()}",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                            ],
                          ),
                        Text(
                          "Total Price: \LE${widget.orderModel.totalPrice.toString()}",
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          "Order Status: ${widget.orderModel.status}",
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                        if (isButtonVisible &&
                            widget.orderModel.status == "Pending")
                          CupertinoButton(
                            child: Container(
                              height: 40,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 141, 126),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Text(
                                "Accepted",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              await FirebaseFirestoreHelper.instance
                                  .updateOrder(widget.orderModel, "Delivery");
                              appProvider.getPendingOrderList
                                  .remove(widget.orderModel);
                              appProvider.updatePendingOrder(widget.orderModel);
                              setState(() {
                                isButtonVisible = false;
                              });
                              // TODO: Display a message or perform desired action
                              // Here you can display a snackbar, toast, or any other notification
                              // to inform the user about the status update.
                            },
                            padding: EdgeInsets.zero,
                          ),
                        if (isButtonVisible &&
                            (widget.orderModel.status == "Pending" ||
                                widget.orderModel.status == "Delivery"))
                          CupertinoButton(
                            child: Container(
                              height: 40,
                              width: 150,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 16, 141, 126),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Text(
                                "Cancel Order",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (widget.orderModel.status == "Pending") {
                                widget.orderModel.status = "Cancel";
                                await FirebaseFirestoreHelper.instance
                                    .updateOrder(widget.orderModel, "Cancel");
                                appProvider.updateCancelPendingOrder(
                                    widget.orderModel);
                              } else {
                                widget.orderModel.status = "Cancel";
                                await FirebaseFirestoreHelper.instance
                                    .updateOrder(widget.orderModel, "Cancel");
                                appProvider.updateCancelDeliveryOrder(
                                    widget.orderModel);
                              }
                              setState(() {});

                              // TODO: Perform any desired action
                              // Here you can perform any action when the order is canceled.
                            },
                            padding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              children: [
                if (widget.orderModel.products.length > 1)
                  const Text("Details"),
                if (widget.orderModel.products.length > 1)
                  Divider(color: Theme.of(context).primaryColor),
                ...widget.orderModel.products.map((singleProduct) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 6.0),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              child: Image.network(
                                singleProduct.image,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    singleProduct.name,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Quantity: ${singleProduct.qty.toString()}",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Price: ${singleProduct.price.toString()}\LE",
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Theme.of(context).primaryColor),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
