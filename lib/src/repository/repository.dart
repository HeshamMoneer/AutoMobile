import 'package:AutoMobile/src/database/dto.dart';
import 'package:AutoMobile/src/database/firebasehandler.dart';
import 'package:AutoMobile/src/models/user.dart';

class Repository {
  late FireBaseHandler fireBaseHandler;
  Repository() {
    this.fireBaseHandler = FireBaseHandler();
  }

  Future<List<Map<String, dynamic>>> getAll(String collectionName) async {
    return fireBaseHandler.getAll(collectionName);
  }

  Future<Map<String, dynamic>> get(String collectionName, String id) async {
    return fireBaseHandler.getById(collectionName, id);
  }

  Future<String> post(String collectionName, Object model, DTO dto) async {
    var user = model as User;
    var body = dto.ModelToJson(model);
    return fireBaseHandler.post(collectionName, body);
  }

  Future<void> delete(String collectionName, String id, DTO dto) async {
    fireBaseHandler.delete(collectionName, id);
  }

  Future<void> patch(
      String collectionName, String id, Object model, DTO dto) async {
    var body = dto.ModelToJson(model);
    fireBaseHandler.patch(collectionName, id, body);
  }
}
