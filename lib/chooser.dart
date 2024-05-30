import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;

const String filePath = "assets/data/";
const List<String> celebrityFiles = ['Actors', 'Athletes', 'Artists'];
const String category = 'celebrities';

Future<List<String>> getLines(String fileName) async {
  try {
    final fileContent = await rootBundle
        .loadString('$filePath$category/${fileName.toLowerCase()}.txt');
    final lines = fileContent.split('\n');
    return lines;
  } catch (e) {
    return [];
  }
}

List<String> getCelebrityFiles() {
  return celebrityFiles;
}
