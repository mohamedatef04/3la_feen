import 'dart:async';

import 'package:ala_feen/core/errors/failures.dart';
import 'package:ala_feen/features/chat/data/repos/chat_repo.dart';
import 'package:ala_feen/features/chat/presentation/cubits/chat_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepo extends Mock implements ChatRepo {}

void main() {
  const tripId = 'trip-1';
  const me = 'user-me';

  late MockChatRepo repo;
  late StreamController<ChatMessage> incoming;

  ChatMessage message(String id, String content, {bool isMe = false}) =>
      ChatMessage(
        id: id,
        senderId: isMe ? me : 'driver',
        content: content,
        createdAt: DateTime(2026, 1, 1),
        isMe: isMe,
      );

  List<String> contents(ChatState state) =>
      (state as ChatSuccess).messages.map((m) => m.content).toList();

  setUp(() {
    repo = MockChatRepo();
    incoming = StreamController<ChatMessage>.broadcast();
    when(() => repo.currentUserId).thenReturn(me);
    when(
      () => repo.watchNewMessages(tripId),
    ).thenAnswer((_) => incoming.stream);
    when(
      () => repo.fetchMessages(tripId),
    ).thenAnswer((_) async => Right([message('1', 'hello')]));
  });

  tearDown(() => incoming.close());

  group('getMessages', () {
    blocTest<ChatCubit, ChatState>(
      'emits [loading, success] with the stored messages',
      build: () => ChatCubit(repo),
      act: (cubit) => cubit.getMessages(tripId),
      expect: () => [
        ChatLoading(),
        isA<ChatSuccess>().having(contents, 'contents', ['hello']),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'emits [loading, failure] when the messages cannot be loaded',
      setUp: () => when(() => repo.fetchMessages(tripId)).thenAnswer(
        (_) async => Left(ServerFailure(errorMessage: 'No internet')),
      ),
      build: () => ChatCubit(repo),
      act: (cubit) => cubit.getMessages(tripId),
      expect: () => [
        ChatLoading(),
        const ChatFailure(errorMessage: 'No internet'),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'appends realtime messages and ignores duplicates',
      build: () => ChatCubit(repo),
      act: (cubit) async {
        await cubit.getMessages(tripId);
        incoming
          ..add(message('2', 'on my way'))
          ..add(message('2', 'on my way'));
        await Future<void>.delayed(Duration.zero);
      },
      skip: 2,
      expect: () => [
        isA<ChatSuccess>().having(contents, 'contents', ['hello', 'on my way']),
      ],
    );
  });

  group('sendMessage', () {
    blocTest<ChatCubit, ChatState>(
      'shows the message as pending, then replaces it with the saved one',
      setUp: () => when(
        () => repo.sendMessage(tripId: tripId, content: 'hi'),
      ).thenAnswer((_) async => Right(message('9', 'hi', isMe: true))),
      build: () => ChatCubit(repo),
      act: (cubit) async {
        await cubit.getMessages(tripId);
        await cubit.sendMessage(tripId: tripId, content: '  hi  ');
      },
      skip: 2,
      expect: () => [
        isA<ChatSuccess>().having(
          (s) => s.messages.last.isPending,
          'last is pending',
          true,
        ),
        isA<ChatSuccess>()
            .having(contents, 'contents', ['hello', 'hi'])
            .having((s) => s.messages.last.id, 'saved id', '9')
            .having((s) => s.messages.last.isPending, 'pending', false),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'does not duplicate a message that realtime delivered before the send finished',
      setUp: () =>
          when(
            () => repo.sendMessage(tripId: tripId, content: 'hi'),
          ).thenAnswer((_) async {
            incoming.add(message('9', 'hi', isMe: true));
            await Future<void>.delayed(Duration.zero);
            return Right(message('9', 'hi', isMe: true));
          }),
      build: () => ChatCubit(repo),
      act: (cubit) async {
        await cubit.getMessages(tripId);
        await cubit.sendMessage(tripId: tripId, content: 'hi');
      },
      verify: (cubit) => expect(contents(cubit.state), ['hello', 'hi']),
    );

    blocTest<ChatCubit, ChatState>(
      'removes the pending message and reports the error when sending fails',
      setUp: () => when(
        () => repo.sendMessage(tripId: tripId, content: 'hi'),
      ).thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Failed'))),
      build: () => ChatCubit(repo),
      act: (cubit) async {
        await cubit.getMessages(tripId);
        await cubit.sendMessage(tripId: tripId, content: 'hi');
      },
      skip: 3,
      expect: () => [
        isA<ChatSuccess>()
            .having(contents, 'contents', ['hello'])
            .having((s) => s.sendError, 'sendError', 'Failed'),
      ],
    );

    blocTest<ChatCubit, ChatState>(
      'ignores blank messages',
      build: () => ChatCubit(repo),
      act: (cubit) => cubit.sendMessage(tripId: tripId, content: '   '),
      expect: () => <ChatState>[],
      verify: (_) => verifyNever(
        () => repo.sendMessage(
          tripId: any(named: 'tripId'),
          content: any(named: 'content'),
        ),
      ),
    );
  });
}
