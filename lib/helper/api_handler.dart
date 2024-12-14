import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class ApiHandler {
  Dio _dio = Dio();

  ApiHandler() {
    Map<String, String> headers = {};

    headers['Accept'] = 'application/json';
    headers['Access-Control-Allow-Origin'] = '*';
    headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS';
    headers['Access-Control-Allow-Headers'] = 'Content-Type';
    _dio = Dio(BaseOptions(
      headers: headers,
      contentType: 'application/json',
    ));
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var res = await _dio.get(url, queryParameters: queryParameters);
      debugPrint('================= GET =================');
      debugPrint("url : $url");
      debugPrint("query : $queryParameters");
      return res;
    } on DioException catch (e) {
      return _exeptionDio(url, e);
    }
  }

  Future<Response> post(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    try {
      log(url);
      // debugPrint(data);
      var res = await _dio.post(url, data: data);
      // debugPrint(res.data);
      debugPrint('================= POST =================');
      debugPrint("url : $url");
      debugPrint("data : $data");
      return res;
    } on DioException catch (e) {
      log(url);
      // print(e);
      return _exeptionDio(url, e);
    }
  }

  Future<Response> postFormData(
    String url, {
    dynamic data,
  }) async {
    try {
      log(url);
      debugPrint(url);
      var res = await _dio.post(url, data: data);

      // debugPrint(res.data);
      // debugPrint('================= POST =================');
      // debugPrint("url : $url");
      // debugPrint("data : $data");
      return res;
    } on DioException catch (e) {
      log(url);
      // print(e);
      return _exeptionDio(url, e);
    }
  }

  Future<Response> put(
    String url, {
    dynamic data,
  }) async {
    // debugPrint(data);
    try {
      var res = await _dio.put(url, data: data);
      // debugPrint('================= PUT =================');
      // debugPrint("url : $url");
      // debugPrint("data : $data");
      return res;
    } on DioException catch (e) {
      return _exeptionDio(url, e);
    }
  }

  Future<Response> delete(String url) async {
    try {
      var res = await _dio.delete(url);
      // debugPrint('================= DELETE =================');
      // debugPrint("url : $url");
      return res;
    } on DioException catch (e) {
      return _exeptionDio(url, e);
    }
  }

  _exeptionDio(String url, e) async {
    debugPrint("======================================");
    debugPrint("ERROR");
    try {
      debugPrint("statusCode : ${e.response.statusCode}");
      debugPrint("data : ${e.response.data}");
      debugPrint("url : $url");
      if (e.response.statusCode == 401) {
        Get.snackbar("Maaf!", e.response.data['message'],
            colorText: Colors.white,
            icon: const Icon(Icons.check, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
      } else {
        Get.snackbar("Maaf!", e.response.data['message'],
            colorText: Colors.white,
            icon: const Icon(Icons.check, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Maaf!", 'Terjadi kesalahan!',
          colorText: Colors.white,
          icon: const Icon(Icons.check, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red);
    }
    // debugPrint("======================================");
  }
}
