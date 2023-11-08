import 'dart:io';
import 'package:amplify_core/amplify_core.dart';
import 'package:path_provider/path_provider.dart';

/*
SaveService has to methods, reading and writing to file in the users phone.
This is used to write and read necessary credentials and device name.
 */

class SaveService {
  Future<void> saveStringToFile(String text, String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');

    try {
      await file.writeAsString(text);
      safePrint('String saved to file successfully');
    } catch (e) {
      safePrint('Error saving string to file: $e');
    }
  }

  Future<String?> readStringFromFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    if (await file.exists()) {
      String fileContent = await file.readAsString();
      return fileContent;
    } else {
      return null;
    }
  }
}
