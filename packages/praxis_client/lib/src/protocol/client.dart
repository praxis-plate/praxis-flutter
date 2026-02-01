/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:praxis_client/src/protocol/dto/achievement_dto.dart' as _i3;
import 'package:praxis_client/src/protocol/responses/ai_response.dart' as _i4;
import 'package:praxis_client/src/protocol/requests/generate_hint_request.dart'
    as _i5;
import 'package:praxis_client/src/protocol/requests/generate_explanation_request.dart'
    as _i6;
import 'package:praxis_client/src/protocol/dto/course_dto.dart' as _i7;
import 'package:praxis_client/src/protocol/dto/course_detail_dto.dart' as _i8;
import 'package:praxis_client/src/protocol/dto/course_structure_dto.dart'
    as _i9;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i10;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i11;
import 'package:praxis_client/src/protocol/dto/lesson_dto.dart' as _i12;
import 'package:praxis_client/src/protocol/dto/lesson_completion_result_dto.dart'
    as _i13;
import 'package:praxis_client/src/protocol/requests/complete_lesson_session_request.dart'
    as _i14;
import 'package:praxis_client/src/protocol/dto/module_dto.dart' as _i15;
import 'package:praxis_client/src/protocol/dto/task_dto.dart' as _i16;
import 'package:praxis_client/src/protocol/dto/task_answer_result_dto.dart'
    as _i17;
import 'package:praxis_client/src/protocol/dto/user_statistics_dto.dart'
    as _i18;
import 'package:praxis_client/src/protocol/dto/wallet_balance_dto.dart' as _i19;
import 'package:praxis_client/src/protocol/dto/coin_transaction_dto.dart'
    as _i20;
import 'package:praxis_client/src/protocol/requests/create_coin_transaction_request.dart'
    as _i21;
import 'protocol.dart' as _i22;

