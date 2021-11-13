import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_provider/modules/archive/archive_page_provider.dart';
import 'package:notes_app_with_provider/modules/single_note/single_note_screen.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';
import 'package:notes_app_with_provider/shared/local/cache_helper.dart';
import 'package:notes_app_with_provider/shared/styles/themes.dart';
import 'package:provider/provider.dart';

class ArchivePage extends StatelessWidget {
  ArchivePage({Key? key}) : super(key: key);

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArchivePageProvider>(
      builder: (context, archivePageProvider, _) => archivePageProvider.noteModels.isEmpty
          ? Center(child: Text('no notes yet', style: TextStyles.subHeadingStyle))
          : ListView(
              children: List.generate(
                archivePageProvider.noteModels.length,
                (index) {
                  final note = archivePageProvider.noteModels[index];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        if (note.locked) {
                          showDialog(
                            context: context,
                            builder: (context) => Builder(builder: (context) {
                              return Dialog(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(height: 24),
                                      Text('Enter password', style: TextStyles.titleStyle),
                                      TextField(
                                        controller: passwordController,
                                        obscureText: true,
                                      ),
                                      Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              final isPasswordCorrect =
                                                  passwordController.text.trim() == CacheHelper.getData(key: SharedPreferencesKeys.passwordKey);
                                              if (isPasswordCorrect) {
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SingleNoteScreen(note)));
                                                passwordController.clear();
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('incorrect password')));
                                              }
                                            },
                                            child: const Text('OK'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('cancel'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SingleNoteScreen(note)));
                        }
                      },
                      child: Container(
                        color: note.color.shade100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 64,
                                padding: const EdgeInsetsDirectional.only(start: 4.0),
                                child: Row(
                                  children: [
                                    Text(DateFormat('d MMMM').format(note.modificationTime), style: TextStyles.bodyStyle.copyWith(color: Colors.black)),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                                    Expanded(
                                      child: Text(
                                        note.title,
                                        style: TextStyles.subHeadingStyle.copyWith(
                                          decoration: note.completed ? TextDecoration.lineThrough : TextDecoration.none,
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (note.locked) const Icon(Icons.lock),
                            Container(width: 8.0, height: 64, color: note.color),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
