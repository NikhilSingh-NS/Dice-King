import 'package:flutter/material.dart';
import 'package:dice_app/utils/constants.dart';

enum ViewState { Idle, Busy }


class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;
  NETWORK_STATUS networkState = NETWORK_STATUS.IDLE;

  ViewState get state => _state;

  void applyState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }
}
