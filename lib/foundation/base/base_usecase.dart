abstract class BaseUseCaseParam<P, R> {
  Future<R> invoke(P params);
}

abstract class BaseUseCase<R> {
  Future<R> invoke();
}
