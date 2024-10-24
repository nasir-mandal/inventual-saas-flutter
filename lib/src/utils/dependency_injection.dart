import 'package:get/get.dart';
import 'package:inventual_saas/src/network/internet_connectivity_controller.dart';

class DependencyInjection {
  static void init() {
    Get.put<InternetConnectivityController>(InternetConnectivityController(),
        permanent: true);
  }
}
