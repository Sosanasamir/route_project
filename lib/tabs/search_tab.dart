import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie_cubit.dart';
import 'package:movie_app/bloc/states.dart';
import 'package:movie_app/models/movie_model.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => SearchTabState();
}

class SearchTabState extends State<SearchTab> {
  TextEditingController search = TextEditingController();
  bool isSearching = false;

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF121312),
      appBar: AppBar(
        backgroundColor: Color(0XFF121312),
        toolbarHeight: 100,
        title: Padding(
          padding: EdgeInsets.only(top: 40, left: 16, right: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0XFF282A28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              controller: search,
              onChanged: (value) {
                setState(() {
                  isSearching = value.isNotEmpty;
                });
                if (value.isNotEmpty) {
                  context.read<MovieCubit>().searchMovie(value);
                }
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search, color: Colors.white),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          if (!isSearching)
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/images/search.png',
                  fit: BoxFit.cover,
                  height: 125,
                  width: 125,
                ),
              ),
            ),

          if (isSearching)
            Expanded(
              child: BlocBuilder<MovieCubit, MovieState>(
                builder: (context, state) {
                  if (state is MovieLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is MovieError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is MovieSuccess) {
                    final List<MovieModel> movies = state.allMovies;
                    if (movies.isEmpty) {
                      return Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: movies.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.65,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'details',
                              arguments: movie,
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            clipBehavior: Clip.antiAlias,
                            child: Stack(
                              children: [
                                Image.network(
                                  movie.mediumCoverImage ?? '',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                                  progress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.white54,
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 14,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          movie.rating?.toString() ?? '0',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
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
                  return SizedBox.shrink();
                },
              ),
            ),
        ],
      ),
    );
  }
}
