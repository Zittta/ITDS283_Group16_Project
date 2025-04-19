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
      version: 4, // Updated version
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
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
        meaning TEXT,
        memo TEXT,
        photo TEXT,
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

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _addColumnIfNotExists(db, 'cards', 'photo', 'TEXT');
    }

    if (oldVersion < 3) {
      await _addColumnIfNotExists(db, 'cards', 'meaning', 'TEXT');
    }

    if (oldVersion < 4) {
      await db.execute('ALTER TABLE cards RENAME TO cards_old');

      await db.execute(''' 
        CREATE TABLE cards (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          folder_id INTEGER,
          question TEXT,
          meaning TEXT,
          memo TEXT,
          photo TEXT,
          FOREIGN KEY (folder_id) REFERENCES folders (id) ON DELETE CASCADE
        )
      ''');

      await db.execute(''' 
        INSERT INTO cards (id, folder_id, question, meaning, memo, photo)
        SELECT id, folder_id, question, meaning, memo, photo FROM cards_old
      ''');

      await db.execute('DROP TABLE cards_old');
    }
  }

  // Add the column if it doesn't already exist
  Future<void> _addColumnIfNotExists(Database db, String table, String columnName, String columnType) async {
    final result = await db.rawQuery('PRAGMA table_info($table)');
    final columns = result.map((row) => row['name']).toList();

    if (!columns.contains(columnName)) {
      await db.execute('ALTER TABLE $table ADD COLUMN $columnName $columnType');
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

  Future<int> insertCard(
    int folderId,
    String question,
    String meaning,
    String memo, {
    String? photo,
  }) async {
    final db = await database;
    return await db.insert('cards', {
      'folder_id': folderId,
      'question': question,
      'meaning': meaning,
      'memo': memo,
      'photo': photo ?? null,
    });
  }

  Future<List<Map<String, dynamic>>> getCards(int folderId) async {
    final db = await database;
    return await db.query('cards', where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<int> updateCard(
    int id,
    String question,
    String meaning,
    String memo, {
    String? photo,
  }) async {
    final db = await database;
    return await db.update(
      'cards',
      {
        'question': question,
        'meaning': meaning,
        'memo': memo,
        'photo': photo ?? null,
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
