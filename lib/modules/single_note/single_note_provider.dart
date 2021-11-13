import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/shared/local/repository.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';
import 'package:notes_app_with_provider/shared/local/cache_helper.dart';

class SingleNoteProvider with ChangeNotifier {
  //
  bool _hasEdited = false;
  bool get hasEdited => _hasEdited;
  set hasEdited(value) {
    _hasEdited = value;
    notifyListeners();
  }

  bool _isEditing = false;
  bool get isEditing => _isEditing;
  set isEditing(value) {
    _isEditing = value;
    notifyListeners();
  }

  String title = '';
  String text = '';

  var _color = Colors.yellow;
  MaterialColor get color => _color;
  set color(value) {
    _color = value;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  List<String> getSearchedText(String pattern) {
    final splittedList = text.split(pattern);
    final outputList = <String>[];
    for (final element in splittedList) {
      outputList
        ..add(element)
        ..add(pattern);
    }
    if (!text.endsWith(pattern)) {
      outputList.removeLast();
    }
    return outputList;
  }

  void init(NoteModel note) {
    title = note.title;
    text = note.text;
    _color = note.color;
    notifyListeners();
  }

  void toggleIsEditing() {
    isEditing = !isEditing;
    notifyListeners();
  }

  Future<int> insertNoteToDatabase(NoteModel note) async {
    reloadNote(note);
    note.creationTime = DateTime.now();
    final id = await NotesRepository.insert(note);
    notifyListeners();
    return id;
  }

  void updateNote(NoteModel note) {
    reloadNote(note);
    NotesRepository.updateColor(note, colors.indexOf(note.color));
    NotesRepository.updateTitle(note, note.title);
    NotesRepository.updateText(note, note.text);
    notifyListeners();
  }

  void updateCompleted(NoteModel note) {
    NotesRepository.updateCompleted(note);
    notifyListeners();
  }

  bool updateLocked(NoteModel note) {
    final String password = CacheHelper.getData(key: SharedPreferencesKeys.passwordKey) ?? '';
    if (password.isEmpty) {
      return false;
    }
    NotesRepository.updateLocked(note);
    notifyListeners();
    return true;
  }

  void updateArchived(NoteModel note) {
    NotesRepository.updateArchived(note);
    notifyListeners();
  }

  void delete(NoteModel note) {
    NotesRepository.delete(note);
    notifyListeners();
  }

  void reloadNote(NoteModel note) {
    note.text = text;
    note.title = title;
    note.color = color;
    note.modificationTime = DateTime.now();
  }

  void setPassword(String password) {
    NotesRepository.setPassword(password);
  }
}
