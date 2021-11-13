import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/layout/home_layout/home_layout.dart';
import 'package:notes_app_with_provider/layout/home_layout/home_layout_provider.dart';
import 'package:notes_app_with_provider/modules/archive/archive_page_provider.dart';
import 'package:notes_app_with_provider/shared/local/data_provider.dart';
import 'package:notes_app_with_provider/modules/notes/notes_page_provider.dart';
import 'package:notes_app_with_provider/modules/single_note/single_note_provider.dart';
import 'package:notes_app_with_provider/shared/local/cache_helper.dart';
import 'package:notes_app_with_provider/shared/styles/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await NotesDataProvider.openDatabase();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Themes()),
        ChangeNotifierProvider(create: (context) => HomeLayoutProvider()),
        ChangeNotifierProvider(create: (context) => SingleNoteProvider()),
        ChangeNotifierProxyProvider2<SingleNoteProvider, HomeLayoutProvider, NotesPageProvider>(
          create: (context) => NotesPageProvider(),
          update: (context, singleNoteProvider, homeLayoutProvider, notesPageProvider) => (notesPageProvider ?? NotesPageProvider())
            ..isSearching = homeLayoutProvider.isSearching
            ..searchingText = homeLayoutProvider.searchingText
            ..getNoteModels(),
        ),
        ChangeNotifierProxyProvider<NotesPageProvider, ArchivePageProvider>(
          create: (context) => ArchivePageProvider(),
          update: (context, notesPageProvider, archivePageProvider) => (archivePageProvider ?? ArchivePageProvider())..getNoteModels(),
        ),
      ],
      child: Consumer<Themes>(
        builder: (context, themes, _) => MaterialApp(
          title: 'Notes App with Provider',
          theme: Themes.lightTheme,
          darkTheme: Themes.darkTheme,
          themeMode: themes.isDarkModeBool ? ThemeMode.dark : ThemeMode.light,
          home: const HomeLayout(),
        ),
      ),
    ),
  );
}