/// {@category Endpoint}
class EndpointAchievement extends _i1.EndpointRef {
  EndpointAchievement(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'achievement';

  _i2.Future<List<_i3.AchievementDto>> getAll() =>
      caller.callServerEndpoint<List<_i3.AchievementDto>>(
        'achievement',
        'getAll',
        {},
      );

  _i2.Future<List<_i3.AchievementDto>> getUserAchievements() =>
      caller.callServerEndpoint<List<_i3.AchievementDto>>(
        'achievement',
        'getUserAchievements',
        {},
      );

  _i2.Future<void> unlock(int achievementId) => caller.callServerEndpoint<void>(
    'achievement',
    'unlock',
    {'achievementId': achievementId},
  );

  _i2.Future<bool> isUnlocked(int achievementId) =>
      caller.callServerEndpoint<bool>('achievement', 'isUnlocked', {
        'achievementId': achievementId,
      });
}

/// {@category Endpoint}
class EndpointAi extends _i1.EndpointRef {
  EndpointAi(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ai';

  _i2.Future<_i4.AiResponse> generateHint(_i5.GenerateHintRequest request) =>
      caller.callServerEndpoint<_i4.AiResponse>('ai', 'generateHint', {
        'request': request,
      });

  _i2.Future<_i4.AiResponse> generateExplanation(
    _i6.GenerateExplanationRequest request,
  ) => caller.callServerEndpoint<_i4.AiResponse>('ai', 'generateExplanation', {
    'request': request,
  });
}

/// {@category Endpoint}
class EndpointCourse extends _i1.EndpointRef {
  EndpointCourse(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'course';

  _i2.Future<List<_i7.CourseDto>> get({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i7.CourseDto>>('course', 'get', {
    'limit': limit,
    'offset': offset,
  });

  _i2.Future<_i8.CourseDetailDto> getById(int courseId) =>
      caller.callServerEndpoint<_i8.CourseDetailDto>('course', 'getById', {
        'courseId': courseId,
      });

  _i2.Future<List<_i7.CourseDto>> getEnrolled() => caller
      .callServerEndpoint<List<_i7.CourseDto>>('course', 'getEnrolled', {});

  _i2.Future<void> enroll(int courseId) => caller.callServerEndpoint<void>(
    'course',
    'enroll',
    {'courseId': courseId},
  );

  _i2.Future<void> unenroll(int courseId) => caller.callServerEndpoint<void>(
    'course',
    'unenroll',
    {'courseId': courseId},
  );

  _i2.Future<_i9.CourseStructureDto> getTableOfContents(int courseId) =>
      caller.callServerEndpoint<_i9.CourseStructureDto>(
        'course',
        'getTableOfContents',
        {'courseId': courseId},
      );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i10.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i11.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i11.AuthSuccess>('emailIdp', 'login', {
    'email': email,
    'password': password,
  });

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<String>('emailIdp', 'verifyRegistrationCode', {
        'accountRequestId': accountRequestId,
        'verificationCode': verificationCode,
      });

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i11.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i11.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {'registrationToken': registrationToken, 'password': password},
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) =>
      caller.callServerEndpoint<String>('emailIdp', 'verifyPasswordResetCode', {
        'passwordResetRequestId': passwordResetRequestId,
        'verificationCode': verificationCode,
      });

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>('emailIdp', 'finishPasswordReset', {
    'finishPasswordResetToken': finishPasswordResetToken,
    'newPassword': newPassword,
  });
}

/// {@category Endpoint}
class EndpointHealth extends _i1.EndpointRef {
  EndpointHealth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'health';

  _i2.Future<String> ping() =>
      caller.callServerEndpoint<String>('health', 'ping', {});
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i11.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i11.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i11.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointLesson extends _i1.EndpointRef {
  EndpointLesson(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'lesson';

  _i2.Future<List<_i12.LessonDto>> getByCourseId(int courseId) =>
      caller.callServerEndpoint<List<_i12.LessonDto>>(
        'lesson',
        'getByCourseId',
        {'courseId': courseId},
      );

  _i2.Future<List<_i12.LessonDto>> getByModuleId(int moduleId) =>
      caller.callServerEndpoint<List<_i12.LessonDto>>(
        'lesson',
        'getByModuleId',
        {'moduleId': moduleId},
      );

  _i2.Future<_i12.LessonDto> getById(int lessonId) =>
      caller.callServerEndpoint<_i12.LessonDto>('lesson', 'getById', {
        'lessonId': lessonId,
      });

  _i2.Future<void> markComplete(
    int lessonId, {
    required int timeSpentSeconds,
  }) => caller.callServerEndpoint<void>('lesson', 'markComplete', {
    'lessonId': lessonId,
    'timeSpentSeconds': timeSpentSeconds,
  });

  _i2.Future<_i13.LessonCompletionResultDto> complete(
    _i14.CompleteLessonSessionRequest request,
  ) => caller.callServerEndpoint<_i13.LessonCompletionResultDto>(
    'lesson',
    'complete',
    {'request': request},
  );
}

/// {@category Endpoint}
class EndpointModule extends _i1.EndpointRef {
  EndpointModule(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'module';

  _i2.Future<List<_i15.ModuleDto>> get(int courseId) =>
      caller.callServerEndpoint<List<_i15.ModuleDto>>('module', 'get', {
        'courseId': courseId,
      });
}

/// {@category Endpoint}
class EndpointTask extends _i1.EndpointRef {
  EndpointTask(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'task';

  _i2.Future<_i16.TaskDto> getById(int taskId) => caller
      .callServerEndpoint<_i16.TaskDto>('task', 'getById', {'taskId': taskId});

  _i2.Future<List<_i16.TaskDto>> getByLessonId(int lessonId) =>
      caller.callServerEndpoint<List<_i16.TaskDto>>('task', 'getByLessonId', {
        'lessonId': lessonId,
      });

  _i2.Future<_i17.TaskAnswerResultDto> answer(int taskId, String userAnswer) =>
      caller.callServerEndpoint<_i17.TaskAnswerResultDto>('task', 'answer', {
        'taskId': taskId,
        'userAnswer': userAnswer,
      });
}

/// User statistics endpoint for managing learning progress and achievements
/// {@category Endpoint}
class EndpointUserStatistics extends _i1.EndpointRef {
  EndpointUserStatistics(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userStatistics';

  /// Gets user statistics for authenticated user
  ///
  /// Returns user learning statistics including:
  /// - experiencePoints: Total experience points earned
  /// - currentStreak: Current consecutive days of activity
  /// - maxStreak: Maximum consecutive days achieved
  /// - lastActiveDate: Last date of user activity
  ///
  /// Always returns statistics, creates empty statistics for first-time users
  ///
  /// Throws [NotAuthorizedException] if user is not authenticated
  _i2.Future<_i18.UserStatisticsDto> get() => caller
      .callServerEndpoint<_i18.UserStatisticsDto>('userStatistics', 'get', {});
}

/// Wallet endpoint for managing user coin balances and transactions
/// {@category Endpoint}
class EndpointWallet extends _i1.EndpointRef {
  EndpointWallet(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wallet';

  /// Gets the current wallet balance for authenticated user
  ///
  /// Returns wallet information including:
  /// - balance: Total coins owned
  /// - available: Coins available for spending
  /// - held: Coins temporarily held
  /// - currency: Always 'COIN'
  ///
  /// Throws [NotAuthorizedException] if user is not authenticated
  _i2.Future<_i19.WalletBalanceDto> getBalance() => caller
      .callServerEndpoint<_i19.WalletBalanceDto>('wallet', 'getBalance', {});

  /// Adds coins to user wallet (INTERNAL USE ONLY)
  ///
  /// WARNING: This method immediately adds coins without payment verification.
  /// Suitable only for:
  /// - Admin operations (manual coin grants)
  /// - Testing and development
  /// - Internal system transfers
  ///
  /// For real user payments, implement external payment provider integration.
  ///
  /// Parameters:
  /// - [request]: Transaction details including amount, currency, and transaction key
  ///
  /// Returns the created transaction record
  ///
  /// Throws:
  /// - [NotAuthorizedException] if user is not authenticated
  /// - [ValidationException] if request validation fails
  /// - [ValidationException] if transaction key already exists with different parameters
  _i2.Future<_i20.CoinTransactionDto> topUp(
    _i21.CreateCoinTransactionRequest request,
  ) => caller.callServerEndpoint<_i20.CoinTransactionDto>('wallet', 'topUp', {
    'request': request,
  });

  /// Purchases courses or items using available coins
  ///
  /// Deducts coins from user's available balance to purchase courses or other items.
  /// Ensures sufficient balance before processing the transaction.
  ///
  /// Parameters:
  /// - [request]: Transaction details including amount, currency, transaction key, and optional relatedEntityId
  ///
  /// Returns the created transaction record
  ///
  /// Throws:
  /// - [NotAuthorizedException] if user is not authenticated
  /// - [ValidationException] if insufficient available balance
  /// - [ValidationException] if request validation fails
  /// - [ValidationException] if transaction key already exists with different parameters
  _i2.Future<_i20.CoinTransactionDto> buy(
    _i21.CreateCoinTransactionRequest request,
  ) => caller.callServerEndpoint<_i20.CoinTransactionDto>('wallet', 'buy', {
    'request': request,
  });

  /// Gets transaction history for authenticated user with pagination
  ///
  /// Returns list of transactions ordered by creation date (newest first).
  /// Supports pagination through limit and offset parameters.
  ///
  /// Parameters:
  /// - [limit]: Maximum number of transactions to return (optional)
  /// - [offset]: Number of transactions to skip for pagination (optional)
  ///
  /// Returns list of transaction DTOs containing:
  /// - Transaction details (amount, type, status)
  /// - Timestamps and metadata
  /// - Related entity information if applicable
  ///
  /// Throws [NotAuthorizedException] if user is not authenticated
  _i2.Future<List<_i20.CoinTransactionDto>> getHistory({
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i20.CoinTransactionDto>>(
    'wallet',
    'getHistory',
    {'limit': limit, 'offset': offset},
  );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i10.Caller(client);
    serverpod_auth_core = _i11.Caller(client);
  }

  late final _i10.Caller serverpod_auth_idp;

  late final _i11.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(_i1.MethodCallContext, Object, StackTrace)? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i22.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    achievement = EndpointAchievement(this);
    ai = EndpointAi(this);
    course = EndpointCourse(this);
    emailIdp = EndpointEmailIdp(this);
    health = EndpointHealth(this);
    jwtRefresh = EndpointJwtRefresh(this);
    lesson = EndpointLesson(this);
    module = EndpointModule(this);
    task = EndpointTask(this);
    userStatistics = EndpointUserStatistics(this);
    wallet = EndpointWallet(this);
    modules = Modules(this);
  }

  late final EndpointAchievement achievement;

  late final EndpointAi ai;

  late final EndpointCourse course;

  late final EndpointEmailIdp emailIdp;

  late final EndpointHealth health;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointLesson lesson;

  late final EndpointModule module;

  late final EndpointTask task;

  late final EndpointUserStatistics userStatistics;

  late final EndpointWallet wallet;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'achievement': achievement,
    'ai': ai,
    'course': course,
    'emailIdp': emailIdp,
    'health': health,
    'jwtRefresh': jwtRefresh,
    'lesson': lesson,
    'module': module,
    'task': task,
    'userStatistics': userStatistics,
    'wallet': wallet,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
