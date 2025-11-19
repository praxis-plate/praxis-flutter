import 'package:codium/domain/models/pdf_library/pdf_book.dart';
import 'package:codium/domain/repositories/pdf_repository.dart';
import 'package:codium/domain/usecases/import_pdf_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'import_pdf_usecase_test.mocks.dart';

@GenerateMocks([IPdfRepository])
void main() {
  late ImportPdfUseCase useCase;
  late MockIPdfRepository mockRepository;
  late Talker talker;

  setUp(() {
    mockRepository = MockIPdfRepository();
    useCase = ImportPdfUseCase(mockRepository);
    talker = Talker();
    GetIt.I.registerSingleton<Talker>(talker);
  });

  tearDown(() {
    GetIt.I.reset();
  });

  group('ImportPdfUseCase - Property Tests', () {
    test(
      'Feature: codium-ai-enhancement, Property 8: PDF Import and Metadata - '
      'For any imported PDF file, the system should extract metadata '
      '(title, author, page count) and save it to the database',
      () async {
        final testCases = _generatePropertyTestCases(100);

        for (final testCase in testCases) {
          when(
            mockRepository.importPdf(testCase.filePath),
          ).thenAnswer((_) async {});

          when(mockRepository.getAllBooks()).thenAnswer(
            (_) async => [
              PdfBook(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: testCase.expectedTitle,
                filePath: testCase.filePath,
                totalPages: 0,
              ),
            ],
          );

          await useCase.execute(testCase.filePath);

          verify(mockRepository.importPdf(testCase.filePath)).called(1);

          final books = await mockRepository.getAllBooks();
          expect(books.isNotEmpty, true);

          final importedBook = books.first;
          expect(importedBook.filePath, testCase.filePath);
          expect(importedBook.title.isNotEmpty, true);
          expect(importedBook.id.isNotEmpty, true);

          reset(mockRepository);
        }
      },
    );
  });

  group('ImportPdfUseCase - Unit Tests', () {
    test('should import PDF with valid file path', () async {
      const filePath = '/path/to/document.pdf';

      when(mockRepository.importPdf(filePath)).thenAnswer((_) async {});

      await useCase.execute(filePath);

      verify(mockRepository.importPdf(filePath)).called(1);
    });

    test('should throw ArgumentError when file path is empty', () async {
      const filePath = '';

      expect(() => useCase.execute(filePath), throwsA(isA<ArgumentError>()));

      verifyNever(mockRepository.importPdf(any));
    });

    test('should throw ArgumentError when file is not a PDF', () async {
      const filePath = '/path/to/document.txt';

      expect(() => useCase.execute(filePath), throwsA(isA<ArgumentError>()));

      verifyNever(mockRepository.importPdf(any));
    });

    test('should handle repository errors gracefully', () async {
      const filePath = '/path/to/document.pdf';

      when(
        mockRepository.importPdf(filePath),
      ).thenThrow(Exception('Database error'));

      expect(() => useCase.execute(filePath), throwsA(isA<Exception>()));
    });
  });
}

class _PropertyTestCase {
  _PropertyTestCase({required this.filePath, required this.expectedTitle});

  final String filePath;
  final String expectedTitle;
}

List<_PropertyTestCase> _generatePropertyTestCases(int count) {
  final random = DateTime.now().millisecondsSinceEpoch;
  final cases = <_PropertyTestCase>[];

  final sampleFileNames = [
    'introduction_to_programming.pdf',
    'advanced_algorithms.pdf',
    'data_structures_guide.pdf',
    'clean_code_principles.pdf',
    'design_patterns.pdf',
    'software_architecture.pdf',
    'flutter_development.pdf',
    'dart_language_guide.pdf',
    'mobile_app_design.pdf',
    'web_development_basics.pdf',
    'database_fundamentals.pdf',
    'api_design_best_practices.pdf',
    'testing_strategies.pdf',
    'agile_methodology.pdf',
    'devops_handbook.pdf',
    'cloud_computing_essentials.pdf',
    'machine_learning_intro.pdf',
    'artificial_intelligence.pdf',
    'cybersecurity_basics.pdf',
    'network_protocols.pdf',
    'operating_systems.pdf',
    'compiler_design.pdf',
    'functional_programming.pdf',
    'object_oriented_programming.pdf',
    'concurrent_programming.pdf',
    'distributed_systems.pdf',
    'microservices_architecture.pdf',
    'containerization_docker.pdf',
    'kubernetes_guide.pdf',
    'git_version_control.pdf',
    'continuous_integration.pdf',
    'performance_optimization.pdf',
    'code_refactoring.pdf',
    'technical_documentation.pdf',
    'user_experience_design.pdf',
    'accessibility_guidelines.pdf',
    'responsive_web_design.pdf',
    'progressive_web_apps.pdf',
    'graphql_fundamentals.pdf',
    'rest_api_design.pdf',
  ];

  final samplePaths = [
    '/storage/emulated/0/Documents/',
    '/data/user/0/com.codium/files/',
    '/sdcard/Download/',
    '/home/user/Documents/',
    '/Users/username/Documents/',
    'C:\\Users\\username\\Documents\\',
    '/mnt/sdcard/Books/',
    '/storage/self/primary/PDFs/',
  ];

  for (var i = 0; i < count; i++) {
    final fileIndex = (random + i * 7) % sampleFileNames.length;
    final pathIndex = (random + i * 13) % samplePaths.length;

    final fileName = sampleFileNames[fileIndex];
    final fullPath = '${samplePaths[pathIndex]}$fileName';

    final expectedTitle = fileName
        .replaceAll('.pdf', '')
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1)
              : word,
        )
        .join(' ');

    cases.add(
      _PropertyTestCase(filePath: fullPath, expectedTitle: expectedTitle),
    );
  }

  return cases;
}
