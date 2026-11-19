import 'package:ala_feen/core/errors/custom_exeption.dart';
import 'package:ala_feen/core/errors/error_handler.dart';
import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/chat/data/data_source/chat_data_source.dart';
import 'package:ala_feen/features/chat/data/models/chat_message.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepo {
  String? get currentUserId;
  Future<Either<Failures, List<ChatMessage>>> fetchMessages(String tripId);
  Stream<ChatMessage> watchNewMessages(String tripId);
  Future<Either<Failures, ChatMessage>> sendMessage({
    required String tripId,
    required String content,
  });
}

class ChatRepoImpl implements ChatRepo {
  ChatRepoImpl(this._dataSource);

  final ChatDataSource _dataSource;

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  Future<Either<Failures, List<ChatMessage>>> fetchMessages(String tripId) =>
      _guard(() => _dataSource.fetchMessages(tripId));

  @override
  Stream<ChatMessage> watchNewMessages(String tripId) =>
      _dataSource.watchNewMessages(tripId);

  @override
  Future<Either<Failures, ChatMessage>> sendMessage({
    required String tripId,
    required String content,
  }) => _guard(
    () => _dataSource.sendMessage(tripId: tripId, content: content),
  );

  Future<Either<Failures, T>> _guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on CustomExeption catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage));
    } catch (e) {
      return Left(ServerFailure(errorMessage: ErrorHandler.getMessage(e)));
    }
  }
}
