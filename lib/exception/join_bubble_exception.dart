/// Exception for failing to join a bubble.
class JoinBubbleException implements Exception {
  /// Error message.
  final String message;

  /// Exception for failing to join a bubble.
  const JoinBubbleException([this.message = '']);
}
