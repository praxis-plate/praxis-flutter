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
import 'dto/access_profile_dto.dart' as _i2;
import 'dto/achievement_dto.dart' as _i3;
import 'dto/adaptive_learning_path_dto.dart' as _i4;
import 'dto/adaptive_topic_mastery_dto.dart' as _i5;
import 'dto/cms_task_option_input_dto.dart' as _i6;
import 'dto/cms_task_test_case_input_dto.dart' as _i7;
import 'dto/coin_transaction_dto.dart' as _i8;
import 'dto/course_analytics_dashboard_dto.dart' as _i9;
import 'dto/course_analytics_lesson_dto.dart' as _i10;
import 'dto/course_analytics_summary_dto.dart' as _i11;
import 'dto/course_analytics_task_dto.dart' as _i12;
import 'dto/course_analytics_wrong_answer_dto.dart' as _i13;
import 'dto/course_detail_dto.dart' as _i14;
import 'dto/course_dto.dart' as _i15;
import 'dto/course_recommendation_dto.dart' as _i16;
import 'dto/course_structure_dto.dart' as _i17;
import 'dto/course_structure_lesson_dto.dart' as _i18;
import 'dto/course_structure_module_dto.dart' as _i19;
import 'dto/course_structure_task_dto.dart' as _i20;
import 'dto/external_course_sync_dto.dart' as _i21;
import 'dto/external_integration_provider_dto.dart' as _i22;
import 'dto/external_video_session_dto.dart' as _i23;
import 'dto/lesson_completion_result_dto.dart' as _i24;
import 'dto/lesson_dto.dart' as _i25;
import 'dto/module_dto.dart' as _i26;
import 'dto/task_answer_result_dto.dart' as _i27;
import 'dto/task_answer_test_case_result_dto.dart' as _i28;
import 'dto/task_dto.dart' as _i29;
import 'dto/task_option_dto.dart' as _i30;
import 'dto/task_test_case_dto.dart' as _i31;
import 'dto/user_statistics_dto.dart' as _i32;
import 'dto/wallet_balance_dto.dart' as _i33;
import 'enums/adaptive_learning_path_type.dart' as _i34;
import 'enums/coin_transaction_type.dart' as _i35;
import 'enums/content_status.dart' as _i36;
import 'enums/external_integration_auth_scheme.dart' as _i37;
import 'enums/external_integration_kind.dart' as _i38;
import 'enums/external_integration_provider.dart' as _i39;
import 'enums/task_type.dart' as _i40;
import 'enums/user_role.dart' as _i41;
import 'exceptions/not_found_exception.dart' as _i42;
import 'exceptions/validation_exception.dart' as _i43;
import 'requests/complete_lesson_session_request.dart' as _i44;
import 'requests/create_coin_transaction_request.dart' as _i45;
import 'requests/create_course_request.dart' as _i46;
import 'requests/create_lesson_request.dart' as _i47;
import 'requests/create_module_request.dart' as _i48;
import 'requests/create_task_request.dart' as _i49;
import 'requests/generate_explanation_request.dart' as _i50;
import 'requests/generate_hint_request.dart' as _i51;
import 'requests/provision_external_video_session_request.dart' as _i52;
import 'requests/reorder_lessons_request.dart' as _i53;
import 'requests/reorder_modules_request.dart' as _i54;
import 'requests/reorder_tasks_request.dart' as _i55;
import 'requests/sync_course_to_external_provider_request.dart' as _i56;
import 'requests/update_course_request.dart' as _i57;
import 'requests/update_lesson_request.dart' as _i58;
import 'requests/update_module_request.dart' as _i59;
import 'requests/update_task_request.dart' as _i60;
import 'requests/upsert_task_options_request.dart' as _i61;
import 'requests/upsert_task_test_cases_request.dart' as _i62;
import 'responses/ai_response.dart' as _i63;
import 'tables/user_wallet_table.dart' as _i64;
import 'package:praxis_client/src/protocol/dto/achievement_dto.dart' as _i65;
import 'package:praxis_client/src/protocol/dto/course_dto.dart' as _i66;
import 'package:praxis_client/src/protocol/dto/course_recommendation_dto.dart'
    as _i67;
import 'package:praxis_client/src/protocol/dto/external_integration_provider_dto.dart'
    as _i68;
import 'package:praxis_client/src/protocol/dto/lesson_dto.dart' as _i69;
import 'package:praxis_client/src/protocol/dto/module_dto.dart' as _i70;
import 'package:praxis_client/src/protocol/dto/task_dto.dart' as _i71;
import 'package:praxis_client/src/protocol/dto/task_option_dto.dart' as _i72;
import 'package:praxis_client/src/protocol/dto/task_test_case_dto.dart' as _i73;
import 'package:praxis_client/src/protocol/dto/coin_transaction_dto.dart'
    as _i74;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i75;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i76;
