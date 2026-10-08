import 'package:transfermodule/foundation/base/base_viewmodel.dart';

class DashboardViewmodel extends BaseViewModel {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  @override
  Future<void> init() async {}
}
