import 'package:flutter/material.dart';
import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/modules/single_note/single_note_provider.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';
import 'package:notes_app_with_provider/shared/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SingleNoteScreen extends StatefulWidget {
  const SingleNoteScreen(this.note, {Key? key, this.isNewNote = false}) : super(key: key);

  final bool isNewNote;
  final NoteModel note;

  @override
  State<SingleNoteScreen> createState() => _SingleNoteScreenState();
}

class _SingleNoteScreenState extends State<SingleNoteScreen> {
  //
  final titleController = TextEditingController();
  final textController = TextEditingController();
  final passwordController = TextEditingController();
  final searchController = TextEditingController();
  final passwordKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Provider.of<SingleNoteProvider>(context, listen: false).init(widget.note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleNoteProvider>(
      builder: (context, singleNoteProvider, _) {
        return WillPopScope(
          onWillPop: () async {
            if (singleNoteProvider.isEditing) {
              singleNoteProvider.toggleIsEditing();
              return false;
            }
            if (singleNoteProvider.isSearching) {
              singleNoteProvider.isSearching = false;
              return false;
            }
            if (widget.isNewNote && singleNoteProvider.hasEdited) {
              final id = await singleNoteProvider.insertNoteToDatabase(widget.note);
              widget.note.id = id;
            } else if (singleNoteProvider.hasEdited) {
              singleNoteProvider.updateNote(widget.note);
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: singleNoteProvider.isEditing
                  ? TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsetsDirectional.only(start: 12.0),
                        border: InputBorder.none,
                        fillColor: Theme.of(context).colorScheme.surface,
                        filled: true,
                      ),
                      style: TextStyles.headingStyle.copyWith(decoration: widget.note.completed ? TextDecoration.lineThrough : TextDecoration.none),
                      onChanged: (value) => singleNoteProvider.title = value,
                    )
                  : Text(
                      singleNoteProvider.title,
                      style: TextStyles.headingStyle.copyWith(decoration: widget.note.completed ? TextDecoration.lineThrough : TextDecoration.none),
                    ),
              backgroundColor: Themes.isDarkMode ? singleNoteProvider.color.shade800 : singleNoteProvider.color,
              leading: IconButton(
                icon: Icon(singleNoteProvider.isEditing ? Icons.check : Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                onPressed: singleNoteProvider.isEditing
                    ? () {
                        singleNoteProvider.toggleIsEditing();
                        singleNoteProvider.hasEdited = true;
                        singleNoteProvider.title = titleController.text;
                        singleNoteProvider.text = textController.text;
                      }
                    : () => Navigator.of(context).maybePop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    singleNoteProvider.isEditing ? Icons.album_outlined : Icons.edit,
                    size: singleNoteProvider.isEditing ? 28 : 24,
                    color: singleNoteProvider.isEditing ? singleNoteProvider.color.shade100 : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: singleNoteProvider.isEditing
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: MediaQuery.of(context).size.width * 0.75,
                                child: Center(
                                  child: Wrap(
                                    children: colors
                                        .map(
                                          (e) => IconButton(
                                            iconSize: MediaQuery.of(context).size.width * 0.2,
                                            icon: Icon(Icons.album_outlined, color: e),
                                            onPressed: () => {Navigator.of(context).pop(), singleNoteProvider.color = e},
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      : () {
                          titleController.text = singleNoteProvider.title;
                          textController.text = singleNoteProvider.text;
                          singleNoteProvider.toggleIsEditing();
                        },
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  onSelected: (choice) => _onMenuItemTapped(choice, singleNoteProvider),
                  itemBuilder: (BuildContext context) {
                    return singleNoteProvider.isEditing
                        ? {
                            'return',
                            'send',
                            'search',
                            widget.note.locked ? 'unlock' : 'lock',
                            widget.note.archived ? 'unarchive' : 'archive',
                            'delete',
                          }.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList()
                        : {
                            widget.note.completed ? 'uncompleted' : 'completed',
                            'send',
                            'search',
                            widget.note.locked ? 'unlock' : 'lock',
                            widget.note.archived ? 'unarchive' : 'archive',
                            'delete',
                          }.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                  },
                ),
              ],
            ),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: singleNoteProvider.isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: RichText(
                        text: TextSpan(
                          children: singleNoteProvider
                              .getSearchedText(searchController.text.trim())
                              .map(
                                (e) => TextSpan(
                                  text: e,
                                  style: TextStyles.subHeadingStyle.copyWith(
                                    backgroundColor:
                                        e.trim() == searchController.text.trim() ? singleNoteProvider.color.shade300 : Theme.of(context).colorScheme.surface,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    )
                  : singleNoteProvider.isEditing
                      ? TextField(
                          controller: textController,
                          style: TextStyles.subHeadingStyle,
                          decoration: const InputDecoration(contentPadding: EdgeInsetsDirectional.only(start: 12.0), border: InputBorder.none),
                          maxLines: null,
                          onChanged: (value) => singleNoteProvider.text = value,
                        )
                      : Padding(padding: const EdgeInsets.all(12.0), child: Text(singleNoteProvider.text, style: TextStyles.subHeadingStyle)),
            ),
          ),
        );
      },
    );
  }

  void _onMenuItemTapped(String choice, SingleNoteProvider singleNoteProvider) {
    switch (choice) {
      case 'completed':
        singleNoteProvider.updateCompleted(widget.note);
        widget.note.completed = true;
        break;
      case 'uncompleted':
        singleNoteProvider.updateCompleted(widget.note);
        widget.note.completed = false;
        break;
      case 'return':
        singleNoteProvider.isEditing = false;
        singleNoteProvider.hasEdited = true;
        break;
      case 'send':
        Share.share(widget.note.text);
        break;
      case 'search':
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
                          Text('Enter what you want to search for', style: TextStyles.titleStyle),
                          TextField(controller: searchController),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  singleNoteProvider.isSearching = true;
                                  Navigator.of(context).pop();
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
                }));
        break;
      case 'lock':
        final isPasswordExists = singleNoteProvider.updateLocked(widget.note);
        if (!isPasswordExists) {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 24),
                    Text('Enter password for all locked notes', style: TextStyles.titleStyle),
                    Form(
                      key: passwordKey,
                      child: TextFormField(
                        controller: passwordController,
                        validator: (data) {
                          if (data == null || data.length < 4) {
                            return 'password must be archive than or equal 4 characters';
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            if (passwordKey.currentState?.validate() ?? false) {
                              singleNoteProvider
                                ..setPassword(passwordController.text.trim())
                                ..updateLocked(widget.note);
                              Navigator.of(context).pop();
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
            ),
          );
        }
        break;
      case 'unlock':
        singleNoteProvider.updateLocked(widget.note);
        break;
      case 'archive':
        singleNoteProvider.updateArchived(widget.note);
        break;
      case 'unarchive':
        singleNoteProvider.updateArchived(widget.note);
        break;
      case 'delete':
        Navigator.of(context).pop();
        singleNoteProvider.delete(widget.note);
        break;
    }
  }
}
