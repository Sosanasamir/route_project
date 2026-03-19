import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().loadUserProfile();

    return Scaffold(
      backgroundColor: Color(0xFF121312),
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            String name = "Guest User";
            String avatar = "assets/images/avatar8.png";

            if (state is ProfileSuccess) {
              name = state.user.displayName ?? "User";
              avatar = state.user.photoURL ?? "assets/images/avatar8.png";
            }

            return Column(
              children: [
                _buildHeader(context, name, avatar),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Color(0xFFF6BD00),
                          labelColor: Color(0xFFF6BD00),
                          unselectedLabelColor: Colors.white54,
                          indicatorWeight: 3,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              icon: Icon(Icons.bookmark_rounded),
                              text: "Watch List",
                            ),
                            Tab(
                              icon: Icon(Icons.history_rounded),
                              text: "History",
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              _buildMovieGrid(context, true),
                              _buildMovieGrid(context, false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String avatar) {
    final historyCount = context
        .watch<MovieCubit>()
        .historyMovies
        .length
        .toString();

    final watchCount = context
        .watch<MovieCubit>()
        .watchListMovies
        .length
        .toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[900],
                    backgroundImage: avatar.startsWith('http')
                        ? NetworkImage(avatar)
                        : AssetImage(avatar) as ImageProvider,
                  ),
                  SizedBox(height: 12),
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatItem(historyCount, "History"),
                  SizedBox(width: 20),
                  _buildStatItem(watchCount, "Watchlist"),
                ],
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, 'edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF6BD00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              IconButton(
                onPressed: () {
                  context.read<ProfileCubit>().logout();

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    'login',
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Colors.redAccent),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovieGrid(BuildContext context, bool isWatchList) {
    final movies = isWatchList
        ? context.read<MovieCubit>().watchListMovies
        : context.read<MovieCubit>().historyMovies;

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWatchList ? Icons.movie_outlined : Icons.history,
              size: 64,
              color: Colors.white24,
            ),
            SizedBox(height: 16),
            Text(
              isWatchList ? "Watchlist is empty" : "No history yet",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return _buildMovieThumbnailWithRating(context, movie);
      },
    );
  }

  Widget _buildMovieThumbnailWithRating(
    BuildContext context,
    MovieModel movie,
  ) {
    return InkWell(
      onTap: () {
        if (!context.read<MovieCubit>().historyMovies.contains(movie)) {
          context.read<MovieCubit>().addToHistory(movie);
        }
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.mediumCoverImage ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.white10),
            ),
          ),
          if (movie.rating != null)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 12),
                    SizedBox(width: 2),
                    Text(
                      "${movie.rating?.toStringAsFixed(1)}",
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
