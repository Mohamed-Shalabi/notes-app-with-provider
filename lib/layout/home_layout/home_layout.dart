import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/layout/home_layout/home_layout_provider.dart';
import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/modules/single_note/single_note_screen.dart';
import 'package:notes_app_with_provider/shared/styles/themes.dart';
import 'package:provider/provider.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<HomeLayoutProvider, Themes>(
      builder: (context, homeLayoutProvider, themes, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return WillPopScope(
          onWillPop: () async {
            if (homeLayoutProvider.isSearching) {
              homeLayoutProvider.isSearching = false;
            }
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Notes App', style: textTheme.headline6?.copyWith(color: colorScheme.onSurface)),
              leading: IconButton(
                  onPressed: () {
                    themes.isDarkModeBool = !themes.isDarkModeBool;
                  },
                  icon: Icon(Icons.brightness_4_outlined, color: Theme.of(context).colorScheme.onSurface)),
              actions: [
                if (homeLayoutProvider.selectedIndex == 0 && !homeLayoutProvider.isSearching)
                  IconButton(
                    icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {
                      homeLayoutProvider.isSearching = true;
                    },
                  ),
                if (homeLayoutProvider.selectedIndex == 0 && homeLayoutProvider.isSearching)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.33,
                      child: TextField(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        onChanged: (value) {
                          homeLayoutProvider.search(value);
                        },
                      ),
                    ),
                  )
              ],
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SingleNoteScreen(
                      NoteModel(id: -1, creationTime: DateTime.now(), modificationTime: DateTime.now()),
                      isNewNote: true,
                    ),
                  ),
                );
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              elevation: 0,
              child: Container(
                height: 56,
                color: colorScheme.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.event_note, color: homeLayoutProvider.selectedIndex == 0 ? colorScheme.secondary : colorScheme.onSurface),
                      onPressed: () {
                        homeLayoutProvider.selectedIndex = 0;
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.archive, size: 28, color: homeLayoutProvider.selectedIndex == 1 ? colorScheme.secondary : colorScheme.onSurface),
                      onPressed: () {
                        homeLayoutProvider.selectedIndex = 1;
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: homeLayoutProvider.pages[homeLayoutProvider.selectedIndex],
          ),
        );
      },
    );
  }
}
