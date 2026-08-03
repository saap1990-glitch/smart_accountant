import '../utils/result.dart';
import '../errors/failure.dart';

abstract class BaseRepository {
  Future<Result<T>> execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Result.success(result);
    } catch (e) {
      return Result.failure(Failure(e.toString()));
    }
  }
}
