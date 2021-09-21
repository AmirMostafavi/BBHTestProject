import 'dart:async';
import 'dart:math';

import 'package:bbh_test_app/bloc/bloc_provider.dart';
import 'package:bbh_test_app/bloc/post_bloc.dart';
import 'package:bbh_test_app/models/comment.dart';
import 'package:bbh_test_app/models/post.dart';
import 'package:bbh_test_app/resources/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';
import '../../utils/retrofit_client_manager.dart';
import '../../utils/size_utils.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  /// ----- Variables -----

  late PostBloc _postBloc;

  /// ----- Widget Lifecycle -----

  @override
  void initState() {
    super.initState();

    /// Initialize BLOC
    _postBloc = PostBloc();

    /// Generate a random postId
    int postId = Random().nextInt(100);

    /// Make GetPost Request
    _makeGetPostRequest(postId);

    /// Make GetPostComments Request
    _makeGetPostCommentsRequest(postId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _postBloc,
      child:

          /// --- Main Scaffold ---
          CupertinoPageScaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.backgroundWhite,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              /// --- App Bar ---
              SizedBox(
                height: SizeUtils.safeBlockVertical * 7,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeUtils.safeBlockVertical * 1,
                  ),
                  child: Stack(
                    children: [
                      /// --- Button : Back ---
                      Positioned(
                        left: 5,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            /// Navigate back
                            Navigator.pop(context);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                CupertinoIcons.back,
                                size: 30,
                                color: CupertinoColors.darkBackgroundGray,
                              )),
                        ),
                      ),

                      /// --- Button : Add Comment ---
                      Positioned(
                        right: 5,
                        top: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {
                            /// Add Comment Function
                            _onNewCommentClicked();
                          },
                          behavior: HitTestBehavior.opaque,
                          child: const Padding(
                              padding: EdgeInsets.all(12),
                              child: Icon(
                                CupertinoIcons.add_circled,
                                size: 30,
                                color: CupertinoColors.darkBackgroundGray,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// --- Spacer ---
              SizedBox(
                height: SizeUtils.safeBlockVertical * 2,
              ),

              /// --- Photo List ---
              Expanded(
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: _postBloc.postStream,
                      initialData: null,
                      builder: (context, snapshot) {
                        Post? postItem = snapshot.data as Post?;

                        /// Check if data is fetched already or not
                        if (postItem == null) {
                          /// Data not fetched yet
                          return Container();
                        } else {
                          /// Data is fetched
                          return _buildPostRow(context, postItem);
                        }
                      },
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: _postBloc.postCommentsStream,
                        initialData: null,
                        builder: (context, snapshot) {
                          List<Comment>? _commentsList =
                              snapshot.data as List<Comment>?;

                          /// Check if data is fetched already or not
                          if (_commentsList == null) {
                            /// Data not fetched yet
                            return Container(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: SizeUtils.safeBlockHorizontal * 7,
                                height: SizeUtils.safeBlockHorizontal * 7,
                                child: CircularProgressIndicator(
                                  strokeWidth:
                                      SizeUtils.safeBlockHorizontal * 0.6,
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                          AppColors.accentColor),
                                ),
                              ),
                            );
                          } else {
                            /// Data is fetched
                            return Scrollbar(
                              thickness: 0,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                primary: true,
                                itemCount: _commentsList.length,
                                itemBuilder: (context, index) {
                                  /// Security Check
                                  if (index >= _commentsList.length) {
                                    return Container();
                                  }

                                  /// Build Comment item row
                                  return _buildCommentRow(
                                      context, _commentsList[index]);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----- Sub-widgets -----

  Widget _buildPostRow(BuildContext context, Post post) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeUtils.safeBlockVertical * 2,
        left: SizeUtils.safeBlockHorizontal * 4,
        right: SizeUtils.safeBlockHorizontal * 4,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.black,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.safeBlockHorizontal * 4,
          vertical: SizeUtils.safeBlockVertical * 2,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// --- Post Title ---
            Text(
              post.title,
              style: AppStyles.postTitleTextStyle,
            ),

            /// --- Spacer ---
            SizedBox(
              height: SizeUtils.safeBlockVertical * 2,
            ),

            /// --- Post Body ---
            Text(
              post.body,
              style: AppStyles.postBodyTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentRow(BuildContext context, Comment commentItem) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeUtils.safeBlockVertical * 1,
        left: SizeUtils.safeBlockHorizontal * 4,
        right: SizeUtils.safeBlockHorizontal * 4,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: CupertinoColors.systemGrey3,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: SizeUtils.safeBlockHorizontal * 4,
          vertical: SizeUtils.safeBlockVertical * 2,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// --- Comment : Name ---
            Text(
              commentItem.name,
              style: AppStyles.postCommentTextStyle,
            ),

            /// --- Comment : Email ---
            Text(
              commentItem.email,
              style: AppStyles.postCommentEmailTextStyle,
            ),

            /// --- Spacer ---
            SizedBox(
              height: SizeUtils.safeBlockVertical * 1,
            ),

            /// --- Comment : Body ---
            Text(
              commentItem.body,
              style: AppStyles.postCommentTextStyle,
            ),
          ],
        ),
      ),
    );
  }

  /// ----- Functions -----

  _onNewCommentClicked() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    /// Dismiss the popup first
                    Navigator.of(context, rootNavigator: true).pop("Discard");

                    /// Lets make a new comment
                    /// TODO - To be implemented
                  },
                  child: Text(
                    AppStrings.postMakeNewComment,
                    style: AppStyles.popupButtonTextStyle,
                  ),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text(
                  AppStrings.cancel,
                  style: AppStyles.popupButtonTextStyle,
                ),
                onPressed: () {
                  /// Dismiss the popup
                  Navigator.of(context, rootNavigator: true).pop("Discard");
                },
              ),
            ));
  }

  /// ----- Server Requests -----

  _makeGetPostRequest(int postId) async {
    /// Make GetPostDetails Request
    RestClientManager.getClient()
        .getPostDetails(postId)
        .then((response) => _onGetPostRequestResponseHandler(response))
        .catchError((obj) => _onRequestErrorHandler(obj))
        .timeout(const Duration(seconds: 30),
            onTimeout: _onRequestTimeoutHandler);
  }

  _onGetPostRequestResponseHandler(Post response) {
    /// Get the response and set it in BLOC
    _postBloc.setPostItem(response);
  }

  _makeGetPostCommentsRequest(int postId) async {
    /// Make GetPostComments Request
    RestClientManager.getClient()
        .getPostComments(postId)
        .then((response) => _onGetPostCommentsRequestResponseHandler(response))
        .catchError((obj) => _onRequestErrorHandler(obj))
        .timeout(const Duration(seconds: 30),
            onTimeout: _onRequestTimeoutHandler);
  }

  _onGetPostCommentsRequestResponseHandler(List<Comment> response) {
    /// Get the response and set it in BLOC
    _postBloc.setPostComments(response);
  }

  _onRequestErrorHandler(errorObject) {
    /// TODO - To be implemented
  }

  FutureOr<Set<void>> _onRequestTimeoutHandler() {
    /// TODO - To be implemented

    var completer = Completer<Set<void>>();
    completer.complete(<dynamic>{});
    return completer.future;
  }
}
