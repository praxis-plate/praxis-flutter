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
import 'dto/governance_user_dto.dart' as _i24;
import 'dto/lesson_completion_result_dto.dart' as _i25;
import 'dto/lesson_content_block_dto.dart' as _i26;
import 'dto/lesson_content_document_dto.dart' as _i27;
import 'dto/lesson_dto.dart' as _i28;
import 'dto/module_dto.dart' as _i29;
import 'dto/task_answer_result_dto.dart' as _i30;
import 'dto/task_answer_test_case_result_dto.dart' as _i31;
import 'dto/task_dto.dart' as _i32;
import 'dto/task_option_dto.dart' as _i33;
import 'dto/task_test_case_dto.dart' as _i34;
import 'dto/user_statistics_dto.dart' as _i35;
import 'dto/wallet_balance_dto.dart' as _i36;
import 'enums/adaptive_learning_path_type.dart' as _i37;
import 'enums/coin_transaction_type.dart' as _i38;
import 'enums/content_status.dart' as _i39;
import 'enums/external_integration_auth_scheme.dart' as _i40;
import 'enums/external_integration_kind.dart' as _i41;
import 'enums/external_integration_provider.dart' as _i42;
import 'enums/lesson_content_block_type.dart' as _i43;
import 'enums/task_type.dart' as _i44;
import 'enums/user_role.dart' as _i45;
import 'exceptions/not_found_exception.dart' as _i46;
import 'exceptions/validation_exception.dart' as _i47;
import 'requests/complete_lesson_session_request.dart' as _i48;
import 'requests/create_coin_transaction_request.dart' as _i49;
import 'requests/create_course_request.dart' as _i50;
import 'requests/create_lesson_request.dart' as _i51;
import 'requests/create_module_request.dart' as _i52;
import 'requests/create_task_request.dart' as _i53;
import 'requests/generate_explanation_request.dart' as _i54;
import 'requests/generate_hint_request.dart' as _i55;
import 'requests/provision_external_video_session_request.dart' as _i56;
import 'requests/reorder_lessons_request.dart' as _i57;
import 'requests/reorder_modules_request.dart' as _i58;
import 'requests/reorder_tasks_request.dart' as _i59;
import 'requests/sync_course_to_external_provider_request.dart' as _i60;
import 'requests/update_course_request.dart' as _i61;
import 'requests/update_lesson_request.dart' as _i62;
import 'requests/update_module_request.dart' as _i63;
import 'requests/update_task_request.dart' as _i64;
import 'requests/upsert_task_options_request.dart' as _i65;
import 'requests/upsert_task_test_cases_request.dart' as _i66;
import 'responses/ai_response.dart' as _i67;
import 'tables/user_wallet_table.dart' as _i68;
import 'package:praxis_client/src/protocol/dto/achievement_dto.dart' as _i69;
import 'package:praxis_client/src/protocol/dto/governance_user_dto.dart'
    as _i70;
import 'package:praxis_client/src/protocol/dto/course_dto.dart' as _i71;
import 'package:praxis_client/src/protocol/dto/course_recommendation_dto.dart'
    as _i72;
import 'package:praxis_client/src/protocol/dto/external_integration_provider_dto.dart'
    as _i73;
