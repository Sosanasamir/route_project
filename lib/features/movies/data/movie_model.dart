class MovieModel {
  int? id;
  String? title;
  String? year;
  double? rating;
  String? smallCoverImage;
  String? mediumCoverImage;
  String? largeCoverImage;
  String? summary;
  int? runtime;
  List<String>? genres;
  List<CastMember>? cast;
  //  List<String>? screenshots;

  MovieModel({
    this.id,
    this.title,
    this.year,
    this.rating,
    this.smallCoverImage,
    this.mediumCoverImage,
    this.largeCoverImage,
    this.summary,
    this.runtime,
    this.genres,
    this.cast,
    // this.screenshots,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0'),
      title: json['title'] as String?,
      year: json['year']?.toString(),
      rating: (json['rating'] as num?)?.toDouble(),
      smallCoverImage: json['small_cover_image'] as String?,
      mediumCoverImage: json['medium_cover_image'] as String?,
      largeCoverImage: json['large_cover_image'] as String?,
      summary: json['description_full'] as String?,
      runtime: json['runtime'] as int?,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'].map((x) => x.toString()))
          : [],
      cast: json['cast'] != null
          ? (json['cast'] as List).map((i) => CastMember.fromJson(i)).toList()
          : [],
      //   screenshots: json['screenshots'] != null
      //    ? List<String>.from(json['screenshots'])
      //      : [],
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
      'summary': summary,
      'runtime': runtime,
      'genres': genres,
     // 'screenshots': screenshots,
      'cast': cast?.map((i) => i.toJson()).toList(),
    };
  }
}

class CastMember {
  final String? name;
  final String? character;
  final String? photoUrl;

  CastMember({this.name, this.character, this.photoUrl});

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: json['name'],
      character: json['character_name'],
      photoUrl: json['url_small_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'character_name': character,
      'url_small_image': photoUrl,
    };
  }
}
