import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_constant.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final void Function(String?)? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final String? initialValue;
  final bool visible;
  final bool? enabled;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.inputFormatters,
    this.suffixIcon,
    this.initialValue,
    this.enabled,
    this.visible = true,
  });

  @override
  Widget build(BuildContext context) {
    // Set the initial value of the controller
    if (initialValue != null) {
      controller.text = initialValue!;
    }

    return Visibility(
      visible: visible,
      child: Column(
        children: [
          TextFormField(
            controller: controller,
            cursorColor: AppConstant.appMainColor,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: const TextStyle(
                color: Colors.black87,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(fontSize: 20),
            keyboardType: keyboardType,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            enabled: enabled,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
