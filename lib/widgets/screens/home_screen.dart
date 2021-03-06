import 'package:bbh_test_app/resources/app_strings.dart';
import 'package:bbh_test_app/widgets/components/widget_cta_filled_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';
import '../../resources/app_styles.dart';
import '../../utils/size_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  /// ----- Widget Lifecycle -----
  @override
  Widget build(BuildContext context) {
    /// Initialize SizeUtils
    SizeUtils().init(context);

    /// --- Main Scaffold ---
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundWhite,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeUtils.safeBlockHorizontal * 8),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// --- Title ---
                        Text(
                          AppStrings.homeTitle,
                          style: AppStyles.boardingTitleStyle,
                        ),

                        /// --- Subtitle ---
                        Text(
                          AppStrings.homeSubtitle,
                          style: AppStyles.boardingSubtitleStyle,
                        ),
                      ],
                    ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      /// --- CTA - Discover an album ---
                      CtaFilledButtonWidget(
                        text: AppStrings.homeCtaAlbum,
                        onPressed: (){
                          /// Navigate to AlbumListScreen
                          Navigator.pushNamed(context, '/album-screen');
                        },
                      ),

                      /// --- Spacer ---
                      SizedBox(
                        height: SizeUtils.safeBlockVertical * 2,
                      ),

                      /// --- CTA - Discover a post ---
                      CtaFilledButtonWidget(
                        text: AppStrings.homeCtaPost,
                        onPressed: (){
                          /// Navigate to PostListScreen
                          Navigator.pushNamed(context, '/post-screen');
                        },
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
}
