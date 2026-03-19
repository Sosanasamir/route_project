class OnboardingData {
  String imagePath;
  String title;
  String? desc;

  OnboardingData({
    required this.imagePath,
    required this.title,
     this.desc,
  });
}

List<OnboardingData> onboarding = [
  OnboardingData(
    imagePath: 'assets/images/pic2.png',
    title: 'Discover Movies',
    desc:
        'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
  ),
  OnboardingData(
    imagePath: 'assets/images/pic3.png',
    title: 'Explore All Genres',
    desc:
        'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
  ),
  OnboardingData(
    imagePath: 'assets/images/pic4.png',
    title: 'Create Watchlists',
    desc:
        'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
  ),
  OnboardingData(
    imagePath: 'assets/images/pic5.png',
    title: 'Rate, Review, and Learn',
    desc:
        'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
  ),
  OnboardingData(
    imagePath: 'assets/images/pic6.png',
    title: 'Start Watching Now',
   ),
];
