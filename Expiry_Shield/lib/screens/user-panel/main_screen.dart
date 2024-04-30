import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../../utils/app_constant.dart';
import '../../widgets/navbar_widget.dart';
import '../../widgets/categories_widget.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/drawer_widget.dart';
import 'buy_form.dart';
import 'sell_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppConstant.appMainColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppConstant.appTextColor),
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: AppConstant.appSecondaryColor,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: AppConstant.appMainColor,
          actions: const [
            Icon(Icons.access_alarm),
            SizedBox(width: 16),
          ],
        ),
        drawer: const DrawerWidget(),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Expiry Shield",
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Welcome, Everything is Fresh to eat",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.search),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 250,
                        child: const TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Search here...",
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomCard(
                            iconData: Icons.shopping_cart,
                            buttonText: "Buy",
                            //  By adding the if (mounted) check, you ensure that the navigation only occurs if the widget is still mounted and valid.
                            // This helps prevent potential issues related to using an invalid BuildContext.
                            // In Flutter, the mounted property of a State object indicates whether the stateful widget associated with that state is currently included in the widget tree.
                            // When you navigate to a new screen or perform any asynchronous operation that might complete after the widget has been removed
                            // (for example, if the user navigates back quickly), it's important to check if the widget is still mounted before performing any operations that rely on its context.
                            onPressed: () async {
                              String scannedResult = await scanBarcodeNormal();
                              if (scannedResult != "-1") {
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BuyForm(
                                        scanResult: scannedResult,
                                      ),
                                    ),
                                  );
                                } else {
                                  print(
                                      'Widget is not mounted. Cannot navigate.');
                                }
                              } else {
                                print(
                                    'Not navigating to next screen. scannedResult is -1.');
                              }
                            },
                          ),
                          CustomCard(
                            iconData: Icons.attach_money,
                            buttonText: 'Sell',
                            onPressed: () async {
                              String scannedResult = await scanBarcodeNormal();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SellForm(
                                      scanResult: scannedResult,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      const Categories(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                final date =
                                    DateTime.now().add(Duration(days: index));
                                final groceryName = 'Grocery ${index + 1}';
                                final expiryDate =
                                    date.add(const Duration(days: 7));
                                return Card(
                                  color: AppConstant.appMainColor,
                                  elevation: 4,
                                  child: ListTile(
                                    title: Text(
                                      'Date: ${date.toString()}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Grocery: $groceryName\nExpiry: ${expiryDate.toString()}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const Navbar());
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = "Failed to get platform version";
    }
    return barcodeScanRes;
  }
}
