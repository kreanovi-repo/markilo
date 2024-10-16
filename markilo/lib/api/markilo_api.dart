import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:markilo/services/data_service.dart';
import 'package:markilo/services/local_storage.dart';
import 'package:flutter/material.dart';

class MarkiloApi {
  static Dio dio = Dio();

  static void configureDio() {
    debugPrint(DataService.configuration!['baseUrl']!);
    dio.options.baseUrl = '${DataService.configuration!['baseUrl']!}/api/v1';
    dio.options.contentType = Headers.jsonContentType;
    final authorization = LocalStorage.prefs.getString('token') ?? '';
    dio.options.headers = {
      'Authorization': 'Bearer $authorization',
      "Access-Control-Allow-Origin": "*",
      "Vary": "Origin",
      "Access-Control-Allow-Headers":
          "X-Requested-With, Content-Type, X-Token-Auth, Authorization",
      "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
    };
  }

  static Future httpGet(String path) async {
    try {
      debugPrint(path);
      final response = await dio.get(path);
      return response;
    } on DioException catch (e) {
      debugPrint(e.response.toString().toString());
      throw (e.message.toString());
    }
  }

  static Future httpPost(String path, Map<String, dynamic>? data) async {
    debugPrint(path);
    try {
      final response = await dio.post(path, data: data);
      return response;
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      throw (e.message.toString());
    }
  }

  static Future httpPatch(String path, Map<String, dynamic>? data) async {
    debugPrint(path);
    try {
      final response = await dio.patch(path, data: data);
      return response;
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      throw (e.message.toString());
    }
  }

  static Future httpDelete(String path) async {
    try {
      debugPrint(path);
      final response = await dio.delete(path);
      return response;
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      throw (e.message.toString());
    }
  }

  static Future uploadFile(String path, Uint8List bytes) async {
    try {
      final file = base64Encode(bytes);
      final formData = FormData.fromMap({'file': file});
      final response = await dio.post(path, data: formData);
      return response;
    } on DioException catch (e) {
      debugPrint(e.response.toString());
      throw (e.message.toString());
    }
  }
}
