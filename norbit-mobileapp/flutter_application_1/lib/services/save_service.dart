import 'dart:io';
import 'package:amplify_core/amplify_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class SaveService {
  Future<void> saveStringToFile(String text) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');

    try {
      await file.writeAsString(text);
      print('String saved to file successfully');
    } catch (e) {
      print('Error saving string to file: $e');
    }
  }
  Future<String> readStringFromFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/my_file.txt');

    if (await file.exists()) {
      String fileContent = await file.readAsString();
      safePrint(fileContent);
      return fileContent;
    } else {
      return 'File not found';
    }
  }

}
