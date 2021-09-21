import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_sizes.dart';

abstract class AppStyles {
  /// ------ Text Styles -----

  static TextStyle boardingTitleStyle = TextStyle(
    color: CupertinoColors.black,
    fontSize: AppSizes.fontSizeHigh,
    fontWeight: FontWeight.w900,
  );

  static TextStyle boardingSubtitleStyle = TextStyle(
    color: CupertinoColors.black,
    fontSize: AppSizes.fontSizeMedium,
    fontWeight: FontWeight.w400,
  );

  static TextStyle ctaButtonTextStyle = TextStyle(
    color: CupertinoColors.white,
    fontSize: AppSizes.fontSizeRegular,
    fontWeight: FontWeight.w500,
  );

  static TextStyle popupTitleTextStyle = TextStyle(
    color: CupertinoColors.black,
    fontSize: AppSizes.fontSizeRegular,
    fontWeight: FontWeight.w400,
  );

  static TextStyle popupButtonTextStyle = TextStyle(
    color: CupertinoColors.black,
    fontSize: AppSizes.fontSizeRegular,
    fontWeight: FontWeight.w400,
  );

  static TextStyle postTitleTextStyle = TextStyle(
    color: CupertinoColors.white,
    fontSize: AppSizes.fontSizeSmall,
    fontWeight: FontWeight.w500,
  );

  static TextStyle postBodyTextStyle = TextStyle(
    color: CupertinoColors.white,
    fontSize: AppSizes.fontSizeSmall,
    fontWeight: FontWeight.w400,
  );

  static TextStyle postCommentTextStyle = TextStyle(
    color: CupertinoColors.white,
    fontSize: AppSizes.fontSizeSmall,
    fontWeight: FontWeight.w400,
  );

  static TextStyle postCommentEmailTextStyle = TextStyle(
    color: CupertinoColors.systemGrey,
    fontSize: AppSizes.fontSizeSmall,
    fontWeight: FontWeight.w400,
  );

}