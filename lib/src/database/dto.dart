// Data transfer object
import '../models/model.dart';

abstract class DTO {
  Map<String, dynamic> ModelToJson(Model m) {
    return Map();
  }
}
