import 'package:http/http.dart' as http;
import 'dart:convert';

class FireBaseHandler {
  String baseUrl;
  FireBaseHandler({required this.baseUrl});

  Uri constructUrl(String documentName) {
    return Uri.parse('$baseUrl$documentName.json?auth=${getToken()}');
  }

  String getToken() {
    //TODO: to be implemented
    return " ";
  }

  Future<Map<String, dynamic>> get(String documentName) async {
    final url = constructUrl(documentName);
    try {
      var response = await http.get(url);
      var fetchedData = json.decode(response.body) as Map<String, dynamic>;
      return fetchedData;
    } catch (err) {
      // TODO: error handing
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
      String documentName, Map<String, dynamic> body) async {
    final url = constructUrl(documentName);
    try {
      var response = await http.post(url, body: json.encode(body));
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } catch (err) {
      // TODO: error handing
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(String documentName, String id) async {
    final url = constructUrl('$documentName/$id');
    try {
      var response = await http.delete(url);
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } catch (err) {
      // TODO: error handing
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
      String documentName, String id, Map<String, dynamic> body) async {
    final url = constructUrl('$documentName/$id');
    try {
      var response = await http.put(url, body: json.encode(body));
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } catch (err) {
      // TODO: error handing
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(
      String documentName, String id, Map<String, dynamic> body) async {
    final url = constructUrl('$documentName/$id');
    try {
      var response = await http.patch(url, body: json.encode(body));
      var responseData = json.decode(response.body) as Map<String, dynamic>;
      return responseData;
    } catch (err) {
      // TODO: error handing
      rethrow;
    }
  }
}
