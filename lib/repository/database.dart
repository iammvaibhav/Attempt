import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Table {
  static const SUGGESTIONS = "Suggestions";
  static const LEARNING = "Learning";
  static const SENTENCES = "Sentences";
  static const SENTENCES_DOWNLOADS = "SentencesDownloads";
}

enum SentencesDownloadStatus {
  NOT_DOWNLOADED, DOWNLOADED, SHOULD_DISCARD
}

Future<Database> getDatabase() async {
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
      join(await getDatabasesPath(), 'database.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE ${Table.SUGGESTIONS}(searchKey TEXT PRIMARY KEY, suggestions TEXT)"
        );
        db.execute(
          "CREATE TABLE ${Table.LEARNING}(word TEXT, timeUpdated INTEGER PRIMARY KEY)"
        );
        db.execute(
          "CREATE TABLE ${Table.SENTENCES}(word TEXT, category TEXT, sentence TEXT, PRIMARY KEY (word, category, sentence))"
        );
        db.execute(
          "CREATE TABLE ${Table.SENTENCES_DOWNLOADS}(word TEXT PRIMARY KEY, status INTEGER)"
        );
      },
      version: 1
  );
}