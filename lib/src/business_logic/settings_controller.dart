import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventual_saas/src/network/services/network_api_services.dart';
import 'package:inventual_saas/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final NetworkApiServices _apiServices = NetworkApiServices();
  final RxBool isLoading = false.obs;
  final RxBool notFound = true.obs;
  RxMap<String, dynamic> settings = <String, dynamic>{}.obs;
  void loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('settings');
    bool fetchSuccess = await fetchAllSettings();
    if (fetchSuccess) {
      jsonString = prefs.getString('settings');
      if (jsonString != null) {
        settings.value = jsonDecode(jsonString);
      }
    }
  }

  Future<bool> fetchAllSettings() async {
    try {
      isLoading.value = true;
      final url = "${await AppStrings.getBaseUrlV1()}settings/all";
      final jsonResponse = await _apiServices.getApiBeforeAuthentication(url);

      if (jsonResponse != null && jsonResponse["data"] != null) {
        final settingsData = jsonResponse["data"]["settings"];

        if (settingsData != null) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          // Extract and store relevant settings
          String copyright = settingsData["general"]["copyright"] ??
              'Copyright © 2024, Inventual. all rights reserved';
          String currencyName =
              settingsData["general"]["currency_name"] ?? 'USD';
          String currencySymbol =
              settingsData["general"]["currency_symbol"] ?? '\$';
          String siteUrl = settingsData["general"]["site_url"] ??
              'https://inventual.bdevs.net';
          String appName = settingsData["general"]["app_name"] ?? 'Inventual';
          String siteLogo = await AppStrings.getImageUrl(
              settingsData["general"]["site_logo"]);
          String adminLogo = await AppStrings.getImageUrl(
              settingsData["general"]["admin_logo"]);
          String favicon =
              await AppStrings.getImageUrl(settingsData["general"]["favicon"]);

          // Create a settings map to store in SharedPreferences
          Map<String, dynamic> settings = {
            "copyright": copyright,
            "currency_name": currencyName,
            "currency_symbol": currencySymbol,
            "site_url": siteUrl,
            "app_name": appName,
            "site_logo": siteLogo,
            "admin_logo": adminLogo,
            "favicon": favicon,
          };

          String settingsJson = jsonEncode(settings);
          await prefs.setString('settings', settingsJson);
          return true;
        }
      }
      return false; // Return false if settings data is not found
    } catch (e) {
      return false; // Return false if an exception occurs
    } finally {
      isLoading.value = false;
    }
  }
}