import 'package:praxis_client/src/protocol/dto/lesson_dto.dart' as _i74;
import 'package:praxis_client/src/protocol/dto/module_dto.dart' as _i75;
import 'package:praxis_client/src/protocol/dto/task_dto.dart' as _i76;
import 'package:praxis_client/src/protocol/dto/task_option_dto.dart' as _i77;
import 'package:praxis_client/src/protocol/dto/task_test_case_dto.dart' as _i78;
import 'package:praxis_client/src/protocol/dto/coin_transaction_dto.dart'
    as _i79;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i80;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i81;
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
export 'dto/governance_user_dto.dart';
export 'dto/lesson_completion_result_dto.dart';
export 'dto/lesson_content_block_dto.dart';
export 'dto/lesson_content_document_dto.dart';
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
export 'enums/lesson_content_block_type.dart';
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
    if (t == _i24.GovernanceUserDto) {
      return _i24.GovernanceUserDto.fromJson(data) as T;
    }
    if (t == _i25.LessonCompletionResultDto) {
      return _i25.LessonCompletionResultDto.fromJson(data) as T;
    }
    if (t == _i26.LessonContentBlockDto) {
      return _i26.LessonContentBlockDto.fromJson(data) as T;
    }
    if (t == _i27.LessonContentDocumentDto) {
      return _i27.LessonContentDocumentDto.fromJson(data) as T;
    }
    if (t == _i28.LessonDto) {
      return _i28.LessonDto.fromJson(data) as T;
    }
    if (t == _i29.ModuleDto) {
      return _i29.ModuleDto.fromJson(data) as T;
    }
    if (t == _i30.TaskAnswerResultDto) {
      return _i30.TaskAnswerResultDto.fromJson(data) as T;
    }
    if (t == _i31.TaskAnswerTestCaseResultDto) {
      return _i31.TaskAnswerTestCaseResultDto.fromJson(data) as T;
    }
    if (t == _i32.TaskDto) {
      return _i32.TaskDto.fromJson(data) as T;
    }
    if (t == _i33.TaskOptionDto) {
      return _i33.TaskOptionDto.fromJson(data) as T;
    }
    if (t == _i34.TaskTestCaseDto) {
      return _i34.TaskTestCaseDto.fromJson(data) as T;
    }
    if (t == _i35.UserStatisticsDto) {
      return _i35.UserStatisticsDto.fromJson(data) as T;
    }
    if (t == _i36.WalletBalanceDto) {
      return _i36.WalletBalanceDto.fromJson(data) as T;
    }
    if (t == _i37.AdaptiveLearningPathType) {
      return _i37.AdaptiveLearningPathType.fromJson(data) as T;
    }
    if (t == _i38.CoinTransactionType) {
      return _i38.CoinTransactionType.fromJson(data) as T;
    }
    if (t == _i39.ContentStatus) {
      return _i39.ContentStatus.fromJson(data) as T;
    }
    if (t == _i40.ExternalIntegrationAuthScheme) {
      return _i40.ExternalIntegrationAuthScheme.fromJson(data) as T;
    }
    if (t == _i41.ExternalIntegrationKind) {
      return _i41.ExternalIntegrationKind.fromJson(data) as T;
    }
    if (t == _i42.ExternalIntegrationProvider) {
      return _i42.ExternalIntegrationProvider.fromJson(data) as T;
    }
    if (t == _i43.LessonContentBlockType) {
      return _i43.LessonContentBlockType.fromJson(data) as T;
    }
    if (t == _i44.TaskType) {
      return _i44.TaskType.fromJson(data) as T;
    }
    if (t == _i45.UserRole) {
      return _i45.UserRole.fromJson(data) as T;
    }
    if (t == _i46.NotFoundException) {
      return _i46.NotFoundException.fromJson(data) as T;
    }
    if (t == _i47.ValidationException) {
      return _i47.ValidationException.fromJson(data) as T;
    }
    if (t == _i48.CompleteLessonSessionRequest) {
      return _i48.CompleteLessonSessionRequest.fromJson(data) as T;
    }
    if (t == _i49.CreateCoinTransactionRequest) {
      return _i49.CreateCoinTransactionRequest.fromJson(data) as T;
    }
    if (t == _i50.CreateCourseRequest) {
      return _i50.CreateCourseRequest.fromJson(data) as T;
    }
    if (t == _i51.CreateLessonRequest) {
      return _i51.CreateLessonRequest.fromJson(data) as T;
    }
    if (t == _i52.CreateModuleRequest) {
      return _i52.CreateModuleRequest.fromJson(data) as T;
    }
    if (t == _i53.CreateTaskRequest) {
      return _i53.CreateTaskRequest.fromJson(data) as T;
    }
    if (t == _i54.GenerateExplanationRequest) {
      return _i54.GenerateExplanationRequest.fromJson(data) as T;
    }
    if (t == _i55.GenerateHintRequest) {
      return _i55.GenerateHintRequest.fromJson(data) as T;
    }
    if (t == _i56.ProvisionExternalVideoSessionRequest) {
      return _i56.ProvisionExternalVideoSessionRequest.fromJson(data) as T;
    }
    if (t == _i57.ReorderLessonsRequest) {
      return _i57.ReorderLessonsRequest.fromJson(data) as T;
    }
    if (t == _i58.ReorderModulesRequest) {
      return _i58.ReorderModulesRequest.fromJson(data) as T;
    }
    if (t == _i59.ReorderTasksRequest) {
      return _i59.ReorderTasksRequest.fromJson(data) as T;
    }
    if (t == _i60.SyncCourseToExternalProviderRequest) {
      return _i60.SyncCourseToExternalProviderRequest.fromJson(data) as T;
    }
    if (t == _i61.UpdateCourseRequest) {
      return _i61.UpdateCourseRequest.fromJson(data) as T;
    }
    if (t == _i62.UpdateLessonRequest) {
      return _i62.UpdateLessonRequest.fromJson(data) as T;
    }
    if (t == _i63.UpdateModuleRequest) {
      return _i63.UpdateModuleRequest.fromJson(data) as T;
    }
    if (t == _i64.UpdateTaskRequest) {
      return _i64.UpdateTaskRequest.fromJson(data) as T;
    }
    if (t == _i65.UpsertTaskOptionsRequest) {
      return _i65.UpsertTaskOptionsRequest.fromJson(data) as T;
    }
    if (t == _i66.UpsertTaskTestCasesRequest) {
      return _i66.UpsertTaskTestCasesRequest.fromJson(data) as T;
    }
    if (t == _i67.AiResponse) {
      return _i67.AiResponse.fromJson(data) as T;
    }
    if (t == _i68.UserWallet) {
      return _i68.UserWallet.fromJson(data) as T;
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
    if (t == _i1.getType<_i24.GovernanceUserDto?>()) {
      return (data != null ? _i24.GovernanceUserDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.LessonCompletionResultDto?>()) {
      return (data != null
              ? _i25.LessonCompletionResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i26.LessonContentBlockDto?>()) {
      return (data != null ? _i26.LessonContentBlockDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.LessonContentDocumentDto?>()) {
      return (data != null
              ? _i27.LessonContentDocumentDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i28.LessonDto?>()) {
      return (data != null ? _i28.LessonDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ModuleDto?>()) {
      return (data != null ? _i29.ModuleDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.TaskAnswerResultDto?>()) {
      return (data != null ? _i30.TaskAnswerResultDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.TaskAnswerTestCaseResultDto?>()) {
      return (data != null
              ? _i31.TaskAnswerTestCaseResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i32.TaskDto?>()) {
      return (data != null ? _i32.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.TaskOptionDto?>()) {
      return (data != null ? _i33.TaskOptionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.TaskTestCaseDto?>()) {
      return (data != null ? _i34.TaskTestCaseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.UserStatisticsDto?>()) {
      return (data != null ? _i35.UserStatisticsDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.WalletBalanceDto?>()) {
      return (data != null ? _i36.WalletBalanceDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.AdaptiveLearningPathType?>()) {
      return (data != null
              ? _i37.AdaptiveLearningPathType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i38.CoinTransactionType?>()) {
      return (data != null ? _i38.CoinTransactionType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.ContentStatus?>()) {
      return (data != null ? _i39.ContentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.ExternalIntegrationAuthScheme?>()) {
      return (data != null
              ? _i40.ExternalIntegrationAuthScheme.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i41.ExternalIntegrationKind?>()) {
      return (data != null ? _i41.ExternalIntegrationKind.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.ExternalIntegrationProvider?>()) {
      return (data != null
              ? _i42.ExternalIntegrationProvider.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i43.LessonContentBlockType?>()) {
      return (data != null ? _i43.LessonContentBlockType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.TaskType?>()) {
      return (data != null ? _i44.TaskType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.UserRole?>()) {
      return (data != null ? _i45.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.NotFoundException?>()) {
      return (data != null ? _i46.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ValidationException?>()) {
      return (data != null ? _i47.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.CompleteLessonSessionRequest?>()) {
      return (data != null
              ? _i48.CompleteLessonSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i49.CreateCoinTransactionRequest?>()) {
      return (data != null
              ? _i49.CreateCoinTransactionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i50.CreateCourseRequest?>()) {
      return (data != null ? _i50.CreateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.CreateLessonRequest?>()) {
      return (data != null ? _i51.CreateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.CreateModuleRequest?>()) {
      return (data != null ? _i52.CreateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.CreateTaskRequest?>()) {
      return (data != null ? _i53.CreateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.GenerateExplanationRequest?>()) {
      return (data != null
              ? _i54.GenerateExplanationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i55.GenerateHintRequest?>()) {
      return (data != null ? _i55.GenerateHintRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.ProvisionExternalVideoSessionRequest?>()) {
      return (data != null
              ? _i56.ProvisionExternalVideoSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i57.ReorderLessonsRequest?>()) {
      return (data != null ? _i57.ReorderLessonsRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.ReorderModulesRequest?>()) {
      return (data != null ? _i58.ReorderModulesRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.ReorderTasksRequest?>()) {
      return (data != null ? _i59.ReorderTasksRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.SyncCourseToExternalProviderRequest?>()) {
      return (data != null
              ? _i60.SyncCourseToExternalProviderRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i61.UpdateCourseRequest?>()) {
      return (data != null ? _i61.UpdateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.UpdateLessonRequest?>()) {
      return (data != null ? _i62.UpdateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.UpdateModuleRequest?>()) {
      return (data != null ? _i63.UpdateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.UpdateTaskRequest?>()) {
      return (data != null ? _i64.UpdateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.UpsertTaskOptionsRequest?>()) {
      return (data != null
              ? _i65.UpsertTaskOptionsRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i66.UpsertTaskTestCasesRequest?>()) {
      return (data != null
              ? _i66.UpsertTaskTestCasesRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i67.AiResponse?>()) {
      return (data != null ? _i67.AiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.UserWallet?>()) {
      return (data != null ? _i68.UserWallet.fromJson(data) : null) as T;
    }
    if (t == List<_i45.UserRole>) {
      return (data as List).map((e) => deserialize<_i45.UserRole>(e)).toList()
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
    if (t == List<_i29.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i29.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i28.LessonDto>) {
      return (data as List).map((e) => deserialize<_i28.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i32.TaskDto>) {
      return (data as List).map((e) => deserialize<_i32.TaskDto>(e)).toList()
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
    if (t == List<_i26.LessonContentBlockDto>) {
      return (data as List)
              .map((e) => deserialize<_i26.LessonContentBlockDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.TaskAnswerTestCaseResultDto>) {
      return (data as List)
              .map((e) => deserialize<_i31.TaskAnswerTestCaseResultDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i31.TaskAnswerTestCaseResultDto>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i31.TaskAnswerTestCaseResultDto>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i33.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i33.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i34.TaskTestCaseDto>(e))
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
    if (t == List<_i69.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i69.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i70.GovernanceUserDto>) {
      return (data as List)
              .map((e) => deserialize<_i70.GovernanceUserDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i71.CourseDto>) {
      return (data as List).map((e) => deserialize<_i71.CourseDto>(e)).toList()
          as T;
    }
    if (t == List<_i72.CourseRecommendationDto>) {
      return (data as List)
              .map((e) => deserialize<_i72.CourseRecommendationDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.ExternalIntegrationProviderDto>) {
      return (data as List)
              .map((e) => deserialize<_i73.ExternalIntegrationProviderDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.LessonDto>) {
      return (data as List).map((e) => deserialize<_i74.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i75.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i75.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i76.TaskDto>) {
      return (data as List).map((e) => deserialize<_i76.TaskDto>(e)).toList()
          as T;
    }
    if (t == List<_i77.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i77.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i78.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.CoinTransactionDto>) {
      return (data as List)
              .map((e) => deserialize<_i79.CoinTransactionDto>(e))
              .toList()
          as T;
    }
    try {
      return _i80.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i81.Protocol().deserialize<T>(data, t);
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
      _i24.GovernanceUserDto => 'GovernanceUserDto',
      _i25.LessonCompletionResultDto => 'LessonCompletionResultDto',
      _i26.LessonContentBlockDto => 'LessonContentBlockDto',
      _i27.LessonContentDocumentDto => 'LessonContentDocumentDto',
      _i28.LessonDto => 'LessonDto',
      _i29.ModuleDto => 'ModuleDto',
      _i30.TaskAnswerResultDto => 'TaskAnswerResultDto',
      _i31.TaskAnswerTestCaseResultDto => 'TaskAnswerTestCaseResultDto',
      _i32.TaskDto => 'TaskDto',
      _i33.TaskOptionDto => 'TaskOptionDto',
      _i34.TaskTestCaseDto => 'TaskTestCaseDto',
      _i35.UserStatisticsDto => 'UserStatisticsDto',
      _i36.WalletBalanceDto => 'WalletBalanceDto',
      _i37.AdaptiveLearningPathType => 'AdaptiveLearningPathType',
      _i38.CoinTransactionType => 'CoinTransactionType',
      _i39.ContentStatus => 'ContentStatus',
      _i40.ExternalIntegrationAuthScheme => 'ExternalIntegrationAuthScheme',
      _i41.ExternalIntegrationKind => 'ExternalIntegrationKind',
      _i42.ExternalIntegrationProvider => 'ExternalIntegrationProvider',
      _i43.LessonContentBlockType => 'LessonContentBlockType',
      _i44.TaskType => 'TaskType',
      _i45.UserRole => 'UserRole',
      _i46.NotFoundException => 'NotFoundException',
      _i47.ValidationException => 'ValidationException',
      _i48.CompleteLessonSessionRequest => 'CompleteLessonSessionRequest',
      _i49.CreateCoinTransactionRequest => 'CreateCoinTransactionRequest',
      _i50.CreateCourseRequest => 'CreateCourseRequest',
      _i51.CreateLessonRequest => 'CreateLessonRequest',
      _i52.CreateModuleRequest => 'CreateModuleRequest',
      _i53.CreateTaskRequest => 'CreateTaskRequest',
      _i54.GenerateExplanationRequest => 'GenerateExplanationRequest',
      _i55.GenerateHintRequest => 'GenerateHintRequest',
      _i56.ProvisionExternalVideoSessionRequest =>
        'ProvisionExternalVideoSessionRequest',
      _i57.ReorderLessonsRequest => 'ReorderLessonsRequest',
      _i58.ReorderModulesRequest => 'ReorderModulesRequest',
      _i59.ReorderTasksRequest => 'ReorderTasksRequest',
      _i60.SyncCourseToExternalProviderRequest =>
        'SyncCourseToExternalProviderRequest',
      _i61.UpdateCourseRequest => 'UpdateCourseRequest',
      _i62.UpdateLessonRequest => 'UpdateLessonRequest',
      _i63.UpdateModuleRequest => 'UpdateModuleRequest',
      _i64.UpdateTaskRequest => 'UpdateTaskRequest',
      _i65.UpsertTaskOptionsRequest => 'UpsertTaskOptionsRequest',
      _i66.UpsertTaskTestCasesRequest => 'UpsertTaskTestCasesRequest',
      _i67.AiResponse => 'AiResponse',
      _i68.UserWallet => 'UserWallet',
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
      case _i24.GovernanceUserDto():
        return 'GovernanceUserDto';
      case _i25.LessonCompletionResultDto():
        return 'LessonCompletionResultDto';
      case _i26.LessonContentBlockDto():
        return 'LessonContentBlockDto';
      case _i27.LessonContentDocumentDto():
        return 'LessonContentDocumentDto';
      case _i28.LessonDto():
        return 'LessonDto';
      case _i29.ModuleDto():
        return 'ModuleDto';
      case _i30.TaskAnswerResultDto():
        return 'TaskAnswerResultDto';
      case _i31.TaskAnswerTestCaseResultDto():
        return 'TaskAnswerTestCaseResultDto';
      case _i32.TaskDto():
        return 'TaskDto';
      case _i33.TaskOptionDto():
        return 'TaskOptionDto';
      case _i34.TaskTestCaseDto():
        return 'TaskTestCaseDto';
      case _i35.UserStatisticsDto():
        return 'UserStatisticsDto';
      case _i36.WalletBalanceDto():
        return 'WalletBalanceDto';
      case _i37.AdaptiveLearningPathType():
        return 'AdaptiveLearningPathType';
      case _i38.CoinTransactionType():
        return 'CoinTransactionType';
      case _i39.ContentStatus():
        return 'ContentStatus';
      case _i40.ExternalIntegrationAuthScheme():
        return 'ExternalIntegrationAuthScheme';
      case _i41.ExternalIntegrationKind():
        return 'ExternalIntegrationKind';
      case _i42.ExternalIntegrationProvider():
        return 'ExternalIntegrationProvider';
      case _i43.LessonContentBlockType():
        return 'LessonContentBlockType';
      case _i44.TaskType():
        return 'TaskType';
      case _i45.UserRole():
        return 'UserRole';
      case _i46.NotFoundException():
        return 'NotFoundException';
      case _i47.ValidationException():
        return 'ValidationException';
      case _i48.CompleteLessonSessionRequest():
        return 'CompleteLessonSessionRequest';
      case _i49.CreateCoinTransactionRequest():
        return 'CreateCoinTransactionRequest';
      case _i50.CreateCourseRequest():
        return 'CreateCourseRequest';
      case _i51.CreateLessonRequest():
        return 'CreateLessonRequest';
      case _i52.CreateModuleRequest():
        return 'CreateModuleRequest';
      case _i53.CreateTaskRequest():
        return 'CreateTaskRequest';
      case _i54.GenerateExplanationRequest():
        return 'GenerateExplanationRequest';
      case _i55.GenerateHintRequest():
        return 'GenerateHintRequest';
      case _i56.ProvisionExternalVideoSessionRequest():
        return 'ProvisionExternalVideoSessionRequest';
      case _i57.ReorderLessonsRequest():
        return 'ReorderLessonsRequest';
      case _i58.ReorderModulesRequest():
        return 'ReorderModulesRequest';
      case _i59.ReorderTasksRequest():
        return 'ReorderTasksRequest';
      case _i60.SyncCourseToExternalProviderRequest():
        return 'SyncCourseToExternalProviderRequest';
      case _i61.UpdateCourseRequest():
        return 'UpdateCourseRequest';
      case _i62.UpdateLessonRequest():
        return 'UpdateLessonRequest';
      case _i63.UpdateModuleRequest():
        return 'UpdateModuleRequest';
      case _i64.UpdateTaskRequest():
        return 'UpdateTaskRequest';
      case _i65.UpsertTaskOptionsRequest():
        return 'UpsertTaskOptionsRequest';
      case _i66.UpsertTaskTestCasesRequest():
        return 'UpsertTaskTestCasesRequest';
      case _i67.AiResponse():
        return 'AiResponse';
      case _i68.UserWallet():
        return 'UserWallet';
    }
    className = _i80.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i81.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'GovernanceUserDto') {
      return deserialize<_i24.GovernanceUserDto>(data['data']);
    }
    if (dataClassName == 'LessonCompletionResultDto') {
      return deserialize<_i25.LessonCompletionResultDto>(data['data']);
    }
    if (dataClassName == 'LessonContentBlockDto') {
      return deserialize<_i26.LessonContentBlockDto>(data['data']);
    }
    if (dataClassName == 'LessonContentDocumentDto') {
      return deserialize<_i27.LessonContentDocumentDto>(data['data']);
    }
    if (dataClassName == 'LessonDto') {
      return deserialize<_i28.LessonDto>(data['data']);
    }
    if (dataClassName == 'ModuleDto') {
      return deserialize<_i29.ModuleDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerResultDto') {
      return deserialize<_i30.TaskAnswerResultDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerTestCaseResultDto') {
      return deserialize<_i31.TaskAnswerTestCaseResultDto>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i32.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskOptionDto') {
      return deserialize<_i33.TaskOptionDto>(data['data']);
    }
    if (dataClassName == 'TaskTestCaseDto') {
      return deserialize<_i34.TaskTestCaseDto>(data['data']);
    }
    if (dataClassName == 'UserStatisticsDto') {
      return deserialize<_i35.UserStatisticsDto>(data['data']);
    }
    if (dataClassName == 'WalletBalanceDto') {
      return deserialize<_i36.WalletBalanceDto>(data['data']);
    }
    if (dataClassName == 'AdaptiveLearningPathType') {
      return deserialize<_i37.AdaptiveLearningPathType>(data['data']);
    }
    if (dataClassName == 'CoinTransactionType') {
      return deserialize<_i38.CoinTransactionType>(data['data']);
    }
    if (dataClassName == 'ContentStatus') {
      return deserialize<_i39.ContentStatus>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationAuthScheme') {
      return deserialize<_i40.ExternalIntegrationAuthScheme>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationKind') {
      return deserialize<_i41.ExternalIntegrationKind>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationProvider') {
      return deserialize<_i42.ExternalIntegrationProvider>(data['data']);
    }
    if (dataClassName == 'LessonContentBlockType') {
      return deserialize<_i43.LessonContentBlockType>(data['data']);
    }
    if (dataClassName == 'TaskType') {
      return deserialize<_i44.TaskType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i45.UserRole>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i46.NotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i47.ValidationException>(data['data']);
    }
    if (dataClassName == 'CompleteLessonSessionRequest') {
      return deserialize<_i48.CompleteLessonSessionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCoinTransactionRequest') {
      return deserialize<_i49.CreateCoinTransactionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCourseRequest') {
      return deserialize<_i50.CreateCourseRequest>(data['data']);
    }
    if (dataClassName == 'CreateLessonRequest') {
      return deserialize<_i51.CreateLessonRequest>(data['data']);
    }
    if (dataClassName == 'CreateModuleRequest') {
      return deserialize<_i52.CreateModuleRequest>(data['data']);
    }
    if (dataClassName == 'CreateTaskRequest') {
      return deserialize<_i53.CreateTaskRequest>(data['data']);
    }
    if (dataClassName == 'GenerateExplanationRequest') {
      return deserialize<_i54.GenerateExplanationRequest>(data['data']);
    }
    if (dataClassName == 'GenerateHintRequest') {
      return deserialize<_i55.GenerateHintRequest>(data['data']);
    }
    if (dataClassName == 'ProvisionExternalVideoSessionRequest') {
      return deserialize<_i56.ProvisionExternalVideoSessionRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'ReorderLessonsRequest') {
      return deserialize<_i57.ReorderLessonsRequest>(data['data']);
    }
    if (dataClassName == 'ReorderModulesRequest') {
      return deserialize<_i58.ReorderModulesRequest>(data['data']);
    }
    if (dataClassName == 'ReorderTasksRequest') {
      return deserialize<_i59.ReorderTasksRequest>(data['data']);
    }
    if (dataClassName == 'SyncCourseToExternalProviderRequest') {
      return deserialize<_i60.SyncCourseToExternalProviderRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'UpdateCourseRequest') {
      return deserialize<_i61.UpdateCourseRequest>(data['data']);
    }
    if (dataClassName == 'UpdateLessonRequest') {
      return deserialize<_i62.UpdateLessonRequest>(data['data']);
    }
    if (dataClassName == 'UpdateModuleRequest') {
      return deserialize<_i63.UpdateModuleRequest>(data['data']);
    }
    if (dataClassName == 'UpdateTaskRequest') {
      return deserialize<_i64.UpdateTaskRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskOptionsRequest') {
      return deserialize<_i65.UpsertTaskOptionsRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskTestCasesRequest') {
      return deserialize<_i66.UpsertTaskTestCasesRequest>(data['data']);
    }
    if (dataClassName == 'AiResponse') {
      return deserialize<_i67.AiResponse>(data['data']);
    }
    if (dataClassName == 'UserWallet') {
      return deserialize<_i68.UserWallet>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i80.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i81.Protocol().deserializeByClassName(data);
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
      return _i80.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i81.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
