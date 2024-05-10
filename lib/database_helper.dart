import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/Hike.dart';
import 'model/observation.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'hikes_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE hikes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        location TEXT,
        date TEXT,
        parking TEXT,
        length TEXT,
        difficulty TEXT,
        description TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE observations (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      time TEXT,
      comment TEXT,
      hikeId INTEGER,
      FOREIGN KEY (hikeId) REFERENCES hikes (id)
    )
  ''');
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('hikes'); // Delete all data from the 'hikes' table
    await db.delete('observations'); // Delete all data from the 'observations' table
  }

  Future<void> insertHike(Hike hike) async {
    final db = await database;
    await db.insert('hikes', hike.toMap());
  }

  Future<void> insertObservation(Observation observation) async{
    final db = await database;
    await db.insert('observations', observation.toMap());
  }

  Future<List<Hike>> searchHikesByName(String hikeName) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hikes', where: 'name LIKE ?', whereArgs: ['%$hikeName%']);
    return List.generate(maps.length, (i) {
      return Hike(
        id: maps[i]['id'],
        name: maps[i]['name'],
        location: maps[i]['location'],
        date: maps[i]['date'],
        parking: maps[i]['parking'],
        length: maps[i]['length'],
        difficulty: maps[i]['difficulty'],
        description: maps[i]['description'],
      );
    });
  }

  Future<Hike?> viewHikeById(int hikeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hikes', where: 'id = ?', whereArgs: [hikeId]);

    if (maps.isNotEmpty) {
      return Hike(
        id: maps[0]['id'],
        name: maps[0]['name'],
        location: maps[0]['location'],
        date: maps[0]['date'],
        parking: maps[0]['parking'],
        length: maps[0]['length'],
        difficulty: maps[0]['difficulty'],
        description: maps[0]['description'],
      );
    } else {
      // Hike with the provided ID was not found
      return null;
    }
  }

  Future<Observation?> viewObservationById(int observationId) async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('observations', where: 'id = ?', whereArgs: [observationId]);

    if (maps.isNotEmpty) {
      return Observation(
        id: maps[0]['id'],
        title: maps[0]['title'],
        time: maps[0]['time'],
        comment: maps[0]['comment'],
        hikeId: maps[0]['hikeId'],
      );
    } else {
      // Hike with the provided ID was not found
      return null;
    }
  }

  Future<void> updateHike(Hike hike) async {
    final db = await database;
    await db.update(
      'hikes',
      hike.toMap(), // Convert the Hike object to a map
      where: 'id = ?',
      whereArgs: [hike.id],
    );
  }

  Future<void> updateObservation(Observation observation) async {
    final db = await database;
    await db.update(
      'observations',
      observation.toMap(), // Convert the Hike object to a map
      where: 'id = ?',
      whereArgs: [observation.id],
    );
  }

  Future<void> deleteHike(int hikeId) async {
    final db = await database;
    await db.delete('hikes', where: 'id = ?', whereArgs: [hikeId]);
  }

  Future<void> deleteObservation(int observationId) async {
    final db = await database;
    await db.delete('observations', where: 'id = ?', whereArgs: [observationId]);
  }

  Future<List<Observation>> getObservationsByHike(int hikeId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'observations',
      where: 'hikeId = ?',
      whereArgs: [hikeId],
    );

    return List.generate(maps.length, (i) {
      return Observation(
        id: maps[i]['id'],
        title: maps[i]['title'],
        time: maps[i]['time'],
        comment: maps[i]['comment'],
        hikeId: maps[i]['hikeId'],
      );
    });
  }


}