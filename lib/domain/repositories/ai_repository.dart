import 'package:codium/domain/models/ai_explanation/search_source.dart';

abstract interface class IAiRepository {
  Future<String> explainText({required String text, required String context});

  Future<List<SearchSource>> searchWeb(String query);
}
