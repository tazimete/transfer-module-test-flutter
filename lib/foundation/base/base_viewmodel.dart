import 'dart:async';

import 'package:flutter/material.dart';

// class BaseViewModel extends ChangeNotifier {
//   bool _busy = false;
//
//   bool get busy => _busy;
//
//   void setBusy(bool value) {
//     _busy = value;
//     notifyListeners();
//   }
//   void rebuildUi() {
//     notifyListeners();
//   }
// }


abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDisposed = false;
  bool _isInitializeDone = false;

  FutureOr<void> _initState;

  BaseViewModel() {
    _init();
  }

  FutureOr<void> init();

  void _init() async {
    this.isLoading = false;
    _initState = init();
    await _initState;
    this._isInitializeDone = true;
  }

  void changeStatus() => isLoading = !isLoading;
  void showLoading() {
    if (!isLoading) isLoading = true;
  }
  void hideLoading() {
    if (isLoading) isLoading = false;
  }

  void reloadState() {
    if (!isLoading) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  //Getters
  FutureOr<void> get initState => _initState;

  bool get isLoading => _isLoading;
  bool get isDisposed => _isDisposed;
  bool get isInitialized => _isInitializeDone;

  //Setters
  set isLoading(bool value) {
    _isLoading = value;
    scheduleMicrotask(() {
      if (!_isDisposed) notifyListeners();
    });
  }
}