import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:screenshot/screenshot.dart';
import '../../utils/app_constant.dart';
import '../../widgets/textformfield_widget.dart';

class QRcodeGenerator extends StatelessWidget {
  final String bNumber;
  final String name;
  final String price;
  final String expiry;

  const QRcodeGenerator(
      {super.key,
      required this.bNumber,
      required this.expiry,
      required this.name,
      required this.price});

  @override
  Widget build(BuildContext context) {
    final customerController = TextEditingController();
    String data =
        "Name: $name / Price: $price / Expiry: $expiry / Barcode number:$bNumber";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appMainColor,
        title: const Text(
          "Expiry Shield",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Invoice",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CustomTextFormField(
                controller: customerController,
                labelText: "Customer Name",
                keyboardType: TextInputType.text,
                visible: true,
              ),
            ),
            const SizedBox(height: 15),
            QrImageView(
              data: data,
              version: QrVersions.auto,
              gapless: false,
              size: 320,
            ),
            const SizedBox(height: 20),
            const Text("Scan the QR Code"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                // This will unfocus any focused text fields
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child:
                  const Text("Done !!", style: TextStyle(color: Colors.black)),
            ),
          ],
        )),
      ),
    );
  }
}
