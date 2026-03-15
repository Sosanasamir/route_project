import 'package:flutter/material.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final MovieModel movie; // We pass the movie here

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF121312),
      appBar: AppBar(title: Text(movie.title ?? 'Movie Details')),
      body: Column(
        children: [
          Image.network(movie.largeCoverImage ?? ''),
          Text(movie.title ?? '', style: TextStyle(color: Colors.white)),
          // Add your summary and rating widgets here
        ],
      ),
    );
  }
}
