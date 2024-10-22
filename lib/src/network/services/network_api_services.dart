import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventual/src/network/app_expections.dart';
import 'package:inventual/src/network/services/base_api.dart';
import 'package:inventual/src/presentation/widgets/diolog_box.dart';
import 'package:inventual/src/utils/contstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkApiServices extends BaseApi {
  Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Map<String, String> _createHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<dynamic> getApi(String url) async {
    final String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token Not Found",
          backgroundColor: ColorSchema.primaryColor.withOpacity(0.5),
          colorText: ColorSchema.titleTextColor,
          animationDuration: const Duration(milliseconds: 800));
      return null;
    }

    final headers = _createHeaders(token);

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> getApiV2(String url) async {
    final String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token Not Found",
          backgroundColor: ColorSchema.primaryColor.withOpacity(0.5),
          colorText: ColorSchema.titleTextColor,
          animationDuration: const Duration(milliseconds: 800));
      return null;
    }

    final headers = _createHeaders(token);

    try {
      final response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));
      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  @override
  Future<dynamic> postApi(var data, String url, {String? token}) async {
    final String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token Not Found",
          backgroundColor: ColorSchema.primaryColor.withOpacity(0.5),
          colorText: ColorSchema.titleTextColor,
          animationDuration: const Duration(milliseconds: 800));
      return null;
    }

    final headers = _createHeaders(token);

    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> postApiV2(var data, String url) async {
    final String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token Not Found",
          backgroundColor: ColorSchema.primaryColor.withOpacity(0.5),
          colorText: ColorSchema.titleTextColor,
          animationDuration: const Duration(milliseconds: 800));
      return null;
    }

    final headers = _createHeaders(token);
    try {
      final response = await http
          .post(Uri.parse(url), headers: headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 10));
      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> deleteApiV2(String url) async {
    final String? token = await _getToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Token Not Found",
          backgroundColor: ColorSchema.primaryColor.withOpacity(0.5),
          colorText: ColorSchema.titleTextColor,
          animationDuration: const Duration(milliseconds: 800));
      return null;
    }

    final headers = _createHeaders(token);
    try {
      final response = await http
          .delete(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 10));

      return _returnResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> loginApi(
    var data,
    String url,
  ) async {
    try {
      final response = await http
          .post(Uri.parse(url), body: (data))
          .timeout(const Duration(seconds: 10));
      return _loginResponse(response);
    } on SocketException {
      throw InternetException();
    } on http.ClientException {
      throw InternetException();
    } on TimeoutException {
      throw RequestTimeOutException();
    } catch (e) {
      throw FetchDataException('An unexpected error occurred: $e');
    }
  }

  dynamic _loginResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw FetchDataException("Bad Request: ${response.body}");
      case 401:
        throw UnauthorisedException("Unauthorised : ${response.body}");
      case 403:
        throw UnauthorisedException("Forbidden: ${response.body}");
      case 404:
        throw FetchDataException("Not Found: ${response.body}");
      case 500:
        throw ServerException("Internal Server Error: ${response.body}");
      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw FetchDataException("Bad Request: ${response.body}");
      case 401:
        showDialog(
          context: Get.context!,
          builder: (context) => const CustomAlertDialog(
              title: "Unauthorized",
              subTitle:
                  "You are not authorized to access this resource. Please log in again!"),
        );
        break;
      case 403:
        throw UnauthorisedException("Forbidden: ${response.body}");
      case 404:
        throw FetchDataException("Not Found: ${response.body}");
      case 500:
        throw ServerException("Internal Server Error: ${response.body}");
      default:
        throw FetchDataException(
            'Error occurred while communicating with server: ${response.statusCode}');
    }
  }
}
