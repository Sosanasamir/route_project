class MovieDetailsResponse {
  final MovieData data;

  MovieDetailsResponse({required this.data});

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailsResponse(data: MovieData.fromJson(json['data'] ?? {}));
  }
}

class MovieData {
  final MovieDetails? movie;

  MovieData({this.movie});

  factory MovieData.fromJson(Map<String, dynamic> json) {
    return MovieData(
      movie: json['movie'] != null
          ? MovieDetails.fromJson(json['movie'])
          : null,
    );
  }
}

class MovieDetails {
  final int? id;
  final String? title;
  final int? year;
  final dynamic rating;
  final int? runtime;
  final String? summary;
  final String? descriptionFull;
  final String? smallCoverImage;
  final String? mediumCoverImage;
  final String? largeCoverImage;
  final List<String>? genres;
  final List<Cast>? cast;

  MovieDetails({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.runtime,
    this.summary,
    this.descriptionFull,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.genres,
    this.cast,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    return MovieDetails(
      id: json['id'],
      title: json['title'],
      year: json['year'],
      rating: json['rating'],
      runtime: json['runtime'],
      summary: json['summary'],
      descriptionFull: json['description_full'],
      smallCoverImage: json['small_cover_image'],
      mediumCoverImage: json['medium_cover_image'],
      largeCoverImage: json['large_cover_image'],
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      cast: json['cast'] != null
          ? (json['cast'] as List).map((i) => Cast.fromJson(i)).toList()
          : null,
    );
  }
}

class Cast {
  final String? name;
  final String? characterName;
  final String? urlSmallImage;

  Cast({this.name, this.characterName, this.urlSmallImage});

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      characterName: json['character_name'],
      urlSmallImage: json['url_small_image'],
    );
  }
}
