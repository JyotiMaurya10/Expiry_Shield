import 'package:flutter/material.dart';
import '../../models/product_info.dart';
import '../../services/api/api.dart';
import 'form.dart';

class SellForm extends StatefulWidget {
  final String? scanResult;
  const SellForm({Key? key, this.scanResult}) : super(key: key);
  @override
  State<SellForm> createState() => _SellFormState();
}

class _SellFormState extends State<SellForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Api.getProduct(bNumber: widget.scanResult),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print("🔴🔴🔴🔴🔴 Data received: ${snapshot.hasData}");
            print(snapshot.data);
            print("🔴🔴🔴🔴🔴🔴🔴🔴");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('No data available'),
              );
            } else {
              List<ProductInfo> pdata = snapshot.data;
              if (!snapshot.hasData || snapshot.data == null || pdata.isEmpty) {
                // Navigator.of(context).pop();
                //  return _showAddDataDialog(context);
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "No data found for the provided barcode number.",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Go Back'),
                    )
                  ],
                ));
                // showCustomSnackbar(context, "Please Add the data first");
                // return _buildNoDataWidget(context);
              } else {
                int index = 0;
                // print("Name: ${pdata[index].name}");
                // print("Quantity: ${pdata[index].quantity}");
                // print("Price: ${pdata[index].price}");
                // print("Exp date: ${pdata[index].id}");
                // print("❤️❤️❤️❤️❤️❤️❤️");

                return SafeArea(
                  child: ProductForm(
                    bnumberController:
                        TextEditingController(text: widget.scanResult),
                    nameController:
                        TextEditingController(text: pdata[index].name),
                    priceController:
                        TextEditingController(text: pdata[index].price),
                    quantityController:
                        TextEditingController(text: pdata[index].quantity),
                    expiryController:
                        TextEditingController(text: pdata[index].expiry),
                    buyORsell: "Sell",
                    data : pdata[index],
                  ),
                );
              }
            }
          }),
    );
  }
}

Widget _buildNoDataWidget(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'No data available',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showAddDataDialog(context);
          },
          child: const Text('Add Data'),
        ),
      ],
    ),
  );
}

Future<void> _showAddDataDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Add Data'),
        content: const Text('You need to add data first.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
