import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/models/ElquranModel.dart';
import 'package:quran/models/saved_sora.dart';
import 'package:quran/values/color.dart';

class ViewProvider extends ChangeNotifier {
  ViewProvider._();

  static ViewProvider instance = ViewProvider._();

  double appBarHeight = kToolbarHeight;
  bool isAppBarVisible = true;
  int pageIndex = 0;
  double sliderValue = 20.0;
  double maxSliderValue = 69;
  double minSliderValue = 15;
  bool isBottomSheetVisible = false;
  bool shrincSelectionStateBox = false;
  bool offsetVisiblaty = false;
  Offset offset = Offset(0, 0);
  String theme = "main";

  changeOffsetVisiblty() {
    offsetVisiblaty = !offsetVisiblaty;
    notifyListeners();
  }

  changeSelectionState(value) {
    shrincSelectionStateBox = value;
    notifyListeners();
  }

  changeBottomSheetState() {
    isBottomSheetVisible = !isBottomSheetVisible;

    notifyListeners();
  }

  changeSliderValue(value) {
    sliderValue = value;
    notifyListeners();
  }

  increaseSliderValue() {
    if (sliderValue < maxSliderValue) {
      sliderValue++;
    }
    notifyListeners();
  }

  decreaseSliderValue() {
    if (sliderValue > minSliderValue) {
      sliderValue--;
    }
    notifyListeners();
  }

  changeAppBarHeight() {
    appBarHeight = (isAppBarVisible) ? 0 : kToolbarHeight;
    isAppBarVisible = !isAppBarVisible;

    notifyListeners();
  }

  changePageIndex(int pageIndex) {
    this.pageIndex = pageIndex;
    if (pageIndex > 0 && isAppBarVisible) {
      this.changeAppBarHeight();
      return;
    }
    notifyListeners();
  }

  prepareSoraWithData(SavedSora sora) {
    pageIndex = sora.pageNumber;
  }

  resetPage() {
    pageIndex = 0;
    appBarHeight = kToolbarHeight;
    isAppBarVisible = true;
  }
}
