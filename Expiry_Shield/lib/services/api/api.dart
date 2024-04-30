import 'dart:convert'; // For JSON encoding and decoding
import 'package:flutter/foundation.dart'; // For debugPrint
import '../../models/product_info.dart'; // For making HTTP requests
import 'package:http/http.dart' as http;

class Api {
  // 192.168.137.188
  static const baseUrl = "http://192.168.137.188:2000/api/";

  static addproduct(Map pdata) async {
    var url = Uri.parse("${baseUrl}add_product");
    try {
      final res = await http.post(url, body: pdata);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to get response");
      }
    } catch (e) {
      debugPrint(e.toString());
      print('Exception occurred: $e');
      debugPrint("Data Not Added");
    }
  }

  static getProduct({String? bNumber}) async {
    List<ProductInfo> products = [];
    print(bNumber);
    var url = Uri.parse("${baseUrl}get_product"); // :id
    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);
        if (data is List) {
          if (bNumber != null) {
            data = data.where((value) => value['pbNumber'] == bNumber);
          }

          for (var value in data) {
            print(value['pcategory']);
            print("🔴🔴🔴🔴🔴🔴🔴🔴");
            print("🔴🔴🔴🔴🔴🔴🔴🔴");
            print(bNumber);
            products.add(ProductInfo(
              id: value["_id"],
              bNumber: value['pbNumber'],
              name: value['pname'],
              category: value['pcategory'],
              quantity: value['pquantity'],
              price: value['pprice'],
              manufacture: value['pmanufacture'],
              expiry: value['pexpiry'],
              bestBefore: value['pbestBefore'],
            ));
          }
        }
        return products;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static updateProduct(id, body) async {
    var url = Uri.parse("${baseUrl}update/$id");
    final res = await http.patch(url, body: body);
    if (res.statusCode == 200) {
      print(jsonDecode(res.body));
    } else {
      print("Failed to Update product.");
    }
  }

  static deleteProduct(
      // id, List<ProductInfo> pdata, Function setStateCallback) async {
      id,
      List<ProductInfo> pdata,
      Function setStateCallback) async {
    var url = Uri.parse("${baseUrl}delete/$id");
    final res = await http.delete(url);
    if (res.statusCode == 200) {
      //204 statusCode
      int index = // Find the index of the product to be deleted
          pdata.indexWhere((product) => product.id == id.toString());
      if (index != -1) {
        pdata.removeAt(index);
        setStateCallback();
      }
      print(jsonDecode(res.body));
    } else {
      print("Failed to Delete product.");
    }
  }
}

// to check in thunder client remove the ip address and write localhost eg: localhost:2000/api/get_product
