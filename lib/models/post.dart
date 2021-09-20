import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class Post {
  Post(this.userId, this.id, this.title, this.body);

  /// ----- Properties -----

  int userId;
  int id;
  String title;
  String body;

  /// ----- Functions -----

  factory Post.fromJson(Map<String, dynamic> json) =>
      _$PostFromJson(json);

  Map<String, dynamic> toJson() => _$PostToJson(this);

}
