import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventual/src/routes/app_routes.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Inventual",
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.pages,
    );
  }
}
