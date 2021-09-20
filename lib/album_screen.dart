import 'dart:async';
import 'dart:math';

import 'package:bbh_test_app/models/photo.dart';
import 'package:bbh_test_app/resources/app_strings.dart';
import 'package:bbh_test_app/widgets/components/widget_cta_filled_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';

import 'resources/app_colors.dart';
import 'resources/app_styles.dart';
import 'utils/retrofit_client_manager.dart';
import 'utils/size_utils.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen>
    with SingleTickerProviderStateMixin {
  /// ----- Constants -----

  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final ImagePicker _imagePicker = ImagePicker();

  /// ----- Variables -----

  List<Photo>? _itemsList;

  /// ----- Widget Lifecycle -----

  @override
  void initState() {
    super.initState();

    /// Make GetAlbumPhotoList Request
    _makeGetAlbumPhotoListRequest();
  }

  @override
  Widget build(BuildContext context) {
    /// --- Main Scaffold ---
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// --- App Bar ---
          SizedBox(
            height: SizeUtils.safeBlockVertical * 8,
            child: Stack(
              children: [
                /// --- Button : Back ---
                Positioned(
                  left: 0,
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
                  right: 0,
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

          /// --- Spacer ---
          SizedBox(
            height: SizeUtils.safeBlockVertical * 2,
          ),

          /// --- Photo List ---
          Expanded(
            child: _itemsList == null
                ?

                /// Data not fetched yet
                Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: SizeUtils.safeBlockHorizontal * 7,
                      height: SizeUtils.safeBlockHorizontal * 7,
                      child: CircularProgressIndicator(
                        strokeWidth: SizeUtils.safeBlockHorizontal * 0.6,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.defaultAccentColor),
                      ),
                    ),
                  )
                :

                /// Data is fetched
                Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeUtils.safeBlockHorizontal * 15),
                    child: Scrollbar(
                      thickness: 0,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        primary: true,
                        itemCount: _itemsList!.length,
                        itemBuilder: (context, index) {
                          /// Security Check
                          if (index >= _itemsList!.length) {
                            return Container();
                          }

                          /// Build Photo item row
                          return _buildPhotoItem(context, index);
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  /// ----- Subwidgets -----

  Widget _buildPhotoItem(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeUtils.safeBlockVertical * 2),
      child: SizedBox(
        height: SizeUtils.safeBlockHorizontal * 70,
        width: SizeUtils.safeBlockHorizontal * 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: CupertinoColors.activeGreen,
          ),
        ),

        // Image.network(
        //   _itemsList![index].url,
        //   fit: BoxFit.fill,
        // ),
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
                  child: const Text(AppStrings.albumNewPostPickPhoto),
                ),
                CupertinoActionSheetAction(
                  onPressed: () {
                    /// Dismiss the popup first
                    Navigator.of(context, rootNavigator: true).pop("Discard");

                    /// Open the Camera
                    _takePhotoWithCamera();
                  },
                  child: const Text(AppStrings.albumNewPostTakePhoto),
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: const Text(AppStrings.cancel),
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
    /// Make GetAlbumPhotoList Request Request
    RestClientManager.getClient()
        .getAlbumPhotoList(Random().nextInt(100))
        .then((response) => _onRequestResponseHandler(response))
        .catchError((obj) => _onRequestErrorHandler(obj))
        .timeout(const Duration(seconds: 30),
            onTimeout: _onRequestTimeoutHandler);
  }

  _onRequestResponseHandler(List<Photo> response) {
    /// Get the response and update _itemsList
    setState(() {
      _itemsList = response;
    });
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
