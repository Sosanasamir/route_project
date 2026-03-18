import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/features/movies/logic/movie_cubit.dart';
import 'package:movie_app/features/movies/logic/movie_states.dart';
import 'package:movie_app/features/movies/data/movie_model.dart';
import 'package:movie_app/features/movies/ui/movie_details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentPage = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMovieTap(BuildContext context, MovieModel movie) {
    context.read<MovieCubit>().addToHistory(movie);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MovieDetailsScreen(),
        settings: RouteSettings(arguments: movie),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieCubit, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0XFFF6BD00)),
          );
        }

        if (state is MovieError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (state is MovieSuccess) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildHeroHeader(),

              const SizedBox(height: 20),

              const _SectionHeader(title: "Suggested For You"),
              _buildSuggestedSlider(state.suggested),

              const SizedBox(height: 30),

              const _SectionHeader(title: "Action Movies"),
              _buildActionGrid(state.action),

              const SizedBox(height: 40),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeroHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'assets/images/pic6.png',
          width: double.infinity,
          height: 400,
          fit: BoxFit.cover,
        ),
        Container(
          height: 400,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Color(0XFF121312)],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: Image.asset('assets/images/title.png', width: 250),
        ),
      ],
    );
  }

  Widget _buildSuggestedSlider(List<MovieModel> suggested) {
    return SizedBox(
      height: 350,
      child: PageView.builder(
        controller: _pageController,
        itemCount: suggested.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) {
          final movie = suggested[index];
          double scale = _currentPage == index ? 1.0 : 0.85;
          return GestureDetector(
            onTap: () => _onMovieTap(context, movie),
            child: TweenAnimationBuilder(
              duration: const Duration(milliseconds: 350),
              tween: Tween(begin: scale, end: scale),
              builder: (context, double value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.largeCoverImage ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.white10),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionGrid(List<MovieModel> action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: action.length > 6 ? 6 : action.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          final movie = action[index];
          return GestureDetector(
            onTap: () => _onMovieTap(context, movie),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                movie.mediumCoverImage ?? '',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.white10),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
