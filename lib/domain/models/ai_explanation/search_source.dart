import 'package:equatable/equatable.dart';

class SearchSource extends Equatable {
  final String title;
  final String snippet;
  final String url;

  const SearchSource({
    required this.title,
    required this.snippet,
    required this.url,
  });

  SearchSource copyWith({String? title, String? snippet, String? url}) {
    return SearchSource(
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [title, snippet, url];

  @override
  bool get stringify => true;
}
