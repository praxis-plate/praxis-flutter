import 'package:equatable/equatable.dart';

class SearchSource extends Equatable {
  const SearchSource({
    required this.title,
    required this.snippet,
    required this.url,
  });

  final String title;
  final String snippet;
  final String url;

  SearchSource copyWith({String? title, String? snippet, String? url}) {
    return SearchSource(
      title: title ?? this.title,
      snippet: snippet ?? this.snippet,
      url: url ?? this.url,
    );
  }

  factory SearchSource.fromJson(Map<String, dynamic> json) {
    return SearchSource(
      title: json['title'],
      snippet: json['snippet'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'snippet': snippet, 'url': url};
  }

  @override
  bool? get stringify => true;

  @override
  List<Object> get props => [title, snippet, url];
}
