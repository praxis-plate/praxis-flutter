import 'package:codium/domain/models/ai_explanation/search_source.dart';

abstract interface class ISearchDataSource {
  Future<List<SearchSource>> searchWeb(String query);
}
