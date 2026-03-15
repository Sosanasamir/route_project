class MovieModel {
  int? id;
  String? title;
  String? year;
  double? rating;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;

  MovieModel({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()),
      title: json['title'] as String?,
      year: json['year']?.toString(),
      // THIS IS THE KEY FIX: Using 'num' handles both int and double from JSON
      rating: (json['rating'] as num?)?.toDouble(),
      smallCoverImage: json['small_cover_image'] as String?,
      mediumCoverImage: json['medium_cover_image'] as String?,
      largeCoverImage: json['large_cover_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'small_cover_image': smallCoverImage,
      'medium_cover_image': mediumCoverImage,
      'large_cover_image': largeCoverImage,
    };
  }
}
