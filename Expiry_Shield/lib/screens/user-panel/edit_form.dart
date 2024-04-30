import 'package:flutter/material.dart';
import '../../models/product_info.dart';
import 'form.dart';

class EditForm extends StatefulWidget {
  final ProductInfo data;
  const EditForm({Key? key, required this.data}) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _bnumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();
  final _manufactureController = TextEditingController();
  final _expiryController = TextEditingController();
  final _bestBeforeController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _bnumberController.text = widget.data.bNumber.toString();
    _nameController.text = widget.data.name.toString();
    _categoryController.text = widget.data.category.toString();
    _quantityController.text = widget.data.quantity.toString();
    _manufactureController.text = widget.data.manufacture.toString();
    _expiryController.text = widget.data.expiry.toString();
    _bestBeforeController.text = widget.data.bestBefore.toString();
    _priceController.text = widget.data.price.toString();
    // print(widget.data.id);
    // print(widget.data.name);
    // print("❤️❤️❤️❤️❤️❤️❤️❤️");
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.id);
    // print("😥😥😥😥😥😥😥😥😥😥😥😥");
    return Scaffold(
      body: SafeArea(
        child: ProductForm(
          bnumberController: _bnumberController,
          nameController: _nameController,
          priceController: _priceController,
          quantityController: _quantityController,
          expiryController: _expiryController,
          manufactureController: _manufactureController,
          categoryController: _categoryController,
          bestBeforeController: _bestBeforeController,
          submitORupdate: "Update",
          data: widget.data,
        ),
      ),
    );
  }
}
