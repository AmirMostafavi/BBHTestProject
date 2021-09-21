import 'dart:async';
import 'dart:math';

import 'package:bbh_test_app/bloc/album_bloc.dart';
import 'package:bbh_test_app/bloc/bloc_provider.dart';
import 'package:bbh_test_app/models/photo.dart';
import 'package:bbh_test_app/resources/app_strings.dart';
import 'package:bbh_test_app/resources/app_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../resources/app_colors.dart';
import '../../utils/retrofit_client_manager.dart';
import '../../utils/size_utils.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  /// ----- Constants -----

  final ImagePicker _imagePicker = ImagePicker();

  /// ----- Variables -----

  late AlbumBloc _albumBloc;

  /// ----- Widget Lifecycle -----

  @override
  void initState() {
    super.initState();

    /// Initialize BLOC
    _albumBloc = AlbumBloc();

    /// Make GetAlbumPhotoList Request
    _makeGetAlbumPhotoListRequest();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _albumBloc,
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
                    padding: EdgeInsets.symmetric(vertical: SizeUtils.safeBlockVertical * 1),
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

                        /// --- Button : Add Photo ---
                        Positioned(
                          right: 5,
                          top: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {
                              /// Show Upload New Photo Popup
                              _onUploadNewPhotoClicked();
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
                child: StreamBuilder(
                  stream: _albumBloc.albumPhotoListStream,
                  initialData: null,
                  builder: (context, snapshot) {
                    List<Photo>? _itemsList = snapshot.data as List<Photo>?;

                    /// Check if data is fetched already or not
                    if (_itemsList == null) {
                      /// Data not fetched yet
                      return Container(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: SizeUtils.safeBlockHorizontal * 7,
                          height: SizeUtils.safeBlockHorizontal * 7,
                          child: CircularProgressIndicator(
                            strokeWidth: SizeUtils.safeBlockHorizontal * 0.6,
                            valueColor: const AlwaysStoppedAnimation<Color>(
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
                          itemCount: _itemsList.length,
                          itemBuilder: (context, index) {
                            /// Security Check
                            if (index >= _itemsList.length) {
                              return Container();
                            }

                            /// Build Photo item row
                            return _buildPhotoItemRow(context, _itemsList[index]);
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
      ),
    );
  }

  /// ----- Sub-widgets -----

  Widget _buildPhotoItemRow(BuildContext context, Photo photo) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: SizeUtils.safeBlockVertical * 2,
          left: SizeUtils.safeBlockHorizontal * 10,
          right: SizeUtils.safeBlockHorizontal * 10,
      ),
      child: SizedBox(
        height: SizeUtils.safeBlockHorizontal * 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/images/image-placeholder.jpg',
            image: photo.url,
            fit: BoxFit.fill,
            fadeInDuration: const Duration(milliseconds: 300),
          ),
        ),
      ),
    );
  }

  /// ----- Functions -----

  _onUploadNewPhotoClicked() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    /// Dismiss the popup first
                    Navigator.of(context, rootNavigator: true).pop("Discard");

                    /// Open the Gallery
                    _pickImageFromGallery();
                  },
                  child: Text(
                    AppStrings.albumNewPostPickPhoto,
                    style: AppStyles.popupButtonTextStyle,
                  ),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    /// Dismiss the popup first
                    Navigator.of(context, rootNavigator: true).pop("Discard");

                    /// Open the Camera
                    _takePhotoWithCamera();
                  },
                  child: Text(
                    AppStrings.albumNewPostTakePhoto,
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

  _pickImageFromGallery() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    /// TODO - To be implemented
  }

  _takePhotoWithCamera() async {
    final XFile? photo =
        await _imagePicker.pickImage(source: ImageSource.camera);

    /// TODO - To be implemented
  }

  /// ----- Server Requests -----

  _makeGetAlbumPhotoListRequest() async {
    /// Make GetAlbumPhotoList Request
    RestClientManager.getClient()
        .getAlbumPhotoList(Random().nextInt(100))
        .then((response) => _onRequestResponseHandler(response))
        .catchError((obj) => _onRequestErrorHandler(obj))
        .timeout(const Duration(seconds: 30),
            onTimeout: _onRequestTimeoutHandler);
  }

  _onRequestResponseHandler(List<Photo> response) {
    /// Get the response and stream it
    _albumBloc.setAlbumPhotosList(response);
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
