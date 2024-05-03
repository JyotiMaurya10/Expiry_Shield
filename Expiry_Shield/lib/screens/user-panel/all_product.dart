import 'package:flutter/material.dart';
import '../../models/product_info.dart';
import '../../services/api/api.dart';
import '../../widgets/confirmdialogbox_widget.dart';
import 'edit_form.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});
  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: const Text("All Products"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: Api.getProduct(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
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
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: pdata.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: const CircleAvatar(
                            backgroundColor: Colors.black,
                          ),
                          title: Text("${pdata[index].name}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Quantity: ${pdata[index].quantity}"),
                              const SizedBox(height: 5),
                              Text("Price: ${pdata[index].price}"),
                              const SizedBox(height: 5),
                              Text("Exp date: ${pdata[index].expiry}"),
                            ],
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmDialog(
                                            message:
                                                "Do you want to Delete the data?",
                                            onConfirm: () async {
                                              await Api.deleteProduct(
                                                  pdata[index].id, pdata, () {
                                                setState(() {});
                                              });
                                            },
                                          );
                                        });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.keyboard_arrow_right),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmDialog(
                                            message:
                                                "Do you want to Update the data?",
                                            onConfirm: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditForm(
                                                          data: pdata[index]),
                                                ),
                                              );
                                            },
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
