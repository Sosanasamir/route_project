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
      id: json['id'],
      title: json['title'],
      year: json['year'].toString(),
      rating: (json['rating'] is int)
          ? (json['rating'] as int).toDouble()
          : json['rating'],
      smallCoverImage: json['small_cover_image'],
      mediumCoverImage: json['medium_cover_image'],
      largeCoverImage: json['large_cover_image'],
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
