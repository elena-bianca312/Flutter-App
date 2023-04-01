import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myproject/services/crud/crud_exceptions.dart';

class NotesService {
  Database? _db;

  Database _getDatabaseOrThrow() {
    if (_db == null) {
      throw DatabaseIsNotOpenException();
    }
    return _db!;
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // Create the tables if they don't exist
      // Create user table
      await db.execute(createUserTable);
      // Create note table
      await db.execute(createNoteTable);

    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    if (_db == null) {
      throw DatabaseIsNotOpenException();
    }
    await _db!.close();
    _db = null;
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: '$email = ?',
      whereArgs: [email.toLowerCase()]
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$email = ?',
      whereArgs: [email.toLowerCase()]
    );

    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase()
    });

    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: '$email = ?',
      whereArgs: [email.toLowerCase()]
    );

    if (results.isEmpty) {
      throw CouldNotFindUserException();
    }

    return DatabaseUser.fromRow(results.first);
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    // Make sure the user exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    const text = '';
    // Create a new note in the database
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1
    });

    // Create a new note object
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true
    );

    return note;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: '$id = ?',
      whereArgs: [id]
    );
    if (deletedCount == 0) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    // Return the number of rows deleted
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: '$id = ?',
      whereArgs: [id]
    );

    if (notes.isEmpty) {
      throw CouldNotFindNoteException();
    }

    return DatabaseNote.fromRow(notes.first);
  }

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((row) => DatabaseNote.fromRow(row));
  }

  Future<DatabaseNote> updateNote(
    {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      return await getNote(id: note.id);
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int,
    email = map[emailColumn] as String;

  @override
  String toString() => 'DatabaseUser(id: $id, email: $email)';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({required this.id, required this.userId, required this.text, required this.isSyncedWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
  : id = map[idColumn] as int,
    userId = map[userIdColumn] as int,
    text = map[textColumn] as String,
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() => 'Note(id: $id, userId: $userId, isSyncedWithCloud: $isSyncedWithCloud, text: $text)';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// The name of the database file and corresponding table names
const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';

// The column names of the database table
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";

// Create table constants
const createUserTable = '''
  CREATE TABLE IF NOT EXISTS "user" (
    "id"	INTEGER NOT NULL,
    "email"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id" AUTOINCREMENT)
  );''';
const createNoteTable = '''
  CREATE TABLE IF NOT EXISTS "note" (
    "id"	INTEGER NOT NULL,
    "user_id"	INTEGER NOT NULL,
    "text"	TEXT,
    "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY("user_id") REFERENCES "user"("id"),
    PRIMARY KEY("id" AUTOINCREMENT)
  );''';
