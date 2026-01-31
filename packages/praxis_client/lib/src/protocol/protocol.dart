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
import 'dto/achievement_dto.dart' as _i2;
import 'dto/coin_transaction_dto.dart' as _i3;
import 'dto/course_detail_dto.dart' as _i4;
import 'dto/course_dto.dart' as _i5;
import 'dto/course_structure_dto.dart' as _i6;
import 'dto/course_structure_lesson_dto.dart' as _i7;
import 'dto/course_structure_module_dto.dart' as _i8;
import 'dto/course_structure_task_dto.dart' as _i9;
import 'dto/lesson_completion_result_dto.dart' as _i10;
import 'dto/lesson_dto.dart' as _i11;
import 'dto/module_dto.dart' as _i12;
import 'dto/task_dto.dart' as _i13;
import 'dto/task_option_dto.dart' as _i14;
import 'dto/task_test_case_dto.dart' as _i15;
import 'dto/user_statistics_dto.dart' as _i16;
import 'dto/wallet_balance_dto.dart' as _i17;
import 'enums/coin_transaction_type.dart' as _i18;
import 'enums/task_type.dart' as _i19;
import 'exceptions/not_found_exception.dart' as _i20;
import 'exceptions/validation_exception.dart' as _i21;
import 'requests/complete_lesson_session_request.dart' as _i22;
import 'requests/create_coin_transaction_request.dart' as _i23;
import 'requests/generate_explanation_request.dart' as _i24;
import 'requests/generate_hint_request.dart' as _i25;
import 'responses/ai_response.dart' as _i26;
import 'tables/user_wallet_table.dart' as _i27;
import 'package:praxis_client/src/protocol/dto/achievement_dto.dart' as _i28;
import 'package:praxis_client/src/protocol/dto/course_dto.dart' as _i29;
import 'package:praxis_client/src/protocol/dto/lesson_dto.dart' as _i30;
import 'package:praxis_client/src/protocol/dto/module_dto.dart' as _i31;
import 'package:praxis_client/src/protocol/dto/task_dto.dart' as _i32;
import 'package:praxis_client/src/protocol/dto/coin_transaction_dto.dart'
    as _i33;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i34;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i35;
