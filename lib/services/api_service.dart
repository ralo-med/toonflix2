import 'dart:convert';
import 'package:http/http.dart' as http;

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final int voteCount;
  final String releaseDate;
  final List<int> genreIds;
  final List<String> genres;
  final int? runtime;
  final String tagline;
  final String status;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.voteCount,
    required this.releaseDate,
    required this.genreIds,
    required this.genres,
    this.runtime,
    required this.tagline,
    required this.status,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<String> genres = [];
    if (json['genres'] != null) {
      genres = (json['genres'] as List)
          .where((g) => g['name'] != null)
          .map((g) => g['name'] as String)
          .toList();
    }

    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      backdropPath: json['backdrop_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
      voteCount: json['vote_count'] ?? 0,
      releaseDate: json['release_date'] ?? '',
      genreIds: json['genre_ids'] != null
          ? List<int>.from(json['genre_ids'])
          : (json['genres'] != null
              ? (json['genres'] as List)
                  .where((g) => g['id'] != null)
                  .map((g) => g['id'] as int)
                  .toList()
              : []),
      genres: genres,
      runtime: json['runtime'],
      tagline: json['tagline'] ?? '',
      status: json['status'] ?? '',
    );
  }

  String get posterUrl => "https://image.tmdb.org/t/p/w500$posterPath";
  String get backdropUrl => "https://image.tmdb.org/t/p/original$backdropPath";
}

class ApiService {
  static const String baseUrl = "https://movies-api.nomadcoders.workers.dev";

  static Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/popular'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  static Future<List<Movie>> getNowPlayingMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/now-playing'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      final movies = results.map((json) => Movie.fromJson(json)).toList();

      // 날짜 범위 필터링 (2025-06-04 ~ 2025-07-16)
      final filteredMovies = movies.where((movie) {
        final releaseDate = DateTime.parse(movie.releaseDate);
        final startDate = DateTime.parse('2025-06-04');
        final endDate = DateTime.parse('2025-07-16');

        return releaseDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            releaseDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      return filteredMovies;
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  static Future<List<Movie>> getComingSoonMovies() async {
    final response = await http.get(Uri.parse('$baseUrl/coming-soon'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      final movies = results.map((json) => Movie.fromJson(json)).toList();

      // 날짜 범위 필터링 (2025-07-16 ~ 2025-08-06)
      final filteredMovies = movies.where((movie) {
        final releaseDate = DateTime.parse(movie.releaseDate);
        final startDate = DateTime.parse('2025-07-16');
        final endDate = DateTime.parse('2025-08-06');

        return releaseDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            releaseDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      return filteredMovies;
    } else {
      throw Exception('Failed to load coming soon movies');
    }
  }

  static Future<Movie> getMovieDetail(int movieId) async {
    final response = await http.get(Uri.parse('$baseUrl/movie?id=$movieId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Failed to load movie detail');
    }
  }
}
