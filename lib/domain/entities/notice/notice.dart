// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notice {
  String useYn;
  String title;
  String content;

  Notice({
    required this.useYn,
    required this.title,
    required this.content,
  });

  Notice copyWith({
    String? useYn,
    String? title,
    String? content,
  }) {
    return Notice(
      useYn: useYn ?? this.useYn,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  String toString() =>
      'Notice(useYn: $useYn, title: $title, content: $content)';
}
