import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../models/product_info.dart';
import '../../services/api/api.dart';
import '../../utils/app_constant.dart';
import '../../widgets/textformfield_widget.dart';
import '../../widgets/snackbar_widget.dart';
import 'qrcode_generator.dart';

class ProductForm extends StatefulWidget {
  final TextEditingController bnumberController;
  final TextEditingController nameController;
  final TextEditingController? categoryController;
  final TextEditingController quantityController;
  TextEditingController? soldQuantityController;
  final TextEditingController? manufactureController;
  final TextEditingController expiryController;
  final TextEditingController? bestBeforeController;
  final TextEditingController priceController;
  final String? submitORupdate; // Submit or Update
  final String? buyORsell; // Buy or Sell
  final ProductInfo? data;

  ProductForm({
    Key? key,
    required this.bnumberController,
    required this.nameController,
    required this.priceController,
    required this.quantityController,
    required this.expiryController,
    this.manufactureController,
    this.soldQuantityController,
    this.categoryController,
    this.bestBeforeController,
    this.submitORupdate = "Submit",
    this.buyORsell = "Buy",
    this.data,
  }) : super(key: key);
  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  late int quantityLeft;
  bool _isSnackbarVisible = false;
  final dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final bestBeforeFormatter =
      MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});
  DateTime date = DateTime.now();

  int daysInMonth(int month, int year) {
    if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29; // Leap year
      } else {
        return 28; // Non-leap year
      }
    } else if ([4, 6, 9, 11].contains(month)) {
      return 30;
    } else {
      return 31;
    }
  }

  DateTime calculatePreciseExpiryDate(
      DateTime manufactureDate, int bestBefore) {
    DateTime expiryDate = manufactureDate;
    for (int i = 0; i < bestBefore; i++) {
      expiryDate = expiryDate
          .add(Duration(days: daysInMonth(expiryDate.month, expiryDate.year)));
    }
    return expiryDate;
  }

  DateTime? _parseDate(String dateStr) {
    List<String> parts = dateStr.split('/');
    if (parts.length != 3) return null;
    int? day = int.tryParse(parts[0]);
    int? month = int.tryParse(parts[1]);
    int? year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  void calculateExpiryDate() {
    if (widget.manufactureController != null &&
        widget.manufactureController!.text.isNotEmpty &&
        widget.bestBeforeController != null &&
        widget.bestBeforeController!.text.isNotEmpty) {
      String manufactureDateString = widget.manufactureController!.text;
      DateTime? manufactureDate = _parseDate(manufactureDateString);
      if (manufactureDate != null) {
        int bestBefore = int.tryParse(widget.bestBeforeController!.text) ?? 0;
        DateTime expiryDate =
            calculatePreciseExpiryDate(manufactureDate, bestBefore);
        if (bestBefore <= 0) {
          widget.expiryController.text = 'Invalid Month';
          return;
        }
        if (expiryDate.isBefore(manufactureDate)) {
          widget.expiryController.text = 'Expired';
        } else {
          widget.expiryController.text =
              DateFormat('dd/MM/yyyy').format(expiryDate);
        }
      } else {
        widget.expiryController.text = 'Invalid Date';
      }
    }
  }

  // the initState and dispose methods are used in a Flutter StatefulWidget to manage the lifecycle of the widget's state and its associated resources
  @override
  void initState() {
    super.initState();
    // Add listeners to the controllers for changes
    widget.manufactureController?.addListener(calculateExpiryDate);
    widget.bestBeforeController?.addListener(calculateExpiryDate);
    widget.soldQuantityController = TextEditingController(text: "");
    calculateQuantityLeft();
    widget.quantityController.addListener(calculateQuantityLeft);
    widget.soldQuantityController?.addListener(calculateQuantityLeft);

    widget.manufactureController?.addListener(() {
      setState(() {
        // This triggers the build method to update the UI with the masked text
      });
    });
  }

  void calculateQuantityLeft() {
    int quantity = int.tryParse(widget.quantityController.text) ?? 0;
    int soldQuantity =
        int.tryParse(widget.soldQuantityController?.text ?? "0") ?? 0;
    int newQuantityLeft = quantity - soldQuantity;

    if (newQuantityLeft < 0) {
      widget.soldQuantityController?.text = ("");
      if (_isSnackbarVisible == false) {
        showSnackbar(context, "Insufficient Quantity: $soldQuantity ");
        _isSnackbarVisible = true;
        Future.delayed(const Duration(seconds: 3), () {
          _isSnackbarVisible = false;
        });
      }
      setState(() {
        quantityLeft = quantity;
      });
    } else {
      setState(() {
        quantityLeft = quantity - soldQuantity;
      });
    }
  }

  // This method is called when the StatefulWidget is removed from the widget tree permanently.
  @override
  void dispose() {
    widget.manufactureController?.removeListener(calculateExpiryDate);
    widget.bestBeforeController?.removeListener(calculateExpiryDate);
    widget.manufactureController?.dispose();
    widget.bestBeforeController?.dispose();
    super.dispose();
  }

  Future<void> _selectDate(controller) async {
    DateTime? newDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (newDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(newDate);
    }
  }

  bool _isButtonEnabled() {
    // all part required
    return widget.bnumberController.text.isNotEmpty &&
        widget.nameController.text.isNotEmpty &&
        widget.quantityController.text.isNotEmpty &&
        widget.expiryController.text.isNotEmpty &&
        widget.priceController.text.isNotEmpty;
  }

  bool _submitForm(BuildContext context) {
    if (_isButtonEnabled()) {
      showSnackbar(context, "Form submitted successfully!");
      return true;
    } else {
      if (!_isSnackbarVisible) {
        showSnackbar(context, "Please fill in all required fields!");
        _isSnackbarVisible = true;
        Future.delayed(const Duration(seconds: 3), () {
          _isSnackbarVisible = false;
        });
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print("✔️✔️✔️✔️✔️✔️✔️✔️✔️");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save_alt_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppConstant.appMainColor,
      ),
      backgroundColor: AppConstant.appTextColor,
      body: SafeArea(
          child: Stack(
        alignment: Alignment.center,
        children: [
          background(context),
          SingleChildScrollView(
            reverse: true,
            child: Column(children: [
              mainContainer(),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (quantityLeft.toString() ==
                      widget.quantityController.text.toString()) {
                    if (!_isSnackbarVisible) {
                      showSnackbar(
                          context, "Please fill in all required fields!");
                      _isSnackbarVisible = true;
                      Future.delayed(const Duration(seconds: 3), () {
                        _isSnackbarVisible = false;
                      });
                    }
                  }
                  if (widget.submitORupdate == "Update" ||
                      (widget.buyORsell == "Sell" &&
                          quantityLeft.toString() !=
                              widget.quantityController.text.toString())) {
                    Api.updateProduct(widget.data!.id, {
                      "pbNumber": widget.bnumberController.text,
                      "pname": widget.nameController.text,
                      "pcategory": widget.categoryController?.text ?? " ",
                      "pprice": widget.priceController.text,
                      "pquantity": widget.buyORsell == "Sell"
                          ? quantityLeft.toString()
                          : widget.quantityController.text.toString(),
                      "pmanufacture": widget.manufactureController?.text ?? " ",
                      "pexpiry": widget.expiryController.text,
                      "pbestBefore": widget.bestBeforeController?.text ?? " ",
                      'id': widget.data!.id,
                    });
                    if (widget.buyORsell == "Sell") {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => QRcodeGenerator(
                                bNumber: widget.bnumberController.text,
                                name: widget.nameController.text,
                                price: widget.priceController.text,
                                expiry: widget.expiryController.text,
                              )));
                    }
                    if (widget.submitORupdate == "Update") {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                    showSnackbar(context, "Form Updated Successfully!");
                  } else if (widget.submitORupdate == "Submit" &&
                      widget.buyORsell != "Sell") {
                    bool proceed = _submitForm(context);
                    if (proceed) {
                      var data = {
                        "pbNumber": widget.bnumberController.text,
                        "pname": widget.nameController.text,
                        "pcategory": widget.categoryController?.text,
                        "pprice": widget.priceController.text,
                        "pquantity": widget.quantityController.text,
                        "pmanufacture": widget.manufactureController?.text,
                        "pexpiry": widget.expiryController.text,
                        "pbestBefore": widget.bestBeforeController?.text,
                      };
                      Api.addproduct(data); // pass to our method
                      Navigator.of(context).pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  elevation: 4,
                ),
                child: Text(
                  widget.submitORupdate ?? "Submit",
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      )),
    );
  }

  Container mainContainer() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 340),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      width: 340,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            FractionallySizedBox(
              widthFactor: 0.90,
              child: Column(
                children: [
                  CustomTextFormField(
                    controller: widget.bnumberController,
                    labelText: 'Barcode Number',
                    keyboardType: TextInputType.number,
                    enabled: widget.buyORsell == "Sell" ? false : true,
                  ),
                  CustomTextFormField(
                    controller: widget.nameController,
                    labelText: 'Name',
                    keyboardType: TextInputType.text,
                    enabled: widget.buyORsell == "Sell" ? false : true,
                  ),
                  CustomTextFormField(
                      controller:
                          widget.categoryController ?? TextEditingController(),
                      labelText: 'Category (optional)',
                      keyboardType: TextInputType.text,
                      visible: widget.buyORsell == "Sell" ? false : true),
                  if (widget.buyORsell != "Sell")
                    Row(children: [
                      Expanded(
                        flex: 1,
                        child: CustomTextFormField(
                          controller: widget.priceController,
                          labelText: 'Price',
                          keyboardType: TextInputType.datetime,
                          enabled: widget.buyORsell == "Sell" ? false : true,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                          flex: 1,
                          child: CustomTextFormField(
                            controller: widget.buyORsell == "Sell"
                                ? widget.soldQuantityController!
                                : widget.quantityController,
                            labelText: widget.buyORsell == "Sell"
                                ? 'Quantity Sold'
                                : 'Quantity',
                            keyboardType: TextInputType.datetime,
                          ))
                    ]),
                  if (widget.buyORsell == "Sell")
                    CustomTextFormField(
                      controller: widget.priceController,
                      labelText: 'Price',
                      keyboardType: TextInputType.datetime,
                      enabled: widget.buyORsell == "Sell" ? false : true,
                    ),
                  if (widget.buyORsell == "Sell")
                    CustomTextFormField(
                      controller: widget.buyORsell == "Sell"
                          ? widget.soldQuantityController!
                          : widget.quantityController,
                      labelText: widget.buyORsell == "Sell"
                          ? 'Quantity Sold'
                          : 'Quantity',
                      keyboardType: TextInputType.datetime,
                    ),
                  CustomTextFormField(
                      controller: widget.manufactureController ??
                          TextEditingController(),
                      labelText: 'Manufacture Date',
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [dateFormatter],
                      visible: widget.buyORsell == "Sell" ? false : true,
                      onChanged: (value) => calculateExpiryDate(),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _selectDate(widget.manufactureController);
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: AppConstant.appMainColor,
                            size: 30,
                          ))),
                  CustomTextFormField(
                      controller: widget.expiryController,
                      labelText: 'Expiry Date (DD/MM/YYYY)',
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [dateFormatter],
                      visible: widget.buyORsell == "Sell" ? false : true,
                      suffixIcon: IconButton(
                          onPressed: () {
                            _selectDate(widget.expiryController);
                          },
                          icon: const Icon(
                            Icons.calendar_month,
                            color: AppConstant.appMainColor,
                            size: 33,
                          ))),
                  CustomTextFormField(
                      controller: widget.bestBeforeController ??
                          TextEditingController(),
                      labelText: 'Best Before _ Months (optional)',
                      keyboardType: TextInputType.datetime,
                      visible: widget.buyORsell == "Sell" ? false : true,
                      inputFormatters: [bestBeforeFormatter],
                      onChanged: (value) => calculateExpiryDate()),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                        visible: widget.buyORsell == "Sell" ? true : false,
                        child: Text(
                            "Total Quantity: ${widget.quantityController.text} ",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ))),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Visibility(
                      visible: widget.buyORsell == "Sell" ? true : false,
                      child: Text(
                        "Quantity Left:  $quantityLeft",
                        style:
                            const TextStyle(color: Colors.black, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column background(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: const BoxDecoration(
            color: AppConstant.appMainColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        )
      ],
    );
  }
}
