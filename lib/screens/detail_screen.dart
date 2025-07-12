import 'package:flutter/material.dart';
import 'package:toonflix2/services/api_service.dart';
import 'package:toonflix2/widgets/movie_background_widget.dart';
import 'package:toonflix2/widgets/movie_rating_widget.dart';
import 'package:toonflix2/widgets/movie_genre_tags_widget.dart';
import 'package:toonflix2/widgets/movie_info_widget.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> movieFuture;

  @override
  void initState() {
    super.initState();
    movieFuture = ApiService.getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Movie>(
        future: movieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A1A1A),
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              backgroundColor: const Color(0xFF1A1A1A),
              body: Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              backgroundColor: Color(0xFF1A1A1A),
              body: Center(
                child: Text(
                  'Movie not found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          final movie = snapshot.data!;
          return _buildMovieDetail(movie);
        },
      ),
    );
  }

  Widget _buildMovieDetail(Movie movie) {
    return Scaffold(
      body: MovieBackgroundWidget(
        backdropUrl: movie.backdropUrl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 뒤로가기
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 18),
                // 제목
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                // 별점
                MovieRatingWidget(voteAverage: movie.voteAverage),
                const SizedBox(height: 8),
                // 장르
                MovieGenreTagsWidget(genres: movie.genres),
                const SizedBox(height: 12),
                // 영화 정보
                MovieInfoWidget(
                  releaseDate: movie.releaseDate,
                  runtime: movie.runtime,
                  tagline: movie.tagline,
                ),
                const SizedBox(height: 20),
                // Overview 타이틀
                const Text(
                  "Overview",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // 설명
                if (movie.overview.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        movie.overview,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                // Buy ticket 버튼
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {},
                      child: const Text("Buy ticket"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
