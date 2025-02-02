import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_theme/const.dart';
import 'package:lib_theme/get_theme.dart';
import 'package:lib_utils/universal_platform.dart';
import 'package:oktoast/oktoast.dart';
import 'package:get/get.dart';
import 'circular_progress.dart';
import 'icon_font.dart';

enum LoadingActivityState {
  none,
  success,
  fail,
}

/// 显示loading效果
class Loading {
  static ToastFuture? toast;

  static Widget getActivityIndicator({
    double radius = 10.0,
    required Color color,
  }) {
    return UnconstrainedBox(
      child: !UniversalPlatform.isIOS
          ? Theme(
              data: ThemeData(
                  cupertinoOverrideTheme:
                      const CupertinoThemeData(brightness: Brightness.dark)),
              child: CupertinoActivityIndicator(radius: radius))
          : SizedBox(
              width: radius * 2,
              height: radius * 2,
              child: CircularProgressIndicator(
                backgroundColor: color,
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(Get.themeToken.fg.white1),
              ),
            ),
    );
  }

  /// 根据状态返回不同的状态Widget
  static Widget getActivityState(LoadingActivityState state) {
    if (state == LoadingActivityState.none) {
      return const SizedBox();
    }
    IconData? iconData;
    if (state == LoadingActivityState.success) {
      iconData = IconFont.toastSuccess;
    } else if (state == LoadingActivityState.fail) {
      iconData = IconFont.toastFail;
    }

    return UnconstrainedBox(
      child: Icon(
        iconData,
        size: 40,
        color: Get.themeToken.fg.white1,
      ),
    );
  }

  /// 显示loading
  static void show({
    String? label,
    bool isEmpty = false,
  }) {
    hide();
    toast = showToastWidget(
        Material(
          color: Colors.transparent,
          child: isEmpty
              ? const SizedBox.expand()
              : Center(
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                        color: Get.themeToken.fg.widget,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgress(
                            primaryColor: Get.themeToken.fg.white1,
                            secondaryColor:
                                Get.themeToken.fg.white1.withOpacity(0),
                            strokeWidth: 3,
                            size: 33,
                          ),
                          if (label != null) sizeHeight24,
                          if (label != null)
                            Text(
                              label,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Get.themeToken.fg.white1),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
        animationDuration: Duration.zero,
        duration: Duration.zero,
        handleTouch: true);
  }

  /// 关闭loading
  static void hide() {
    if (toast != null && !toast!.dismissed) {
      toast!.dismiss();
      toast = null;
    }
  }

  // 显示延迟关闭提示
  static void showDelayTip(
    BuildContext context,
    String? label, {
    int duration = 1500,
    bool isModal = true,
    bool isEmpty = false,
    Widget? widget,
    LoadingActivityState state = LoadingActivityState.none,
  }) {
    hide();
    Timer(Duration(milliseconds: duration), hide);

    toast = showToastWidget(Material(
      color: Colors.transparent,
      child: isEmpty
          ? const SizedBox()
          : GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: isModal ? null : hide,
              child: Center(
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                      color: Get.themeToken.fg.widget,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget ?? getActivityState(state),
                        if (label != null) sizeHeight24,
                        if (label != null)
                          Text(
                            label,
                            style: TextStyle(
                                fontSize: 14, color: Get.themeToken.fg.white1),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    ));
  }

  /// 判断是否loading
  static bool get visible => toast != null;
}
