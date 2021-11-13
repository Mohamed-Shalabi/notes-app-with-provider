import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';

class NoteModel {
  int id;
  String title;
  String text;
  DateTime creationTime;
  DateTime modificationTime;
  bool archived;
  bool completed;
  bool locked;
  MaterialColor color;

  NoteModel({
    required this.id,
    this.title = '',
    this.text = '',
    required this.creationTime,
    required this.modificationTime,
    this.archived = false,
    this.color = Colors.yellow,
    this.completed = false,
    this.locked = false,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'text': text,
        'creation_time': DateFormat().format(creationTime),
        'modification_time': DateFormat().format(modificationTime),
        'archived': archived ? 1 : 0,
        'completed': completed ? 1 : 0,
        'locked': locked ? 1 : 0,
        'color': colors.indexOf(color),
      };

  static NoteModel fromMap(Map<String, dynamic> noteMapped) {
    return NoteModel(
      id: noteMapped['id'],
      title: noteMapped['title'],
      text: noteMapped['text'],
      creationTime: DateFormat().parse(noteMapped['creation_time']),
      modificationTime: DateFormat().parse(noteMapped['modification_time']),
      archived: noteMapped['archived'] == 1,
      completed: noteMapped['completed'] == 1,
      locked: noteMapped['locked'] == 1,
      color: colors[noteMapped['color']],
    );
  }
}
