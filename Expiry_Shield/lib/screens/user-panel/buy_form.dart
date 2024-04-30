import 'package:flutter/material.dart';
import 'form.dart';

class BuyForm extends StatefulWidget {
  final String? scanResult;
  const BuyForm({Key? key, this.scanResult}) : super(key: key);
  @override
  State<BuyForm> createState() => _BuyFormState();
}

class _BuyFormState extends State<BuyForm> {
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _manufactureController = TextEditingController();
  final _expiryController = TextEditingController();
  final _bestBeforeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ProductForm(
          bnumberController: TextEditingController(text: widget.scanResult),
          nameController: _nameController,
          priceController: _priceController,
          quantityController: _quantityController,
          expiryController: _expiryController,
          manufactureController: _manufactureController,
          categoryController: _categoryController,
          bestBeforeController: _bestBeforeController,
          buyORsell: "Buy",
        ),
      ),
    );
  }
}
