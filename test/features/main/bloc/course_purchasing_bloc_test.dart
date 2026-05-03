import 'package:bloc_test/bloc_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:praxis/core/error/app_error_code.dart';
import 'package:praxis/core/error/failure.dart';
import 'package:praxis/core/utils/result.dart';
import 'package:praxis/domain/models/course/course_model.dart';
import 'package:praxis/domain/models/course/course_pricing.dart';
import 'package:praxis/domain/models/course/course_statistics.dart';
import 'package:praxis/domain/models/user/money.dart';
import 'package:praxis/domain/models/user/user_statistic_model.dart';
import 'package:praxis/domain/usecases/usecases.dart';
import 'package:praxis/features/main/bloc/course_purchasing/course_purchasing.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockPurchaseCourseUseCase extends Mock
    implements PurchaseCourseUseCase {}

class _MockGetCourseDetailUseCase extends Mock
    implements GetCourseDetailUseCase {}

class _MockGetUserStatisticsUseCase extends Mock
    implements GetUserStatisticsUseCase {}

void main() {
  late _MockPurchaseCourseUseCase purchaseCourseUseCase;
  late _MockGetCourseDetailUseCase getCourseDetailUseCase;
  late _MockGetUserStatisticsUseCase getUserStatisticsUseCase;

  setUpAll(() {
    if (!GetIt.I.isRegistered<Talker>()) {
      GetIt.I.registerSingleton<Talker>(Talker());
    }
  });

  setUp(() {
    purchaseCourseUseCase = _MockPurchaseCourseUseCase();
    getCourseDetailUseCase = _MockGetCourseDetailUseCase();
    getUserStatisticsUseCase = _MockGetUserStatisticsUseCase();
  });

  CoursePurchasingBloc buildBloc() {
    return CoursePurchasingBloc(
      purchaseCourseUseCase: purchaseCourseUseCase,
      getCourseDetailUseCase: getCourseDetailUseCase,
      getUserStatisticsUseCase: getUserStatisticsUseCase,
    );
  }

  blocTest<CoursePurchasingBloc, CoursePurchasingState>(
    'emits insufficient balance with course price and user balance',
    setUp: () {
      when(
        () => purchaseCourseUseCase('user-1', 1),
      ).thenAnswer((_) async => const Failure<void>(_insufficientBalance));
      when(
        () => getCourseDetailUseCase(1),
      ).thenAnswer((_) async => Success(_course));
      when(
        () => getUserStatisticsUseCase('user-1'),
      ).thenAnswer((_) async => Success(_statistics));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const CoursePurchasingRequestEvent(userId: 'user-1', courseId: 1),
    ),
    expect: () => const [
      CoursePurchasingLoadingState(1),
      CoursePurchasingInsufficientBalanceState(
        1,
        requiredMoney: 120,
        availableMoney: 35,
      ),
    ],
  );

  blocTest<CoursePurchasingBloc, CoursePurchasingState>(
    'emits unavailable error when course data cannot be loaded',
    setUp: () {
      when(
        () => purchaseCourseUseCase('user-1', 1),
      ).thenAnswer((_) async => const Failure<void>(_insufficientBalance));
      when(
        () => getCourseDetailUseCase(1),
      ).thenAnswer((_) async => const Failure<CourseModel>(_notFound));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const CoursePurchasingRequestEvent(userId: 'user-1', courseId: 1),
    ),
    expect: () => const [
      CoursePurchasingLoadingState(1),
      CoursePurchasingLoadErrorState(1, _purchaseUnavailable),
    ],
  );

  blocTest<CoursePurchasingBloc, CoursePurchasingState>(
    'emits unavailable error when user statistics cannot be loaded',
    setUp: () {
      when(
        () => purchaseCourseUseCase('user-1', 1),
      ).thenAnswer((_) async => const Failure<void>(_insufficientBalance));
      when(
        () => getCourseDetailUseCase(1),
      ).thenAnswer((_) async => Success(_course));
      when(
        () => getUserStatisticsUseCase('user-1'),
      ).thenAnswer((_) async => const Success<UserStatisticModel?>(null));
    },
    build: buildBloc,
    act: (bloc) => bloc.add(
      const CoursePurchasingRequestEvent(userId: 'user-1', courseId: 1),
    ),
    expect: () => const [
      CoursePurchasingLoadingState(1),
      CoursePurchasingLoadErrorState(1, _purchaseUnavailable),
    ],
  );
}

const _insufficientBalance = AppFailure(
  code: AppErrorCode.insufficientBalance,
  message: 'Insufficient balance',
);

const _notFound = AppFailure(
  code: AppErrorCode.apiNotFound,
  message: 'Course not found',
);

const _purchaseUnavailable = AppFailure(
  code: AppErrorCode.coursePurchaseUnavailable,
  message: 'Course purchase is unavailable',
  canRetry: true,
);

final _course = CourseModel(
  id: 1,
  title: 'Course',
  description: 'Description',
  author: 'Author',
  category: 'Category',
  priceInCoins: 120,
  durationMinutes: 60,
  rating: 4.5,
  createdAt: DateTime(2026, 5, 3),
  pricing: CoursePricing(price: const Money(amount: 120)),
  statistics: const CourseStatistics(
    averageRating: 4.5,
    totalEnrollments: 10,
    completionRate: 0.5,
  ),
);

final _statistics = UserStatisticModel(
  id: 1,
  userId: 'user-1',
  currentStreak: 0,
  maxStreak: 0,
  balance: const Money(amount: 35),
  experiencePoints: 0,
  lastActiveDate: DateTime(2026, 5, 3),
);
