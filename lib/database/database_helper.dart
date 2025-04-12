import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'flashcards.db');
    print("Using DB path: $path");

    return await openDatabase(
      path,
      version: 2,  // Increment the version number for migration
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,  // Handle upgrading the database schema
      onOpen: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE folders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE cards (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_id INTEGER,
        question TEXT,
        answer TEXT,
        photo TEXT NULL,  // Add the 'photo' column
        FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE quiz_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        folder_id INTEGER,
        score INTEGER,
        timestamp TEXT,
        FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
      )
    ''');

    print("Database created with 'folders', 'cards', and 'quiz_scores' tables");
  }

  // Database Upgrade Logic
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add the 'photo' column if upgrading from version 1 to version 2
      await db.execute('''
        ALTER TABLE cards ADD COLUMN photo TEXT;
      ''');
    }
  }

  // ─── Folder CRUD ─────────────────────────────────────────────────────────────

  Future<int> insertFolder(String name) async {
    final db = await database;
    return await db.insert('folders', {'name': name});
  }

  Future<List<Map<String, dynamic>>> getFolders() async {
    final db = await database;
    return await db.query('folders');
  }

  Future<int> updateFolder(int id, String name) async {
    final db = await database;
    return await db.update(
      'folders',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFolder(int id) async {
    final db = await database;
    return await db.delete('folders', where: 'id = ?', whereArgs: [id]);
  }

  // ─── Card CRUD ───────────────────────────────────────────────────────────────
  Future<int> insertCard(int folderId, String question, String answer, {String? photo}) async {
    final db = await database;
    return await db.insert('cards', {
      'folder_id': folderId,
      'question': question,
      'answer': answer,
      'photo': photo ?? null,  // Allow photo to be null
    });
  }

  Future<List<Map<String, dynamic>>> getCards(int folderId) async {
    final db = await database;
    return await db.query('cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<int> updateCard(int id, String question, String answer, {String? photo}) async {
    final db = await database;
    return await db.update(
      'cards',
      {
        'question': question,
        'answer': answer,
        'photo': photo ?? null,  // Allow photo to be null
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete('cards', where: 'id = ?', whereArgs: [id]);
  }
  
  // ─── Quiz Scores ─────────────────────────────────────────────────────────────

  Future<int> insertQuizScore(int folderId, int score) async {
    final db = await database;
    final timestamp = DateTime.now().toIso8601String();
    return await db.insert('quiz_scores', {
      'folder_id': folderId,
      'score': score,
      'timestamp': timestamp,
    });
  }

  Future<List<Map<String, dynamic>>> getQuizScores(int folderId) async {
    final db = await database;
    return await db.query(
      'quiz_scores',
      where: 'folder_id = ?',
      whereArgs: [folderId],
      orderBy: 'timestamp DESC',
    );
  }
}
