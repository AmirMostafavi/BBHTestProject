import 'package:json_annotation/json_annotation.dart';

part 'app_strings.g.dart';

@JsonSerializable()
class AppStrings{
  /// ----- Application Name -----
  static const appName = 'BBH Test Application';

  /// ----- Home Screen -----
  static const homeTitle = 'Welcome to the app';
  static const homeSubtitle = 'Press a button to get started';
  static const homeCtaAlbum = 'Discover an album';
  static const homeCtaPost = 'Discover a post';

  /// ----- Album Screen -----
  static const albumNewPostPickPhoto = 'Pick from Gallery';
  static const albumNewPostTakePhoto = 'Take with Camera';

  /// ----- Post Screen -----
  static const postMakeNewComment = 'Lets make a new comment';

  /// ----- General -----
  static const cancel = 'Cancel';

}