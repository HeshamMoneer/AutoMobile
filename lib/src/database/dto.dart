// Data transfer object
abstract class DTO {
  Map<String, dynamic> ModelToJson(Object model) {
    return Map();
  }

  Object? JsonToModel(Map<String, dynamic> json) {
    return null;
  }
}