export 'dto/achievement_dto.dart';
export 'dto/coin_transaction_dto.dart';
export 'dto/course_detail_dto.dart';
export 'dto/course_dto.dart';
export 'dto/course_structure_dto.dart';
export 'dto/course_structure_lesson_dto.dart';
export 'dto/course_structure_module_dto.dart';
export 'dto/course_structure_task_dto.dart';
export 'dto/lesson_completion_result_dto.dart';
export 'dto/lesson_dto.dart';
export 'dto/module_dto.dart';
export 'dto/task_dto.dart';
export 'dto/task_option_dto.dart';
export 'dto/task_test_case_dto.dart';
export 'dto/user_statistics_dto.dart';
export 'dto/wallet_balance_dto.dart';
export 'enums/coin_transaction_type.dart';
export 'enums/task_type.dart';
export 'exceptions/not_found_exception.dart';
export 'exceptions/validation_exception.dart';
export 'requests/complete_lesson_session_request.dart';
export 'requests/create_coin_transaction_request.dart';
export 'requests/generate_explanation_request.dart';
export 'requests/generate_hint_request.dart';
export 'responses/ai_response.dart';
export 'tables/user_wallet_table.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.AchievementDto) {
      return _i2.AchievementDto.fromJson(data) as T;
    }
    if (t == _i3.CoinTransactionDto) {
      return _i3.CoinTransactionDto.fromJson(data) as T;
    }
    if (t == _i4.CourseDetailDto) {
      return _i4.CourseDetailDto.fromJson(data) as T;
    }
    if (t == _i5.CourseDto) {
      return _i5.CourseDto.fromJson(data) as T;
    }
    if (t == _i6.CourseStructureDto) {
      return _i6.CourseStructureDto.fromJson(data) as T;
    }
    if (t == _i7.CourseStructureLessonDto) {
      return _i7.CourseStructureLessonDto.fromJson(data) as T;
    }
    if (t == _i8.CourseStructureModuleDto) {
      return _i8.CourseStructureModuleDto.fromJson(data) as T;
    }
    if (t == _i9.CourseStructureTaskDto) {
      return _i9.CourseStructureTaskDto.fromJson(data) as T;
    }
    if (t == _i10.LessonCompletionResultDto) {
      return _i10.LessonCompletionResultDto.fromJson(data) as T;
    }
    if (t == _i11.LessonDto) {
      return _i11.LessonDto.fromJson(data) as T;
    }
    if (t == _i12.ModuleDto) {
      return _i12.ModuleDto.fromJson(data) as T;
    }
    if (t == _i13.TaskDto) {
      return _i13.TaskDto.fromJson(data) as T;
    }
    if (t == _i14.TaskOptionDto) {
      return _i14.TaskOptionDto.fromJson(data) as T;
    }
    if (t == _i15.TaskTestCaseDto) {
      return _i15.TaskTestCaseDto.fromJson(data) as T;
    }
    if (t == _i16.UserStatisticsDto) {
      return _i16.UserStatisticsDto.fromJson(data) as T;
    }
    if (t == _i17.WalletBalanceDto) {
      return _i17.WalletBalanceDto.fromJson(data) as T;
    }
    if (t == _i18.CoinTransactionType) {
      return _i18.CoinTransactionType.fromJson(data) as T;
    }
    if (t == _i19.TaskType) {
      return _i19.TaskType.fromJson(data) as T;
    }
    if (t == _i20.NotFoundException) {
      return _i20.NotFoundException.fromJson(data) as T;
    }
    if (t == _i21.ValidationException) {
      return _i21.ValidationException.fromJson(data) as T;
    }
    if (t == _i22.CompleteLessonSessionRequest) {
      return _i22.CompleteLessonSessionRequest.fromJson(data) as T;
    }
    if (t == _i23.CreateCoinTransactionRequest) {
      return _i23.CreateCoinTransactionRequest.fromJson(data) as T;
    }
    if (t == _i24.GenerateExplanationRequest) {
      return _i24.GenerateExplanationRequest.fromJson(data) as T;
    }
    if (t == _i25.GenerateHintRequest) {
      return _i25.GenerateHintRequest.fromJson(data) as T;
    }
    if (t == _i26.AiResponse) {
      return _i26.AiResponse.fromJson(data) as T;
    }
    if (t == _i27.UserWallet) {
      return _i27.UserWallet.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AchievementDto?>()) {
      return (data != null ? _i2.AchievementDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CoinTransactionDto?>()) {
      return (data != null ? _i3.CoinTransactionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CourseDetailDto?>()) {
      return (data != null ? _i4.CourseDetailDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CourseDto?>()) {
      return (data != null ? _i5.CourseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CourseStructureDto?>()) {
      return (data != null ? _i6.CourseStructureDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CourseStructureLessonDto?>()) {
      return (data != null ? _i7.CourseStructureLessonDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.CourseStructureModuleDto?>()) {
      return (data != null ? _i8.CourseStructureModuleDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.CourseStructureTaskDto?>()) {
      return (data != null ? _i9.CourseStructureTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.LessonCompletionResultDto?>()) {
      return (data != null
              ? _i10.LessonCompletionResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.LessonDto?>()) {
      return (data != null ? _i11.LessonDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.ModuleDto?>()) {
      return (data != null ? _i12.ModuleDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.TaskDto?>()) {
      return (data != null ? _i13.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.TaskOptionDto?>()) {
      return (data != null ? _i14.TaskOptionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.TaskTestCaseDto?>()) {
      return (data != null ? _i15.TaskTestCaseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserStatisticsDto?>()) {
      return (data != null ? _i16.UserStatisticsDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.WalletBalanceDto?>()) {
      return (data != null ? _i17.WalletBalanceDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CoinTransactionType?>()) {
      return (data != null ? _i18.CoinTransactionType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.TaskType?>()) {
      return (data != null ? _i19.TaskType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.NotFoundException?>()) {
      return (data != null ? _i20.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ValidationException?>()) {
      return (data != null ? _i21.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.CompleteLessonSessionRequest?>()) {
      return (data != null
              ? _i22.CompleteLessonSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i23.CreateCoinTransactionRequest?>()) {
      return (data != null
              ? _i23.CreateCoinTransactionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i24.GenerateExplanationRequest?>()) {
      return (data != null
              ? _i24.GenerateExplanationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.GenerateHintRequest?>()) {
      return (data != null ? _i25.GenerateHintRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.AiResponse?>()) {
      return (data != null ? _i26.AiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.UserWallet?>()) {
      return (data != null ? _i27.UserWallet.fromJson(data) : null) as T;
    }
    if (t == List<_i12.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i12.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i11.LessonDto>) {
      return (data as List).map((e) => deserialize<_i11.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i13.TaskDto>) {
      return (data as List).map((e) => deserialize<_i13.TaskDto>(e)).toList()
          as T;
    }
    if (t == List<_i8.CourseStructureModuleDto>) {
      return (data as List)
              .map((e) => deserialize<_i8.CourseStructureModuleDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i9.CourseStructureTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i9.CourseStructureTaskDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i7.CourseStructureLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i7.CourseStructureLessonDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i2.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i2.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i14.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i15.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i15.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i28.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.CourseDto>) {
      return (data as List).map((e) => deserialize<_i29.CourseDto>(e)).toList()
          as T;
    }
    if (t == List<_i30.LessonDto>) {
      return (data as List).map((e) => deserialize<_i30.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i31.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i31.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i32.TaskDto>) {
      return (data as List).map((e) => deserialize<_i32.TaskDto>(e)).toList()
          as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == List<_i33.CoinTransactionDto>) {
      return (data as List)
              .map((e) => deserialize<_i33.CoinTransactionDto>(e))
              .toList()
          as T;
    }
    try {
      return _i34.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i35.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AchievementDto => 'AchievementDto',
      _i3.CoinTransactionDto => 'CoinTransactionDto',
      _i4.CourseDetailDto => 'CourseDetailDto',
      _i5.CourseDto => 'CourseDto',
      _i6.CourseStructureDto => 'CourseStructureDto',
      _i7.CourseStructureLessonDto => 'CourseStructureLessonDto',
      _i8.CourseStructureModuleDto => 'CourseStructureModuleDto',
      _i9.CourseStructureTaskDto => 'CourseStructureTaskDto',
      _i10.LessonCompletionResultDto => 'LessonCompletionResultDto',
      _i11.LessonDto => 'LessonDto',
      _i12.ModuleDto => 'ModuleDto',
      _i13.TaskDto => 'TaskDto',
      _i14.TaskOptionDto => 'TaskOptionDto',
      _i15.TaskTestCaseDto => 'TaskTestCaseDto',
      _i16.UserStatisticsDto => 'UserStatisticsDto',
      _i17.WalletBalanceDto => 'WalletBalanceDto',
      _i18.CoinTransactionType => 'CoinTransactionType',
      _i19.TaskType => 'TaskType',
      _i20.NotFoundException => 'NotFoundException',
      _i21.ValidationException => 'ValidationException',
      _i22.CompleteLessonSessionRequest => 'CompleteLessonSessionRequest',
      _i23.CreateCoinTransactionRequest => 'CreateCoinTransactionRequest',
      _i24.GenerateExplanationRequest => 'GenerateExplanationRequest',
      _i25.GenerateHintRequest => 'GenerateHintRequest',
      _i26.AiResponse => 'AiResponse',
      _i27.UserWallet => 'UserWallet',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('praxis.', '');
    }

    switch (data) {
      case _i2.AchievementDto():
        return 'AchievementDto';
      case _i3.CoinTransactionDto():
        return 'CoinTransactionDto';
      case _i4.CourseDetailDto():
        return 'CourseDetailDto';
      case _i5.CourseDto():
        return 'CourseDto';
      case _i6.CourseStructureDto():
        return 'CourseStructureDto';
      case _i7.CourseStructureLessonDto():
        return 'CourseStructureLessonDto';
      case _i8.CourseStructureModuleDto():
        return 'CourseStructureModuleDto';
      case _i9.CourseStructureTaskDto():
        return 'CourseStructureTaskDto';
      case _i10.LessonCompletionResultDto():
        return 'LessonCompletionResultDto';
      case _i11.LessonDto():
        return 'LessonDto';
      case _i12.ModuleDto():
        return 'ModuleDto';
      case _i13.TaskDto():
        return 'TaskDto';
      case _i14.TaskOptionDto():
        return 'TaskOptionDto';
      case _i15.TaskTestCaseDto():
        return 'TaskTestCaseDto';
      case _i16.UserStatisticsDto():
        return 'UserStatisticsDto';
      case _i17.WalletBalanceDto():
        return 'WalletBalanceDto';
      case _i18.CoinTransactionType():
        return 'CoinTransactionType';
      case _i19.TaskType():
        return 'TaskType';
      case _i20.NotFoundException():
        return 'NotFoundException';
      case _i21.ValidationException():
        return 'ValidationException';
      case _i22.CompleteLessonSessionRequest():
        return 'CompleteLessonSessionRequest';
      case _i23.CreateCoinTransactionRequest():
        return 'CreateCoinTransactionRequest';
      case _i24.GenerateExplanationRequest():
        return 'GenerateExplanationRequest';
      case _i25.GenerateHintRequest():
        return 'GenerateHintRequest';
      case _i26.AiResponse():
        return 'AiResponse';
      case _i27.UserWallet():
        return 'UserWallet';
    }
    className = _i34.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i35.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AchievementDto') {
      return deserialize<_i2.AchievementDto>(data['data']);
    }
    if (dataClassName == 'CoinTransactionDto') {
      return deserialize<_i3.CoinTransactionDto>(data['data']);
    }
    if (dataClassName == 'CourseDetailDto') {
      return deserialize<_i4.CourseDetailDto>(data['data']);
    }
    if (dataClassName == 'CourseDto') {
      return deserialize<_i5.CourseDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureDto') {
      return deserialize<_i6.CourseStructureDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureLessonDto') {
      return deserialize<_i7.CourseStructureLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureModuleDto') {
      return deserialize<_i8.CourseStructureModuleDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureTaskDto') {
      return deserialize<_i9.CourseStructureTaskDto>(data['data']);
    }
    if (dataClassName == 'LessonCompletionResultDto') {
      return deserialize<_i10.LessonCompletionResultDto>(data['data']);
    }
    if (dataClassName == 'LessonDto') {
      return deserialize<_i11.LessonDto>(data['data']);
    }
    if (dataClassName == 'ModuleDto') {
      return deserialize<_i12.ModuleDto>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i13.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskOptionDto') {
      return deserialize<_i14.TaskOptionDto>(data['data']);
    }
    if (dataClassName == 'TaskTestCaseDto') {
      return deserialize<_i15.TaskTestCaseDto>(data['data']);
    }
    if (dataClassName == 'UserStatisticsDto') {
      return deserialize<_i16.UserStatisticsDto>(data['data']);
    }
    if (dataClassName == 'WalletBalanceDto') {
      return deserialize<_i17.WalletBalanceDto>(data['data']);
    }
    if (dataClassName == 'CoinTransactionType') {
      return deserialize<_i18.CoinTransactionType>(data['data']);
    }
    if (dataClassName == 'TaskType') {
      return deserialize<_i19.TaskType>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i20.NotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i21.ValidationException>(data['data']);
    }
    if (dataClassName == 'CompleteLessonSessionRequest') {
      return deserialize<_i22.CompleteLessonSessionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCoinTransactionRequest') {
      return deserialize<_i23.CreateCoinTransactionRequest>(data['data']);
    }
    if (dataClassName == 'GenerateExplanationRequest') {
      return deserialize<_i24.GenerateExplanationRequest>(data['data']);
    }
    if (dataClassName == 'GenerateHintRequest') {
      return deserialize<_i25.GenerateHintRequest>(data['data']);
    }
    if (dataClassName == 'AiResponse') {
      return deserialize<_i26.AiResponse>(data['data']);
    }
    if (dataClassName == 'UserWallet') {
      return deserialize<_i27.UserWallet>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i34.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i35.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i34.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i35.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
