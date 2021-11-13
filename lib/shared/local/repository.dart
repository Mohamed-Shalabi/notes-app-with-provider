import 'package:notes_app_with_provider/models/note_model.dart';
import 'package:notes_app_with_provider/shared/components/constants.dart';
import 'package:notes_app_with_provider/shared/local/cache_helper.dart';
import 'package:notes_app_with_provider/shared/local/data_provider.dart';

class NotesRepository {
  NotesRepository._();

  static Future<void> openDatabase() async {
    await NotesDataProvider.openDatabase();
  }

  static Future<int> insert(NoteModel note) async {
    return await NotesDataProvider.insert(note.toMap());
  }

  static Future<int> delete(NoteModel note) async {
    return await NotesDataProvider.delete(note.id);
  }

  static Future<int> deleteAll() async {
    return await NotesDataProvider.deleteAll();
  }

  static Future<List<NoteModel>> query() async {
    final list = <NoteModel>[];
    final listMapped = await NotesDataProvider.query();
    for (final noteMapped in listMapped) {
      list.add(NoteModel.fromMap(noteMapped));
    }
    return list;
  }

  static Future<int> updateCompleted(NoteModel note) async {
    return NotesDataProvider.updateCompleted(note.id, note.completed ? 0 : 1);
  }

  static Future<int> updateArchived(NoteModel note) async {
    return NotesDataProvider.updateArchived(note.id, note.archived ? 0 : 1);
  }

  static Future<int> updateLocked(NoteModel note) async {
    return NotesDataProvider.updateLocked(note.id, note.locked ? 0 : 1);
  }

  static Future<int> updateColor(NoteModel note, int color) async {
    return NotesDataProvider.updateColor(note.id, color);
  }

  static Future<int> updateTitle(NoteModel note, String title) async {
    return NotesDataProvider.updateTitle(note.id, title);
  }

  static Future<int> updateText(NoteModel note, String text) async {
    return NotesDataProvider.updateText(note.id, text);
  }

  static void setPassword(String password) {
    CacheHelper.saveData(key: SharedPreferencesKeys.passwordKey, value: password);
  }
}
