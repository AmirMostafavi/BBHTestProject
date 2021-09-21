import 'dart:async';

import 'package:bbh_test_app/models/comment.dart';
import 'package:bbh_test_app/models/post.dart';

import 'bloc.dart';

class PostBloc implements Bloc {
  Post? _postItem;
  Post? get postItem => _postItem;
  final _postController = StreamController<Post?>.broadcast();
  Stream<Post?> get postStream => _postController.stream;

  List<Comment>? _postCommentList;
  List<Comment>? get postCommentList => _postCommentList;
  final _commentsController = StreamController<List<Comment>?>.broadcast();
  Stream<List<Comment>?> get postCommentsStream => _commentsController.stream;

  @override
  void dispose() {
    _postController.close();
    _commentsController.close();
  }

  /// ----- Setters -----

  void setPostItem(Post post) {
    _postItem = post;
    _postController.sink.add(_postItem);
  }

  void setPostComments(List<Comment> commentList) {
    _postCommentList = commentList;
    _commentsController.sink.add(_postCommentList);
  }
}
