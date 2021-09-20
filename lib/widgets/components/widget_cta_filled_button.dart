import 'package:bbh_test_app/resources/app_colors.dart';
import 'package:bbh_test_app/resources/app_styles.dart';
import 'package:bbh_test_app/utils/size_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CtaFilledButtonWidget extends StatelessWidget {
  CtaFilledButtonWidget(
      {Key? key,
      required this.text,
      this.buttonActivateStatus = true,
      required this.onPressed,
      this.isLoading = false})
      : super(key: key);

  final String text;
  final dynamic onPressed;
  final bool buttonActivateStatus;
  final Color fillColor = AppColors.defaultAccentColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
            padding: EdgeInsets.symmetric(vertical: SizeUtils.safeBlockVertical * 2),
            child: isLoading
                ? SizedBox(
                    width: SizeUtils.safeBlockHorizontal * 4.5,
                    height: SizeUtils.safeBlockHorizontal * 4.5,
                    child: CircularProgressIndicator(
                      strokeWidth: SizeUtils.safeBlockHorizontal * 0.6,
                    ),
                  )
                : Text(
                    text,
                    style: AppStyles.ctaButtonTextStyle,
                    textAlign: TextAlign.center,
                  ),
            color: fillColor,
            onPressed: buttonActivateStatus && !isLoading ? onPressed : null,
    );
  }
}
