import '../errors/failure.dart';

sealed class Result<T> {
  const Result();

  factory Result.success(T data) = Success<T>;

  factory Result.failure(Failure failure) = ErrorResult<T>;
}

class Success<T> extends Result<T> {
  final T data;

  const Success(this.data) : super();
}

class ErrorResult<T> extends Result<T> {
  final Failure failure;

  const ErrorResult(this.failure) : super();
}
