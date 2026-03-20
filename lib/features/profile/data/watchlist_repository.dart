import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';

class WatchlistRepository {
  final String _baseUrl = "https://your-mock-api.com/api";

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('watchlist.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE watchlist (
            id INTEGER PRIMARY KEY,
            title TEXT,
            year TEXT,
            rating REAL,
            medium_cover_image TEXT,
            large_cover_image TEXT,
            description_full TEXT,
            runtime INTEGER,
            genres TEXT
          )
        ''');
      },
    );
  }

  Future<void> addToWatchlist(MovieModel movie) async {
    final db = await database;
    await db.insert('watchlist', {
      'id': movie.id,
      'title': movie.title,
      'year': movie.year,
      'rating': movie.rating,
      'medium_cover_image': movie.mediumCoverImage,
      'large_cover_image': movie.largeCoverImage,
      'description_full': movie.summary,
      'runtime': movie.runtime,

      'genres': jsonEncode(movie.genres ?? []),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    syncWithRemote(movie);
  }

  Future<void> removeFromWatchlist(int movieId) async {
    final db = await database;
    await db.delete('watchlist', where: 'id = ?', whereArgs: [movieId]);
  }

  Future<List<MovieModel>> getWatchlist() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('watchlist');

    return maps.map((map) {
      final movieMap = Map<String, dynamic>.from(map);

      if (movieMap['genres'] != null && movieMap['genres'] is String) {
        try {
          movieMap['genres'] = jsonDecode(movieMap['genres']);
        } catch (e) {
          movieMap['genres'] = [];
        }
      }

      return MovieModel(
        id: movieMap['id'],
        title: movieMap['title'],
        year: movieMap['year'],
        rating: (movieMap['rating'] as num?)?.toDouble() ?? 0.0,
        mediumCoverImage: movieMap['medium_cover_image'],
        largeCoverImage: movieMap['large_cover_image'],
        summary: movieMap['description_full'],
        runtime: movieMap['runtime'],
        genres: movieMap['genres'] != null
            ? List<String>.from(movieMap['genres'])
            : [],
      );
    }).toList();
  }

  Future<bool> isMovieInWatchlist(int movieId) async {
    final db = await database;
    final maps = await db.query(
      'watchlist',
      where: 'id = ?',
      whereArgs: [movieId],
    );
    return maps.isNotEmpty;
  }

  Future<void> clearAllWatchlist() async {
    final db = await database;
    await db.delete('watchlist');
  }

  Future<void> syncWithRemote(MovieModel movie) async {
    try {
      await http
          .post(
            Uri.parse("$_baseUrl/watchlist"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'movie_id': movie.id,
              'title': movie.title,
              'added_at': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(const Duration(seconds: 3));
    } catch (e) {
      print("Background sync failed (expected if URL is mock): $e");
    }
  }
}
