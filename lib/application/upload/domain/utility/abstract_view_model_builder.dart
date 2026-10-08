import '../../../../foundation/base/base_viewmodel.dart';

/// Abstract ViewModel builder interface enforcing dependency injection structure.
abstract class AbstractViewModelBuilder<T extends BaseViewModel> {
  T build();
}
