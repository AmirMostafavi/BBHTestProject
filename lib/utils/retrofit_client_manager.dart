import 'package:bbh_test_app/models/comment.dart';
import 'package:bbh_test_app/models/photo.dart';
import 'package:bbh_test_app/models/post.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client_manager.g.dart';

/// ----- Rest Client Manager -----

class RestClientManager {
  static RetrofitRestClient? _retrofitRestClient;

  static const apiEndpointUrl = "https://jsonplaceholder.typicode.com";

  static void rebuildClient(
      {bool customizedTimeout = false,
      bool rebuildForMultipart = false,
      bool rebuildForJson = false}) async {

    /// Create Dio Instance
    final dio = Dio(BaseOptions(contentType: 'application/json'));

    /// Add Customized DioBaseOptions for timeout customization
    if (customizedTimeout) {
      BaseOptions customizedDioBaseOptions = BaseOptions(
          baseUrl: apiEndpointUrl,
          receiveDataWhenStatusError: true,
          connectTimeout: 10 * 1000,
          receiveTimeout: 10 * 1000);
      dio.options = customizedDioBaseOptions;
    }

    /// Create Retrofit Rest Client
    _retrofitRestClient = RetrofitRestClient(dio);
  }

  static RetrofitRestClient getClient() {
    if (_retrofitRestClient == null) {
      rebuildClient();
    }

    return _retrofitRestClient!;
  }

}

/// ----- Retrofit Rest Client -----

@RestApi(baseUrl: RestClientManager.apiEndpointUrl)
abstract class RetrofitRestClient {
  factory RetrofitRestClient(Dio dio, {String baseUrl}) = _RetrofitRestClient;

  /// --- Get an Album's Image List  ---

  @GET("/photos")
  Future<List<Photo>> getAlbumPhotoList(
    @Query('albumId') int albumId,
  );

  /// --- Get a Post's Details  ---

  @GET("/posts/{postId}")
  Future<Post> getPostDetails(
    @Path('postId') int postId,
  );

  /// --- Get a Post's Comments List  ---

  @GET("/posts/{postId}/comments")
  Future<List<Comment>> getPostComments(
    @Path('postId') int postId,
  );
}
