class PostingResult {
  final bool success;
  final int? journalId;
  final String? message;

  const PostingResult({required this.success, this.journalId, this.message});

  factory PostingResult.success(int journalId) {
    return PostingResult(success: true, journalId: journalId);
  }

  factory PostingResult.failure(String message) {
    return PostingResult(success: false, message: message);
  }
}
