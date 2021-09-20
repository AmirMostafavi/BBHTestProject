import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@JsonSerializable()
class Photo {
  Photo(this.albumId, this.id, this.title, this.url, this.thumbnailUrl);

  /// ----- Properties -----

  int albumId;
  int id;
  String title;
  String url;
  String thumbnailUrl;

  /// ----- Functions -----

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}