export 'dto/access_profile_dto.dart';
export 'dto/achievement_dto.dart';
export 'dto/adaptive_learning_path_dto.dart';
export 'dto/adaptive_topic_mastery_dto.dart';
export 'dto/cms_task_option_input_dto.dart';
export 'dto/cms_task_test_case_input_dto.dart';
export 'dto/coin_transaction_dto.dart';
export 'dto/course_analytics_dashboard_dto.dart';
export 'dto/course_analytics_lesson_dto.dart';
export 'dto/course_analytics_summary_dto.dart';
export 'dto/course_analytics_task_dto.dart';
export 'dto/course_analytics_wrong_answer_dto.dart';
export 'dto/course_detail_dto.dart';
export 'dto/course_dto.dart';
export 'dto/course_recommendation_dto.dart';
export 'dto/course_structure_dto.dart';
export 'dto/course_structure_lesson_dto.dart';
export 'dto/course_structure_module_dto.dart';
export 'dto/course_structure_task_dto.dart';
export 'dto/external_course_sync_dto.dart';
export 'dto/external_integration_provider_dto.dart';
export 'dto/external_video_session_dto.dart';
export 'dto/lesson_completion_result_dto.dart';
export 'dto/lesson_dto.dart';
export 'dto/module_dto.dart';
export 'dto/task_answer_result_dto.dart';
export 'dto/task_answer_test_case_result_dto.dart';
export 'dto/task_dto.dart';
export 'dto/task_option_dto.dart';
export 'dto/task_test_case_dto.dart';
export 'dto/user_statistics_dto.dart';
export 'dto/wallet_balance_dto.dart';
export 'enums/adaptive_learning_path_type.dart';
export 'enums/coin_transaction_type.dart';
export 'enums/content_status.dart';
export 'enums/external_integration_auth_scheme.dart';
export 'enums/external_integration_kind.dart';
export 'enums/external_integration_provider.dart';
export 'enums/task_type.dart';
export 'enums/user_role.dart';
export 'exceptions/not_found_exception.dart';
export 'exceptions/validation_exception.dart';
export 'requests/complete_lesson_session_request.dart';
export 'requests/create_coin_transaction_request.dart';
export 'requests/create_course_request.dart';
export 'requests/create_lesson_request.dart';
export 'requests/create_module_request.dart';
export 'requests/create_task_request.dart';
export 'requests/generate_explanation_request.dart';
export 'requests/generate_hint_request.dart';
export 'requests/provision_external_video_session_request.dart';
export 'requests/reorder_lessons_request.dart';
export 'requests/reorder_modules_request.dart';
export 'requests/reorder_tasks_request.dart';
export 'requests/sync_course_to_external_provider_request.dart';
export 'requests/update_course_request.dart';
export 'requests/update_lesson_request.dart';
export 'requests/update_module_request.dart';
export 'requests/update_task_request.dart';
export 'requests/upsert_task_options_request.dart';
export 'requests/upsert_task_test_cases_request.dart';
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
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
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

    if (t == _i2.AccessProfileDto) {
      return _i2.AccessProfileDto.fromJson(data) as T;
    }
    if (t == _i3.AchievementDto) {
      return _i3.AchievementDto.fromJson(data) as T;
    }
    if (t == _i4.AdaptiveLearningPathDto) {
      return _i4.AdaptiveLearningPathDto.fromJson(data) as T;
    }
    if (t == _i5.AdaptiveTopicMasteryDto) {
      return _i5.AdaptiveTopicMasteryDto.fromJson(data) as T;
    }
    if (t == _i6.CmsTaskOptionInputDto) {
      return _i6.CmsTaskOptionInputDto.fromJson(data) as T;
    }
    if (t == _i7.CmsTaskTestCaseInputDto) {
      return _i7.CmsTaskTestCaseInputDto.fromJson(data) as T;
    }
    if (t == _i8.CoinTransactionDto) {
      return _i8.CoinTransactionDto.fromJson(data) as T;
    }
    if (t == _i9.CourseAnalyticsDashboardDto) {
      return _i9.CourseAnalyticsDashboardDto.fromJson(data) as T;
    }
    if (t == _i10.CourseAnalyticsLessonDto) {
      return _i10.CourseAnalyticsLessonDto.fromJson(data) as T;
    }
    if (t == _i11.CourseAnalyticsSummaryDto) {
      return _i11.CourseAnalyticsSummaryDto.fromJson(data) as T;
    }
    if (t == _i12.CourseAnalyticsTaskDto) {
      return _i12.CourseAnalyticsTaskDto.fromJson(data) as T;
    }
    if (t == _i13.CourseAnalyticsWrongAnswerDto) {
      return _i13.CourseAnalyticsWrongAnswerDto.fromJson(data) as T;
    }
    if (t == _i14.CourseDetailDto) {
      return _i14.CourseDetailDto.fromJson(data) as T;
    }
    if (t == _i15.CourseDto) {
      return _i15.CourseDto.fromJson(data) as T;
    }
    if (t == _i16.CourseRecommendationDto) {
      return _i16.CourseRecommendationDto.fromJson(data) as T;
    }
    if (t == _i17.CourseStructureDto) {
      return _i17.CourseStructureDto.fromJson(data) as T;
    }
    if (t == _i18.CourseStructureLessonDto) {
      return _i18.CourseStructureLessonDto.fromJson(data) as T;
    }
    if (t == _i19.CourseStructureModuleDto) {
      return _i19.CourseStructureModuleDto.fromJson(data) as T;
    }
    if (t == _i20.CourseStructureTaskDto) {
      return _i20.CourseStructureTaskDto.fromJson(data) as T;
    }
    if (t == _i21.ExternalCourseSyncDto) {
      return _i21.ExternalCourseSyncDto.fromJson(data) as T;
    }
    if (t == _i22.ExternalIntegrationProviderDto) {
      return _i22.ExternalIntegrationProviderDto.fromJson(data) as T;
    }
    if (t == _i23.ExternalVideoSessionDto) {
      return _i23.ExternalVideoSessionDto.fromJson(data) as T;
    }
    if (t == _i24.LessonCompletionResultDto) {
      return _i24.LessonCompletionResultDto.fromJson(data) as T;
    }
    if (t == _i25.LessonDto) {
      return _i25.LessonDto.fromJson(data) as T;
    }
    if (t == _i26.ModuleDto) {
      return _i26.ModuleDto.fromJson(data) as T;
    }
    if (t == _i27.TaskAnswerResultDto) {
      return _i27.TaskAnswerResultDto.fromJson(data) as T;
    }
    if (t == _i28.TaskAnswerTestCaseResultDto) {
      return _i28.TaskAnswerTestCaseResultDto.fromJson(data) as T;
    }
    if (t == _i29.TaskDto) {
      return _i29.TaskDto.fromJson(data) as T;
    }
    if (t == _i30.TaskOptionDto) {
      return _i30.TaskOptionDto.fromJson(data) as T;
    }
    if (t == _i31.TaskTestCaseDto) {
      return _i31.TaskTestCaseDto.fromJson(data) as T;
    }
    if (t == _i32.UserStatisticsDto) {
      return _i32.UserStatisticsDto.fromJson(data) as T;
    }
    if (t == _i33.WalletBalanceDto) {
      return _i33.WalletBalanceDto.fromJson(data) as T;
    }
    if (t == _i34.AdaptiveLearningPathType) {
      return _i34.AdaptiveLearningPathType.fromJson(data) as T;
    }
    if (t == _i35.CoinTransactionType) {
      return _i35.CoinTransactionType.fromJson(data) as T;
    }
    if (t == _i36.ContentStatus) {
      return _i36.ContentStatus.fromJson(data) as T;
    }
    if (t == _i37.ExternalIntegrationAuthScheme) {
      return _i37.ExternalIntegrationAuthScheme.fromJson(data) as T;
    }
    if (t == _i38.ExternalIntegrationKind) {
      return _i38.ExternalIntegrationKind.fromJson(data) as T;
    }
    if (t == _i39.ExternalIntegrationProvider) {
      return _i39.ExternalIntegrationProvider.fromJson(data) as T;
    }
    if (t == _i40.TaskType) {
      return _i40.TaskType.fromJson(data) as T;
    }
    if (t == _i41.UserRole) {
      return _i41.UserRole.fromJson(data) as T;
    }
    if (t == _i42.NotFoundException) {
      return _i42.NotFoundException.fromJson(data) as T;
    }
    if (t == _i43.ValidationException) {
      return _i43.ValidationException.fromJson(data) as T;
    }
    if (t == _i44.CompleteLessonSessionRequest) {
      return _i44.CompleteLessonSessionRequest.fromJson(data) as T;
    }
    if (t == _i45.CreateCoinTransactionRequest) {
      return _i45.CreateCoinTransactionRequest.fromJson(data) as T;
    }
    if (t == _i46.CreateCourseRequest) {
      return _i46.CreateCourseRequest.fromJson(data) as T;
    }
    if (t == _i47.CreateLessonRequest) {
      return _i47.CreateLessonRequest.fromJson(data) as T;
    }
    if (t == _i48.CreateModuleRequest) {
      return _i48.CreateModuleRequest.fromJson(data) as T;
    }
    if (t == _i49.CreateTaskRequest) {
      return _i49.CreateTaskRequest.fromJson(data) as T;
    }
    if (t == _i50.GenerateExplanationRequest) {
      return _i50.GenerateExplanationRequest.fromJson(data) as T;
    }
    if (t == _i51.GenerateHintRequest) {
      return _i51.GenerateHintRequest.fromJson(data) as T;
    }
    if (t == _i52.ProvisionExternalVideoSessionRequest) {
      return _i52.ProvisionExternalVideoSessionRequest.fromJson(data) as T;
    }
    if (t == _i53.ReorderLessonsRequest) {
      return _i53.ReorderLessonsRequest.fromJson(data) as T;
    }
    if (t == _i54.ReorderModulesRequest) {
      return _i54.ReorderModulesRequest.fromJson(data) as T;
    }
    if (t == _i55.ReorderTasksRequest) {
      return _i55.ReorderTasksRequest.fromJson(data) as T;
    }
    if (t == _i56.SyncCourseToExternalProviderRequest) {
      return _i56.SyncCourseToExternalProviderRequest.fromJson(data) as T;
    }
    if (t == _i57.UpdateCourseRequest) {
      return _i57.UpdateCourseRequest.fromJson(data) as T;
    }
    if (t == _i58.UpdateLessonRequest) {
      return _i58.UpdateLessonRequest.fromJson(data) as T;
    }
    if (t == _i59.UpdateModuleRequest) {
      return _i59.UpdateModuleRequest.fromJson(data) as T;
    }
    if (t == _i60.UpdateTaskRequest) {
      return _i60.UpdateTaskRequest.fromJson(data) as T;
    }
    if (t == _i61.UpsertTaskOptionsRequest) {
      return _i61.UpsertTaskOptionsRequest.fromJson(data) as T;
    }
    if (t == _i62.UpsertTaskTestCasesRequest) {
      return _i62.UpsertTaskTestCasesRequest.fromJson(data) as T;
    }
    if (t == _i63.AiResponse) {
      return _i63.AiResponse.fromJson(data) as T;
    }
    if (t == _i64.UserWallet) {
      return _i64.UserWallet.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.AccessProfileDto?>()) {
      return (data != null ? _i2.AccessProfileDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.AchievementDto?>()) {
      return (data != null ? _i3.AchievementDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.AdaptiveLearningPathDto?>()) {
      return (data != null ? _i4.AdaptiveLearningPathDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.AdaptiveTopicMasteryDto?>()) {
      return (data != null ? _i5.AdaptiveTopicMasteryDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.CmsTaskOptionInputDto?>()) {
      return (data != null ? _i6.CmsTaskOptionInputDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.CmsTaskTestCaseInputDto?>()) {
      return (data != null ? _i7.CmsTaskTestCaseInputDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.CoinTransactionDto?>()) {
      return (data != null ? _i8.CoinTransactionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CourseAnalyticsDashboardDto?>()) {
      return (data != null
              ? _i9.CourseAnalyticsDashboardDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.CourseAnalyticsLessonDto?>()) {
      return (data != null
              ? _i10.CourseAnalyticsLessonDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.CourseAnalyticsSummaryDto?>()) {
      return (data != null
              ? _i11.CourseAnalyticsSummaryDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.CourseAnalyticsTaskDto?>()) {
      return (data != null ? _i12.CourseAnalyticsTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.CourseAnalyticsWrongAnswerDto?>()) {
      return (data != null
              ? _i13.CourseAnalyticsWrongAnswerDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.CourseDetailDto?>()) {
      return (data != null ? _i14.CourseDetailDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CourseDto?>()) {
      return (data != null ? _i15.CourseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CourseRecommendationDto?>()) {
      return (data != null ? _i16.CourseRecommendationDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.CourseStructureDto?>()) {
      return (data != null ? _i17.CourseStructureDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.CourseStructureLessonDto?>()) {
      return (data != null
              ? _i18.CourseStructureLessonDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.CourseStructureModuleDto?>()) {
      return (data != null
              ? _i19.CourseStructureModuleDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.CourseStructureTaskDto?>()) {
      return (data != null ? _i20.CourseStructureTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ExternalCourseSyncDto?>()) {
      return (data != null ? _i21.ExternalCourseSyncDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.ExternalIntegrationProviderDto?>()) {
      return (data != null
              ? _i22.ExternalIntegrationProviderDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i23.ExternalVideoSessionDto?>()) {
      return (data != null ? _i23.ExternalVideoSessionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.LessonCompletionResultDto?>()) {
      return (data != null
              ? _i24.LessonCompletionResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.LessonDto?>()) {
      return (data != null ? _i25.LessonDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.ModuleDto?>()) {
      return (data != null ? _i26.ModuleDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.TaskAnswerResultDto?>()) {
      return (data != null ? _i27.TaskAnswerResultDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.TaskAnswerTestCaseResultDto?>()) {
      return (data != null
              ? _i28.TaskAnswerTestCaseResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i29.TaskDto?>()) {
      return (data != null ? _i29.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.TaskOptionDto?>()) {
      return (data != null ? _i30.TaskOptionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.TaskTestCaseDto?>()) {
      return (data != null ? _i31.TaskTestCaseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.UserStatisticsDto?>()) {
      return (data != null ? _i32.UserStatisticsDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.WalletBalanceDto?>()) {
      return (data != null ? _i33.WalletBalanceDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.AdaptiveLearningPathType?>()) {
      return (data != null
              ? _i34.AdaptiveLearningPathType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i35.CoinTransactionType?>()) {
      return (data != null ? _i35.CoinTransactionType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.ContentStatus?>()) {
      return (data != null ? _i36.ContentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ExternalIntegrationAuthScheme?>()) {
      return (data != null
              ? _i37.ExternalIntegrationAuthScheme.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i38.ExternalIntegrationKind?>()) {
      return (data != null ? _i38.ExternalIntegrationKind.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.ExternalIntegrationProvider?>()) {
      return (data != null
              ? _i39.ExternalIntegrationProvider.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i40.TaskType?>()) {
      return (data != null ? _i40.TaskType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.UserRole?>()) {
      return (data != null ? _i41.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.NotFoundException?>()) {
      return (data != null ? _i42.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ValidationException?>()) {
      return (data != null ? _i43.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.CompleteLessonSessionRequest?>()) {
      return (data != null
              ? _i44.CompleteLessonSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i45.CreateCoinTransactionRequest?>()) {
      return (data != null
              ? _i45.CreateCoinTransactionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i46.CreateCourseRequest?>()) {
      return (data != null ? _i46.CreateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.CreateLessonRequest?>()) {
      return (data != null ? _i47.CreateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.CreateModuleRequest?>()) {
      return (data != null ? _i48.CreateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.CreateTaskRequest?>()) {
      return (data != null ? _i49.CreateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.GenerateExplanationRequest?>()) {
      return (data != null
              ? _i50.GenerateExplanationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i51.GenerateHintRequest?>()) {
      return (data != null ? _i51.GenerateHintRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.ProvisionExternalVideoSessionRequest?>()) {
      return (data != null
              ? _i52.ProvisionExternalVideoSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i53.ReorderLessonsRequest?>()) {
      return (data != null ? _i53.ReorderLessonsRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.ReorderModulesRequest?>()) {
      return (data != null ? _i54.ReorderModulesRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.ReorderTasksRequest?>()) {
      return (data != null ? _i55.ReorderTasksRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.SyncCourseToExternalProviderRequest?>()) {
      return (data != null
              ? _i56.SyncCourseToExternalProviderRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i57.UpdateCourseRequest?>()) {
      return (data != null ? _i57.UpdateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.UpdateLessonRequest?>()) {
      return (data != null ? _i58.UpdateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.UpdateModuleRequest?>()) {
      return (data != null ? _i59.UpdateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.UpdateTaskRequest?>()) {
      return (data != null ? _i60.UpdateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.UpsertTaskOptionsRequest?>()) {
      return (data != null
              ? _i61.UpsertTaskOptionsRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i62.UpsertTaskTestCasesRequest?>()) {
      return (data != null
              ? _i62.UpsertTaskTestCasesRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i63.AiResponse?>()) {
      return (data != null ? _i63.AiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.UserWallet?>()) {
      return (data != null ? _i64.UserWallet.fromJson(data) : null) as T;
    }
    if (t == List<_i41.UserRole>) {
      return (data as List).map((e) => deserialize<_i41.UserRole>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i5.AdaptiveTopicMasteryDto>) {
      return (data as List)
              .map((e) => deserialize<_i5.AdaptiveTopicMasteryDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i10.CourseAnalyticsLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i10.CourseAnalyticsLessonDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i12.CourseAnalyticsTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i12.CourseAnalyticsTaskDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i13.CourseAnalyticsWrongAnswerDto>) {
      return (data as List)
              .map((e) => deserialize<_i13.CourseAnalyticsWrongAnswerDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i26.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i26.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i25.LessonDto>) {
      return (data as List).map((e) => deserialize<_i25.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i29.TaskDto>) {
      return (data as List).map((e) => deserialize<_i29.TaskDto>(e)).toList()
          as T;
    }
    if (t == List<_i19.CourseStructureModuleDto>) {
      return (data as List)
              .map((e) => deserialize<_i19.CourseStructureModuleDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.CourseStructureTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i20.CourseStructureTaskDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.CourseStructureLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i18.CourseStructureLessonDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i3.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i3.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i28.TaskAnswerTestCaseResultDto>) {
      return (data as List)
              .map((e) => deserialize<_i28.TaskAnswerTestCaseResultDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i28.TaskAnswerTestCaseResultDto>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i28.TaskAnswerTestCaseResultDto>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i30.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i30.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i31.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i6.CmsTaskOptionInputDto>) {
      return (data as List)
              .map((e) => deserialize<_i6.CmsTaskOptionInputDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i7.CmsTaskTestCaseInputDto>) {
      return (data as List)
              .map((e) => deserialize<_i7.CmsTaskTestCaseInputDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i65.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i65.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i66.CourseDto>) {
      return (data as List).map((e) => deserialize<_i66.CourseDto>(e)).toList()
          as T;
    }
    if (t == List<_i67.CourseRecommendationDto>) {
      return (data as List)
              .map((e) => deserialize<_i67.CourseRecommendationDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i68.ExternalIntegrationProviderDto>) {
      return (data as List)
              .map((e) => deserialize<_i68.ExternalIntegrationProviderDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.LessonDto>) {
      return (data as List).map((e) => deserialize<_i69.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i70.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i70.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i71.TaskDto>) {
      return (data as List).map((e) => deserialize<_i71.TaskDto>(e)).toList()
          as T;
    }
    if (t == List<_i72.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i72.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i73.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.CoinTransactionDto>) {
      return (data as List)
              .map((e) => deserialize<_i74.CoinTransactionDto>(e))
              .toList()
          as T;
    }
    try {
      return _i75.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i76.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccessProfileDto => 'AccessProfileDto',
      _i3.AchievementDto => 'AchievementDto',
      _i4.AdaptiveLearningPathDto => 'AdaptiveLearningPathDto',
      _i5.AdaptiveTopicMasteryDto => 'AdaptiveTopicMasteryDto',
      _i6.CmsTaskOptionInputDto => 'CmsTaskOptionInputDto',
      _i7.CmsTaskTestCaseInputDto => 'CmsTaskTestCaseInputDto',
      _i8.CoinTransactionDto => 'CoinTransactionDto',
      _i9.CourseAnalyticsDashboardDto => 'CourseAnalyticsDashboardDto',
      _i10.CourseAnalyticsLessonDto => 'CourseAnalyticsLessonDto',
      _i11.CourseAnalyticsSummaryDto => 'CourseAnalyticsSummaryDto',
      _i12.CourseAnalyticsTaskDto => 'CourseAnalyticsTaskDto',
      _i13.CourseAnalyticsWrongAnswerDto => 'CourseAnalyticsWrongAnswerDto',
      _i14.CourseDetailDto => 'CourseDetailDto',
      _i15.CourseDto => 'CourseDto',
      _i16.CourseRecommendationDto => 'CourseRecommendationDto',
      _i17.CourseStructureDto => 'CourseStructureDto',
      _i18.CourseStructureLessonDto => 'CourseStructureLessonDto',
      _i19.CourseStructureModuleDto => 'CourseStructureModuleDto',
      _i20.CourseStructureTaskDto => 'CourseStructureTaskDto',
      _i21.ExternalCourseSyncDto => 'ExternalCourseSyncDto',
      _i22.ExternalIntegrationProviderDto => 'ExternalIntegrationProviderDto',
      _i23.ExternalVideoSessionDto => 'ExternalVideoSessionDto',
      _i24.LessonCompletionResultDto => 'LessonCompletionResultDto',
      _i25.LessonDto => 'LessonDto',
      _i26.ModuleDto => 'ModuleDto',
      _i27.TaskAnswerResultDto => 'TaskAnswerResultDto',
      _i28.TaskAnswerTestCaseResultDto => 'TaskAnswerTestCaseResultDto',
      _i29.TaskDto => 'TaskDto',
      _i30.TaskOptionDto => 'TaskOptionDto',
      _i31.TaskTestCaseDto => 'TaskTestCaseDto',
      _i32.UserStatisticsDto => 'UserStatisticsDto',
      _i33.WalletBalanceDto => 'WalletBalanceDto',
      _i34.AdaptiveLearningPathType => 'AdaptiveLearningPathType',
      _i35.CoinTransactionType => 'CoinTransactionType',
      _i36.ContentStatus => 'ContentStatus',
      _i37.ExternalIntegrationAuthScheme => 'ExternalIntegrationAuthScheme',
      _i38.ExternalIntegrationKind => 'ExternalIntegrationKind',
      _i39.ExternalIntegrationProvider => 'ExternalIntegrationProvider',
      _i40.TaskType => 'TaskType',
      _i41.UserRole => 'UserRole',
      _i42.NotFoundException => 'NotFoundException',
      _i43.ValidationException => 'ValidationException',
      _i44.CompleteLessonSessionRequest => 'CompleteLessonSessionRequest',
      _i45.CreateCoinTransactionRequest => 'CreateCoinTransactionRequest',
      _i46.CreateCourseRequest => 'CreateCourseRequest',
      _i47.CreateLessonRequest => 'CreateLessonRequest',
      _i48.CreateModuleRequest => 'CreateModuleRequest',
      _i49.CreateTaskRequest => 'CreateTaskRequest',
      _i50.GenerateExplanationRequest => 'GenerateExplanationRequest',
      _i51.GenerateHintRequest => 'GenerateHintRequest',
      _i52.ProvisionExternalVideoSessionRequest =>
        'ProvisionExternalVideoSessionRequest',
      _i53.ReorderLessonsRequest => 'ReorderLessonsRequest',
      _i54.ReorderModulesRequest => 'ReorderModulesRequest',
      _i55.ReorderTasksRequest => 'ReorderTasksRequest',
      _i56.SyncCourseToExternalProviderRequest =>
        'SyncCourseToExternalProviderRequest',
      _i57.UpdateCourseRequest => 'UpdateCourseRequest',
      _i58.UpdateLessonRequest => 'UpdateLessonRequest',
      _i59.UpdateModuleRequest => 'UpdateModuleRequest',
      _i60.UpdateTaskRequest => 'UpdateTaskRequest',
      _i61.UpsertTaskOptionsRequest => 'UpsertTaskOptionsRequest',
      _i62.UpsertTaskTestCasesRequest => 'UpsertTaskTestCasesRequest',
      _i63.AiResponse => 'AiResponse',
      _i64.UserWallet => 'UserWallet',
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
      case _i2.AccessProfileDto():
        return 'AccessProfileDto';
      case _i3.AchievementDto():
        return 'AchievementDto';
      case _i4.AdaptiveLearningPathDto():
        return 'AdaptiveLearningPathDto';
      case _i5.AdaptiveTopicMasteryDto():
        return 'AdaptiveTopicMasteryDto';
      case _i6.CmsTaskOptionInputDto():
        return 'CmsTaskOptionInputDto';
      case _i7.CmsTaskTestCaseInputDto():
        return 'CmsTaskTestCaseInputDto';
      case _i8.CoinTransactionDto():
        return 'CoinTransactionDto';
      case _i9.CourseAnalyticsDashboardDto():
        return 'CourseAnalyticsDashboardDto';
      case _i10.CourseAnalyticsLessonDto():
        return 'CourseAnalyticsLessonDto';
      case _i11.CourseAnalyticsSummaryDto():
        return 'CourseAnalyticsSummaryDto';
      case _i12.CourseAnalyticsTaskDto():
        return 'CourseAnalyticsTaskDto';
      case _i13.CourseAnalyticsWrongAnswerDto():
        return 'CourseAnalyticsWrongAnswerDto';
      case _i14.CourseDetailDto():
        return 'CourseDetailDto';
      case _i15.CourseDto():
        return 'CourseDto';
      case _i16.CourseRecommendationDto():
        return 'CourseRecommendationDto';
      case _i17.CourseStructureDto():
        return 'CourseStructureDto';
      case _i18.CourseStructureLessonDto():
        return 'CourseStructureLessonDto';
      case _i19.CourseStructureModuleDto():
        return 'CourseStructureModuleDto';
      case _i20.CourseStructureTaskDto():
        return 'CourseStructureTaskDto';
      case _i21.ExternalCourseSyncDto():
        return 'ExternalCourseSyncDto';
      case _i22.ExternalIntegrationProviderDto():
        return 'ExternalIntegrationProviderDto';
      case _i23.ExternalVideoSessionDto():
        return 'ExternalVideoSessionDto';
      case _i24.LessonCompletionResultDto():
        return 'LessonCompletionResultDto';
      case _i25.LessonDto():
        return 'LessonDto';
      case _i26.ModuleDto():
        return 'ModuleDto';
      case _i27.TaskAnswerResultDto():
        return 'TaskAnswerResultDto';
      case _i28.TaskAnswerTestCaseResultDto():
        return 'TaskAnswerTestCaseResultDto';
      case _i29.TaskDto():
        return 'TaskDto';
      case _i30.TaskOptionDto():
        return 'TaskOptionDto';
      case _i31.TaskTestCaseDto():
        return 'TaskTestCaseDto';
      case _i32.UserStatisticsDto():
        return 'UserStatisticsDto';
      case _i33.WalletBalanceDto():
        return 'WalletBalanceDto';
      case _i34.AdaptiveLearningPathType():
        return 'AdaptiveLearningPathType';
      case _i35.CoinTransactionType():
        return 'CoinTransactionType';
      case _i36.ContentStatus():
        return 'ContentStatus';
      case _i37.ExternalIntegrationAuthScheme():
        return 'ExternalIntegrationAuthScheme';
      case _i38.ExternalIntegrationKind():
        return 'ExternalIntegrationKind';
      case _i39.ExternalIntegrationProvider():
        return 'ExternalIntegrationProvider';
      case _i40.TaskType():
        return 'TaskType';
      case _i41.UserRole():
        return 'UserRole';
      case _i42.NotFoundException():
        return 'NotFoundException';
      case _i43.ValidationException():
        return 'ValidationException';
      case _i44.CompleteLessonSessionRequest():
        return 'CompleteLessonSessionRequest';
      case _i45.CreateCoinTransactionRequest():
        return 'CreateCoinTransactionRequest';
      case _i46.CreateCourseRequest():
        return 'CreateCourseRequest';
      case _i47.CreateLessonRequest():
        return 'CreateLessonRequest';
      case _i48.CreateModuleRequest():
        return 'CreateModuleRequest';
      case _i49.CreateTaskRequest():
        return 'CreateTaskRequest';
      case _i50.GenerateExplanationRequest():
        return 'GenerateExplanationRequest';
      case _i51.GenerateHintRequest():
        return 'GenerateHintRequest';
      case _i52.ProvisionExternalVideoSessionRequest():
        return 'ProvisionExternalVideoSessionRequest';
      case _i53.ReorderLessonsRequest():
        return 'ReorderLessonsRequest';
      case _i54.ReorderModulesRequest():
        return 'ReorderModulesRequest';
      case _i55.ReorderTasksRequest():
        return 'ReorderTasksRequest';
      case _i56.SyncCourseToExternalProviderRequest():
        return 'SyncCourseToExternalProviderRequest';
      case _i57.UpdateCourseRequest():
        return 'UpdateCourseRequest';
      case _i58.UpdateLessonRequest():
        return 'UpdateLessonRequest';
      case _i59.UpdateModuleRequest():
        return 'UpdateModuleRequest';
      case _i60.UpdateTaskRequest():
        return 'UpdateTaskRequest';
      case _i61.UpsertTaskOptionsRequest():
        return 'UpsertTaskOptionsRequest';
      case _i62.UpsertTaskTestCasesRequest():
        return 'UpsertTaskTestCasesRequest';
      case _i63.AiResponse():
        return 'AiResponse';
      case _i64.UserWallet():
        return 'UserWallet';
    }
    className = _i75.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i76.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AccessProfileDto') {
      return deserialize<_i2.AccessProfileDto>(data['data']);
    }
    if (dataClassName == 'AchievementDto') {
      return deserialize<_i3.AchievementDto>(data['data']);
    }
    if (dataClassName == 'AdaptiveLearningPathDto') {
      return deserialize<_i4.AdaptiveLearningPathDto>(data['data']);
    }
    if (dataClassName == 'AdaptiveTopicMasteryDto') {
      return deserialize<_i5.AdaptiveTopicMasteryDto>(data['data']);
    }
    if (dataClassName == 'CmsTaskOptionInputDto') {
      return deserialize<_i6.CmsTaskOptionInputDto>(data['data']);
    }
    if (dataClassName == 'CmsTaskTestCaseInputDto') {
      return deserialize<_i7.CmsTaskTestCaseInputDto>(data['data']);
    }
    if (dataClassName == 'CoinTransactionDto') {
      return deserialize<_i8.CoinTransactionDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsDashboardDto') {
      return deserialize<_i9.CourseAnalyticsDashboardDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsLessonDto') {
      return deserialize<_i10.CourseAnalyticsLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsSummaryDto') {
      return deserialize<_i11.CourseAnalyticsSummaryDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsTaskDto') {
      return deserialize<_i12.CourseAnalyticsTaskDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsWrongAnswerDto') {
      return deserialize<_i13.CourseAnalyticsWrongAnswerDto>(data['data']);
    }
    if (dataClassName == 'CourseDetailDto') {
      return deserialize<_i14.CourseDetailDto>(data['data']);
    }
    if (dataClassName == 'CourseDto') {
      return deserialize<_i15.CourseDto>(data['data']);
    }
    if (dataClassName == 'CourseRecommendationDto') {
      return deserialize<_i16.CourseRecommendationDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureDto') {
      return deserialize<_i17.CourseStructureDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureLessonDto') {
      return deserialize<_i18.CourseStructureLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureModuleDto') {
      return deserialize<_i19.CourseStructureModuleDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureTaskDto') {
      return deserialize<_i20.CourseStructureTaskDto>(data['data']);
    }
    if (dataClassName == 'ExternalCourseSyncDto') {
      return deserialize<_i21.ExternalCourseSyncDto>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationProviderDto') {
      return deserialize<_i22.ExternalIntegrationProviderDto>(data['data']);
    }
    if (dataClassName == 'ExternalVideoSessionDto') {
      return deserialize<_i23.ExternalVideoSessionDto>(data['data']);
    }
    if (dataClassName == 'LessonCompletionResultDto') {
      return deserialize<_i24.LessonCompletionResultDto>(data['data']);
    }
    if (dataClassName == 'LessonDto') {
      return deserialize<_i25.LessonDto>(data['data']);
    }
    if (dataClassName == 'ModuleDto') {
      return deserialize<_i26.ModuleDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerResultDto') {
      return deserialize<_i27.TaskAnswerResultDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerTestCaseResultDto') {
      return deserialize<_i28.TaskAnswerTestCaseResultDto>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i29.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskOptionDto') {
      return deserialize<_i30.TaskOptionDto>(data['data']);
    }
    if (dataClassName == 'TaskTestCaseDto') {
      return deserialize<_i31.TaskTestCaseDto>(data['data']);
    }
    if (dataClassName == 'UserStatisticsDto') {
      return deserialize<_i32.UserStatisticsDto>(data['data']);
    }
    if (dataClassName == 'WalletBalanceDto') {
      return deserialize<_i33.WalletBalanceDto>(data['data']);
    }
    if (dataClassName == 'AdaptiveLearningPathType') {
      return deserialize<_i34.AdaptiveLearningPathType>(data['data']);
    }
    if (dataClassName == 'CoinTransactionType') {
      return deserialize<_i35.CoinTransactionType>(data['data']);
    }
    if (dataClassName == 'ContentStatus') {
      return deserialize<_i36.ContentStatus>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationAuthScheme') {
      return deserialize<_i37.ExternalIntegrationAuthScheme>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationKind') {
      return deserialize<_i38.ExternalIntegrationKind>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationProvider') {
      return deserialize<_i39.ExternalIntegrationProvider>(data['data']);
    }
    if (dataClassName == 'TaskType') {
      return deserialize<_i40.TaskType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i41.UserRole>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i42.NotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i43.ValidationException>(data['data']);
    }
    if (dataClassName == 'CompleteLessonSessionRequest') {
      return deserialize<_i44.CompleteLessonSessionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCoinTransactionRequest') {
      return deserialize<_i45.CreateCoinTransactionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCourseRequest') {
      return deserialize<_i46.CreateCourseRequest>(data['data']);
    }
    if (dataClassName == 'CreateLessonRequest') {
      return deserialize<_i47.CreateLessonRequest>(data['data']);
    }
    if (dataClassName == 'CreateModuleRequest') {
      return deserialize<_i48.CreateModuleRequest>(data['data']);
    }
    if (dataClassName == 'CreateTaskRequest') {
      return deserialize<_i49.CreateTaskRequest>(data['data']);
    }
    if (dataClassName == 'GenerateExplanationRequest') {
      return deserialize<_i50.GenerateExplanationRequest>(data['data']);
    }
    if (dataClassName == 'GenerateHintRequest') {
      return deserialize<_i51.GenerateHintRequest>(data['data']);
    }
    if (dataClassName == 'ProvisionExternalVideoSessionRequest') {
      return deserialize<_i52.ProvisionExternalVideoSessionRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'ReorderLessonsRequest') {
      return deserialize<_i53.ReorderLessonsRequest>(data['data']);
    }
    if (dataClassName == 'ReorderModulesRequest') {
      return deserialize<_i54.ReorderModulesRequest>(data['data']);
    }
    if (dataClassName == 'ReorderTasksRequest') {
      return deserialize<_i55.ReorderTasksRequest>(data['data']);
    }
    if (dataClassName == 'SyncCourseToExternalProviderRequest') {
      return deserialize<_i56.SyncCourseToExternalProviderRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'UpdateCourseRequest') {
      return deserialize<_i57.UpdateCourseRequest>(data['data']);
    }
    if (dataClassName == 'UpdateLessonRequest') {
      return deserialize<_i58.UpdateLessonRequest>(data['data']);
    }
    if (dataClassName == 'UpdateModuleRequest') {
      return deserialize<_i59.UpdateModuleRequest>(data['data']);
    }
    if (dataClassName == 'UpdateTaskRequest') {
      return deserialize<_i60.UpdateTaskRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskOptionsRequest') {
      return deserialize<_i61.UpsertTaskOptionsRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskTestCasesRequest') {
      return deserialize<_i62.UpsertTaskTestCasesRequest>(data['data']);
    }
    if (dataClassName == 'AiResponse') {
      return deserialize<_i63.AiResponse>(data['data']);
    }
    if (dataClassName == 'UserWallet') {
      return deserialize<_i64.UserWallet>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i75.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i76.Protocol().deserializeByClassName(data);
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
      return _i75.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i76.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
