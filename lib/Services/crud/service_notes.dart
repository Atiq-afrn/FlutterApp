import 'package:flutter/material.dart';
import 'package:myfrstapp/Services/crud/crud_exception.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;
  Future<DataBaseNotes> updateNotes({
    required DataBaseNotes note,
    required String text,
  }) async {
    final db = _getDataBaseOrThrow();

    await fetchSpeceficNotes(id: note.id);
    final updateCount = await db.update(
      notesTable,
      {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      },
    );
    if (updateCount == 0) {
      throw CouldNotUpdateNotes();
    } else {
      return await fetchSpeceficNotes(id: note.id);
    }
  }

  Future<Iterable<DataBaseNotes>> getAllNotes() async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      notesTable,
    );
    return notes.map(
      (notesRow) => DataBaseNotes.formRow(notesRow),
    );
  }

  Future<DataBaseNotes> fetchSpeceficNotes({required int id}) async {
    final db = _getDataBaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: 'id=?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldnotFoundNotes();
    } else {
      return DataBaseNotes.formRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDataBaseOrThrow();
    return await db.delete(notesTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDataBaseOrThrow();
    final deleteCount =
        await db.delete(notesTable, where: 'id=?', whereArgs: [id]);
    if (deleteCount != 0) {
      throw CouldNotDeleteNotes();
    }
  }

  Future<DataBaseNotes> creatNotes({required DatabaseUser owner}) async {
    final db = _getDataBaseOrThrow();
// make  sure user exist in database with valid id

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFOundUser();
    }
    // creating notes
    const text = "";
    final notesId = await db.insert(notesTable, {
      userColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DataBaseNotes(
        id: notesId, userId: owner.id, text: text, isSyncedWithCloud: true);
    return note;
  }

  // retrieving  user which is register

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDataBaseOrThrow();
    final result = await db.query(
      userTable,
      limit: 1,
      where: "email=?",
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (result.isEmpty) {
      throw CouldNotFOundUser();
    } else {
      return DatabaseUser.formRow(result.first);
    }
  }

// creating user in database
  Future<DatabaseUser> creatUser({required String email}) async {
    final db = _getDataBaseOrThrow();

    final result = await db.query(
      userTable,
      where: 'email=?',
      whereArgs: [email.toLowerCase()],
    );
    if (result.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );
    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDataBaseOrThrow();

    final deletedCount = await db.delete(
      userTable,
      where: 'email=?',
      whereArgs: [
        email.toLowerCase(),
      ],
    );
    if (deletedCount != 1) {
      throw CouldNOtDelete();
    }
  }

  Database _getDataBaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DataBaseIsNotOpen();
    } else {
      await db.close();
      _db = db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbPath = join(docspath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

// create the user table
      await db.execute(creatUserTable);

// create the notes table

      await db.execute(createNotesTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });
  DatabaseUser.formRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID=$id, emai=$email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DataBaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DataBaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });
  DataBaseNotes.formRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;
  @override
  String toString() =>
      'Notes , Id=$id, userId=$userId , isSyncedWithcloud=$isSyncedWithCloud , text=$text';

  @override
  bool operator ==(covariant DataBaseNotes other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const userTable = 'user';
const notesTable = 'note';

const idColumn = 'Id';
const emailColumn = 'email';
const userColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

const creatUserTable = '''CREATE TABLE IF NOT EXISTS "user"   (
	"Id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Id" AUTOINCREMENT)
);
       ''';

const createNotesTable = ''' CREATE TABLE  IF NOT EXISTS "notes" (
	"id"	INTEGER NOT NULL COLLATE UTF16CI,
	"user_id"	INTEGER NOT NULL UNIQUE,
	"Text"	TEXT NOT NULL,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("Id")
);
''';
