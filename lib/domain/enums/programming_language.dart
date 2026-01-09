enum ProgrammingLanguage { dart, python, javascript }

extension ProgrammingLanguageExtension on ProgrammingLanguage {
  String get displayName {
    return switch (this) {
      ProgrammingLanguage.dart => 'Dart',
      ProgrammingLanguage.python => 'Python',
      ProgrammingLanguage.javascript => 'JavaScript',
    };
  }
}
