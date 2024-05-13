import 'dart:convert';
import 'package:flutter/services.dart';

class JsonParser {
  late Map<String, dynamic>? _data;

  Future<void> loadJsonData() async {
    try {
      String jsonString =
          await rootBundle.loadString('lib/resources/data.json');
      _data = json.decode(jsonString);

      if (_data == null) {
        throw Exception("No data loaded.");
      }
    } catch (e) {
      print("Error loading JSON data: $e");
      throw Exception("Failed to load JSON data");
    }
  }

  Map<String, dynamic>? getLevelItems(String difficulty, int level) {
    try {
      if (_data == null) {
        throw Exception("Data is not loaded yet.");
      }
      //print(_data?[difficulty]['level'][level.toString()]['object']);
      return Map<String, dynamic>.from(
          _data![difficulty]['level'][level.toString()]);
    } catch (e) {
      print("Error parsing data: $e");
      return null;
    }
  }
}
