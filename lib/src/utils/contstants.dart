import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorSchema {
  static const Color primaryColor = Color(0xFF4636ff);
  static const Color secondaryColor = Color(0xFFff49ec);
  static const Color titleTextColor = Color(0xFF353537);
  static const Color subTitleTextColor = Color(0xFFADADB1);
  static const Color light = Color(0xFFFFFFFF);
  static const Color borderColor = Color(0xFFE2E4E7);
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color lightBlack = Colors.black87;
  static const Color lightGray = Color(0xFFF8FAFF);
  static const Color borderLightBlue = Color(0xFFC1D5FE);
  static const Color grey = Colors.grey;
  static const Color danger = Color(0xFFF30445);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white54 = Colors.white54;
  static const Color white60 = Colors.white60;
  static const Color white38 = Colors.white38;
  static const Color success = Color(0xFF16AB40);
  static const Color warning = Color(0xffFC9F00);
  static const Color blue = Colors.blue;
  static const Color purple = Colors.purple;
  static const Color teal = Colors.teal;
  static const Color green = Colors.green;
  static const Color orange = Colors.orange;
  static const Color amber = Colors.amber;
  static const Color cyan = Colors.cyan;
  static const Color pink = Colors.pink;
  static const Color brown = Colors.brown;
  static const Color indigo = Colors.indigo;
  static const Color lime = Colors.lime;
  static const Color blueGrey = Colors.blueGrey;
  static const Color deepOrangeAccent = Colors.deepOrangeAccent;
  static const Color lightBlueAccent = Colors.lightBlueAccent;
  static const Color analyticsColor1 = Color(0xFFFFA641);
  static const Color analyticsColor2 = Color(0xFF44DF9D);
  static const Color analyticsColor3 = Color(0xFF4A80E9);
  static const Color profileColor1 = Color(0xFF4D7CEB);
  static const Color splashColor1 = Color(0xFF005C97);
  static const Color splashColor2 = Color(0xFF363795);
  static const Color actionColor = Color(0xFF696AE9);
  static const Color paymentColor = Color(0xFF950FF6);
}

class AppStrings {
  static const appName = "Inventual Flutter Laravel";
  static const defaultBaseUrlV1 = "https://inventual.app/api/v1/";
  static const baseImgURL = "https://inventual.bdevs.net/storage/";
  static Future<String> getBaseUrlV1() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? supplierKey = prefs.getString("supplier_key");
    if (supplierKey == null || supplierKey.isEmpty) {
      return defaultBaseUrlV1;
    }
    return "https://$supplierKey.inventual.app/api/v1/";
  }
}
