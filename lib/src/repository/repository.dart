import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/firebasehandler.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  late String baseUrl;
  late String documentName;
  late FireBaseHandler fireBaseHandler;
  late DTO dto;
  Repository(String baseUrl, String documentName) {
    this.baseUrl = baseUrl;
    this.documentName = documentName;
    this.fireBaseHandler = FireBaseHandler(baseUrl: baseUrl);
  }

  Future<Map<String, dynamic>> get() async {
    return fireBaseHandler.get(documentName);
  }

  Future<Map<String, dynamic>> post(Object model) async {
    var body = dto.ModelToJson(model);
    return fireBaseHandler.post(documentName, body);
  }

  Future<Map<String, dynamic>> delete(String id) async {
    return fireBaseHandler.delete(documentName, id);
  }

  Future<Map<String, dynamic>> put(String id, Object model) async {
    var body = dto.ModelToJson(model);
    return fireBaseHandler.put(documentName, id, body);
  }

  Future<Map<String, dynamic>> patch(String id, Object model) async {
    var body = dto.ModelToJson(model);
    return fireBaseHandler.patch(documentName, id, body);
  }
}
