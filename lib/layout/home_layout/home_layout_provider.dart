import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/modules/archive/archive_page.dart';
import 'package:notes_app_with_provider/modules/notes/notes_page.dart';
import 'package:notes_app_with_provider/modules/notes/notes_page_provider.dart';

class HomeLayoutProvider with ChangeNotifier {
  //
  HomeLayoutProvider();

  var _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  bool _isSearching = false;
  bool get isSearching => _isSearching;
  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  final pages = <Widget>[NotesPage(), ArchivePage()];

  var searchingText = '';
  void search(String s) {
    searchingText = s;
    notifyListeners();
  }
}
