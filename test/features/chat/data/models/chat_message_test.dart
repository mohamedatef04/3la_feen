import 'package:ala_feen/features/chat/data/models/chat_message.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChatMessage.fromJson', () {
    test('marks messages from the signed-in user as mine', () {
      final message = ChatMessage.fromJson(const {
        'id': 7,
        'sender_id': 'user-1',
        'content': 'hi',
        'created_at': '2026-01-01T10:00:00Z',
      }, currentUserId: 'user-1');

      expect(message.id, '7');
      expect(message.isMe, isTrue);
      expect(message.isPending, isFalse);
      expect(message.createdAt.toUtc(), DateTime.utc(2026, 1, 1, 10));
    });

    test('marks messages from someone else as not mine', () {
      final message = ChatMessage.fromJson(const {
        'id': '8',
        'sender_id': 'driver',
        'content': 'on my way',
        'created_at': '2026-01-01T10:00:00Z',
      }, currentUserId: 'user-1');

      expect(message.isMe, isFalse);
    });

    test('is not mine when nobody is signed in', () {
      final message = ChatMessage.fromJson(const {
        'id': '9',
        'sender_id': '',
        'content': 'x',
      }, currentUserId: null);

      expect(message.isMe, isFalse);
    });

    test('does not throw on a missing or invalid created_at', () {
      expect(
        () => ChatMessage.fromJson(const {
          'id': '1',
          'created_at': 'not a date',
        }, currentUserId: null),
        returnsNormally,
      );
    });
  });
}
