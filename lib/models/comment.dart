import 'package:json_annotation/json_annotation.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  Comment(this.postId, this.id, this.name, this.email, this.body);

  /// ----- Properties -----

  int postId;
  int id;
  String name;
  String email;
  String body;

  /// ----- Functions -----

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
