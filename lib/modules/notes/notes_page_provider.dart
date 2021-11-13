import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/shared/local/repository.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class NotesPageProvider with ChangeNotifier {
  //
  bool isSearching = false;
  String searchingText = '';

  final noteModels = <NoteModel>[];
  void getNoteModels() async {
    noteModels.clear();
    if (!isSearching) {
      noteModels.addAll((await NotesRepository.query()).where((element) => !element.archived));
    } else {
      noteModels.addAll((await NotesRepository.query()).where((element) => !element.archived && element.title.contains(searchingText.trim())));
    }
    notifyListeners();
  }

  static Future<void> openDatabase() async {
    return await NotesRepository.openDatabase();
  }
}
