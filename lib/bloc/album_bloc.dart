import 'dart:async';

import 'package:bbh_test_app/models/photo.dart';

import 'bloc.dart';

class AlbumBloc implements Bloc {
  List<Photo>? _photoList;

  List<Photo>? get photoList => _photoList;
  
  final _controller = StreamController<List<Photo>?>.broadcast();

  Stream<List<Photo>?> get albumPhotoListStream => _controller.stream;
  
  @override
  void dispose() {
    _controller.close();
  }

  /// ----- Setters -----

  void setAlbumPhotosList(List<Photo> photoList) {
    _photoList = photoList;
    _controller.sink.add(_photoList);
  }
}
