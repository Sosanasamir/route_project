import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/logic/borwse_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  String selectedGenre = "Action";
  List<String> genres = [
    "Action",
    "Comedy",
    "Drama",
    "Animation",
    "Horror",
    "Romance",
    "Sci-Fi",
    "Thriller",
  ];

  @override
  void initState() {
    super.initState();
    context.read<BrowseCubit>().getMoviesByGenre(selectedGenre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF121312),
      body: BlocBuilder<BrowseCubit, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is MovieSuccess) {
            return Column(
              children: [
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      final genre = genres[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGenre = genre;
                          });
                          context.read<BrowseCubit>().getMoviesByGenre(genre);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: selectedGenre == genre
                                ? Color(0XFFF6BD00)
                                : Color(0XFF121312),
                            border: Border.all(
                              color: Color(0XFFF6BD00),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              genre,
                              style: TextStyle(
                                color: selectedGenre == genre
                                    ? Colors.black
                                    : Color(0XFFF6BD00),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(child: buildMoviesGrid(state.all)),
              ],
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

Widget buildMoviesGrid(List<MovieModel> movies) {
  return GridView.builder(
    padding: EdgeInsets.all(12),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      childAspectRatio: 0.65,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
    ),
    itemCount: movies.length,
    itemBuilder: (context, index) {
      final movie = movies[index];
      return InkWell(
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.mediumCoverImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  filterQuality: FilterQuality.high,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),

              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, color: Color(0XFFF6BD00), size: 14),
                      SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
