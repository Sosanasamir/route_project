import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/profile/logic/profile_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/profile/logic/watchlist_cubit.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().loadUserProfile();
    context.read<WatchlistCubit>().getWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121312),
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
                        const TabBar(
                          indicatorColor: Color(0xFFF6BD00),
                          labelColor: Color(0xFFF6BD00),
                          unselectedLabelColor: Colors.white54,
                          indicatorSize: TabBarIndicatorSize.label,
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
                              _buildWatchListSection(),
                              _buildHistorySection(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _buildStatItem(
                    context.watch<MovieCubit>().historyMovies.length.toString(),
                    "History",
                  ),
                  const SizedBox(width: 20),

                  BlocBuilder<WatchlistCubit, List<MovieModel>>(
                    builder: (context, watchlist) => _buildStatItem(
                      watchlist.length.toString(),
                      "Watchlist",
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, 'update_profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6BD00),
                    minimumSize: const Size(0, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _handleLogout(context),
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.1),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWatchListSection() {
    return BlocBuilder<WatchlistCubit, List<MovieModel>>(
      builder: (context, watchlist) {
        if (watchlist.isEmpty) {
          return _buildEmptyState(
            "Watchlist is empty",
            Icons.movie_outlined,
            imagePath: 'assets/images/popcorn.png',
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${watchlist.length} Movies Saved",
                    style: const TextStyle(color: Colors.white54),
                  ),
                  TextButton(
                    onPressed: () => _showClearConfirmation(context),
                    child: const Text(
                      "Clear All",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildMovieGrid(watchlist)),
          ],
        );
      },
    );
  }

  Widget _buildHistorySection() {
    final history = context.watch<MovieCubit>().historyMovies;
    if (history.isEmpty) {
      return _buildEmptyState("No history yet", Icons.history);
    }
    return _buildMovieGrid(history);
  }

  Widget _buildMovieGrid(List<MovieModel> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return InkWell(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: movie),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              movie.mediumCoverImage ?? '',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.white10,
                child: const Icon(Icons.movie, color: Colors.white24),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon, {String? imagePath}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null)
            Image.asset(imagePath, width: 140, height: 140)
          else
            Icon(icon, size: 64, color: Colors.white24),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF282A28),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          "Clear Watchlist?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Are you sure you want to remove all saved movies?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              context.read<WatchlistCubit>().clearWatchlist();
              Navigator.pop(context);
            },
            child: const Text(
              "Clear",
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    context.read<ProfileCubit>().logout();
    Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ],
    );
  }
}
