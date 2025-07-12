import 'package:flutter/material.dart';
import 'package:toonflix2/services/api_service.dart';
import 'package:toonflix2/widgets/movie_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> popularMovies;
  late Future<List<Movie>> nowPlayingMovies;
  late Future<List<Movie>> comingSoonMovies;

  @override
  void initState() {
    super.initState();
    popularMovies = ApiService.getPopularMovies();
    nowPlayingMovies = ApiService.getNowPlayingMovies();
    comingSoonMovies = ApiService.getComingSoonMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                _buildHeader(),
                const SizedBox(height: 40),
                _buildPopularSection(),
                const SizedBox(height: 25),
                _buildNowPlayingSection(),
                const SizedBox(height: 25),
                _buildUpcomingSection(),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "RALOMOVIE",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.search, color: Colors.white, size: 28),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildMovieList({
    required Future<List<Movie>> moviesFuture,
    required bool isPopular,
    required bool isSmall,
    required double height,
  }) {
    return SizedBox(
      height: height,
      child: FutureBuilder<List<Movie>>(
        future: moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No movies found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, idx) => MovieCardWidget(
              movie: snapshot.data![idx],
              isPopular: isPopular,
              isSmall: isSmall,
            ),
            separatorBuilder: (_, __) => SizedBox(width: isPopular ? 16 : 12),
          );
        },
      ),
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Popular Movies",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        _buildMovieList(
          moviesFuture: popularMovies,
          isPopular: true,
          isSmall: false,
          height: 350,
        ),
      ],
    );
  }

  Widget _buildNowPlayingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Now Playing"),
        const SizedBox(height: 16),
        _buildMovieList(
          moviesFuture: nowPlayingMovies,
          isPopular: false,
          isSmall: false,
          height: 320,
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Upcoming Movies"),
        const SizedBox(height: 16),
        _buildMovieList(
          moviesFuture: comingSoonMovies,
          isPopular: false,
          isSmall: true,
          height: 300,
        ),
      ],
    );
  }
}
