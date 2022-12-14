import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learn_dart/services/crud/notes_exception.dart';
import 'package:path/path.dart'
    show join; //Get the Application path of the mobile device.
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory, MissingPlatformDirectoryException;
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as devtools show log;

import '../../constants/sqflite_database.dart';

//Service that communitcate with sqflite engine, including CRUD-Functions
class NotesService {
  Database? _db;

  //works as cache for note entrys
  List<DatabaseNote> _notes = [];

  //creates a stream to listen for changes inside _notes list. (of type <List<DatabaseNote>>)
  final _notesStreamController = StreamController<
      List<
          DatabaseNote>>.broadcast(); //.boradcast will ensure that we can use the stream later again (open and close the stream on action)

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = getUser(email: email);
      return user;
    } on CouldNotFoundUserException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList(); //add aiterable to list variable
    _notesStreamController.add(_notes); //add notes to stream controller
  }

  Future<DatabaseNote> updateNote({
    required DatabaseNote note,
    required String text,
  }) async {
    final db = _getDatabaseOrThrowException();

    //make sure note exists
    await getNote(id: note.id);

    //update db
    final updatesCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNoteException();
    } else {
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  //READ all notes
  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrowException();
    final notes = await db.query(
      noteTable,
    );

    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  //Initialize Database or throw error if not exists
  Database _getDatabaseOrThrowException() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  //Read note
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrowException();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFoundNoteException();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id == id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  //Delete all notes
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrowException();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  //Delete note
  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrowException();

    final deleteCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount == 0) {
      throw CouldNotDeleteNoteException();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  //Create note
  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrowException();

    //make sure owner exists in the db with correct id.
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFoundUserException();
    }

    const text = '';

    //create notes
    final notesId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedColumn: 1,
    });

    final note = DatabaseNote(
      id: notesId,
      userId: owner.id,
      text: text,
      isSynced: true,
    );

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  //READ user
  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrowException();

    final results = await db.query(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty) {
      throw CouldNotFoundUserException();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  //DELETE User
  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrowException();

    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CloudNotDeleteUserException();
    }
  }

  //Create user
  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrowException();
    //Check if entry does not already exist.
    final results = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId = await db.insert(
      userTable,
      {emailColumn: email.toLowerCase()},
    );
    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  //Open db (Like a open book that we can than write and read on)
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }

    try {
      //open database
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      //create user table
      await db.execute(createUserTable);
      //create user table
      await db.execute(createNoteTable);

      await _cacheNotes();
      devtools.log('$dbName is opened and created $userTable and $noteTable.');
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectory();
    }
  }

  //Close db
  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      devtools.log('$dbName is closed.');
      await db.close();
    }
  }
}

//Create abstract User class
@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//Create abstract Note class
@immutable
class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSynced;

  const DatabaseNote(
      {required this.id,
      required this.userId,
      required this.text,
      required this.isSynced});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSynced = (map[isSyncedColumn] as int) == 1
            ? true
            : false; //enty input: 0 = false 1 = true

  @override
  String toString() =>
      'Note, ID = $id, userID = $userId, text = $text, isSynced = $isSynced';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
