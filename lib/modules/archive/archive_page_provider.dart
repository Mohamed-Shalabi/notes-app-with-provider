import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/shared/local/repository.dart';

class ArchivePageProvider with ChangeNotifier {
  //
  final noteModels = <NoteModel>[];
  void getNoteModels() async {
    noteModels.clear();
    noteModels.addAll((await NotesRepository.query()).where((element) => element.archived));
    notifyListeners();
  }
}
