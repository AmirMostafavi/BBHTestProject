import 'package:bbh_test_app/models/comment.dart';
import 'package:bbh_test_app/models/photo.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit_client_manager.g.dart';

/// ----- Rest Client Manager -----

class RestClientManager {
  static RetrofitRestClient? _retrofitRestClient;
  static Dio? clientDio;

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

    /// Add Dio Interceptor for logging purpose
    // dio.interceptors.add(PrettyDioLogger(
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: true,
    //   responseBody: true,
    //   error: true,
    //   compact: true,
    // ));

    /// Add Global Request Headers
    // dio.options.headers["Accept-Language"] = "fa";
    // dio.options.headers["Accept"] = "*/*";
    // dio.options.headers["Access-Control-Allow-Origin"] = "*";
    //
    // if (!kIsWeb && !rebuildForMultipart) {
    //   dio.options.headers["Content-Type"] = "application/json";
    // }
    //
    // if (rebuildForJson) {
    //   dio.options.headers["Content-Type"] = "application/json";
    // }

    /// Add Authorization Header if UserAuthorizationData exist
    // AuthorizationObject userAuthData = await _loadUserAuthorizationData();
    // if (userAuthData != null) {
    //   dio.options.headers["Authorization"] = "Bearer ${(userAuthData).token}";
    // }

    /// Set Dio static variable
    clientDio = dio;

    /// Create Retrofit Rest Client
    _retrofitRestClient = RetrofitRestClient(dio);
  }

  static RetrofitRestClient getClient() {
    if (_retrofitRestClient == null) {
      rebuildClient();
    }

    return _retrofitRestClient!;
  }

// static _loadUserAuthorizationData() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var userProfileJson = prefs.getString(AppPrefsDictionary.PREF_USER_AUTH);
//   if (userProfileJson != null) {
//     Map<String, dynamic> userAuthMap = json.decode(userProfileJson);
//     return userAuthMap != null ? AuthorizationObject.fromJson(userAuthMap) : null;
//   } else {
//     return null;
//   }
// }

// static loadDocument(String documentId) {
//   return "$apiEndpointUrl/documents/$documentId/true";
// }
}

/// ----- Retrofit Rest Client -----

@RestApi(baseUrl: RestClientManager.apiEndpointUrl)
abstract class RetrofitRestClient {
  factory RetrofitRestClient(Dio dio, {String baseUrl}) = _RetrofitRestClient;

  /// --- Get an album's image list  ---

  @GET("/photos")
  Future<List<Photo>> getAlbumPhotoList(
    @Query('albumId') int albumId,
  );

  @GET("/posts/{postId}/comments")
  Future<List<Comment>> getCommentList(
    @Path('postId') int postId,
  );
}
