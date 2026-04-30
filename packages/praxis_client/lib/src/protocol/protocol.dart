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
import 'dto/cms_media_dto.dart' as _i6;
import 'dto/cms_task_option_input_dto.dart' as _i7;
import 'dto/cms_task_test_case_input_dto.dart' as _i8;
import 'dto/coin_transaction_dto.dart' as _i9;
import 'dto/course_analytics_dashboard_dto.dart' as _i10;
import 'dto/course_analytics_lesson_dto.dart' as _i11;
import 'dto/course_analytics_summary_dto.dart' as _i12;
import 'dto/course_analytics_task_dto.dart' as _i13;
import 'dto/course_analytics_wrong_answer_dto.dart' as _i14;
import 'dto/course_detail_dto.dart' as _i15;
import 'dto/course_dto.dart' as _i16;
import 'dto/course_import_lesson_dto.dart' as _i17;
import 'dto/course_import_module_dto.dart' as _i18;
import 'dto/course_import_result_dto.dart' as _i19;
import 'dto/course_import_task_dto.dart' as _i20;
import 'dto/course_recommendation_dto.dart' as _i21;
import 'dto/course_structure_dto.dart' as _i22;
import 'dto/course_structure_lesson_dto.dart' as _i23;
import 'dto/course_structure_module_dto.dart' as _i24;
import 'dto/course_structure_task_dto.dart' as _i25;
import 'dto/external_course_sync_dto.dart' as _i26;
import 'dto/external_integration_provider_dto.dart' as _i27;
import 'dto/external_video_session_dto.dart' as _i28;
import 'dto/governance_user_dto.dart' as _i29;
import 'dto/lesson_completion_result_dto.dart' as _i30;
import 'dto/lesson_content_block_dto.dart' as _i31;
import 'dto/lesson_content_document_dto.dart' as _i32;
import 'dto/lesson_dto.dart' as _i33;
import 'dto/module_dto.dart' as _i34;
import 'dto/task_answer_result_dto.dart' as _i35;
import 'dto/task_answer_test_case_result_dto.dart' as _i36;
import 'dto/task_dto.dart' as _i37;
import 'dto/task_option_dto.dart' as _i38;
import 'dto/task_test_case_dto.dart' as _i39;
import 'dto/user_statistics_dto.dart' as _i40;
import 'dto/wallet_balance_dto.dart' as _i41;
import 'enums/adaptive_learning_path_type.dart' as _i42;
import 'enums/coin_transaction_type.dart' as _i43;
import 'enums/content_status.dart' as _i44;
import 'enums/external_integration_auth_scheme.dart' as _i45;
import 'enums/external_integration_kind.dart' as _i46;
import 'enums/external_integration_provider.dart' as _i47;
import 'enums/lesson_content_block_type.dart' as _i48;
import 'enums/task_type.dart' as _i49;
import 'enums/user_role.dart' as _i50;
import 'exceptions/not_found_exception.dart' as _i51;
import 'exceptions/validation_exception.dart' as _i52;
import 'requests/complete_lesson_session_request.dart' as _i53;
import 'requests/create_coin_transaction_request.dart' as _i54;
import 'requests/create_course_request.dart' as _i55;
import 'requests/create_lesson_request.dart' as _i56;
import 'requests/create_module_request.dart' as _i57;
import 'requests/create_task_request.dart' as _i58;
import 'requests/generate_explanation_request.dart' as _i59;
import 'requests/generate_hint_request.dart' as _i60;
import 'requests/import_course_request.dart' as _i61;
import 'requests/provision_external_video_session_request.dart' as _i62;
import 'requests/reorder_lessons_request.dart' as _i63;
import 'requests/reorder_modules_request.dart' as _i64;
import 'requests/reorder_tasks_request.dart' as _i65;
import 'requests/sync_course_to_external_provider_request.dart' as _i66;
import 'requests/update_course_request.dart' as _i67;
import 'requests/update_lesson_request.dart' as _i68;
import 'requests/update_module_request.dart' as _i69;
import 'requests/update_task_request.dart' as _i70;
import 'requests/upload_cms_media_request.dart' as _i71;
import 'requests/upsert_task_options_request.dart' as _i72;
import 'requests/upsert_task_test_cases_request.dart' as _i73;
import 'responses/ai_response.dart' as _i74;
import 'tables/user_wallet_table.dart' as _i75;
import 'package:praxis_client/src/protocol/dto/achievement_dto.dart' as _i76;
import 'package:praxis_client/src/protocol/dto/governance_user_dto.dart'
    as _i77;
import 'package:praxis_client/src/protocol/dto/course_dto.dart' as _i78;
import 'package:praxis_client/src/protocol/dto/course_recommendation_dto.dart'
    as _i79;
import 'package:praxis_client/src/protocol/dto/external_integration_provider_dto.dart'
    as _i80;
import 'package:praxis_client/src/protocol/dto/lesson_dto.dart' as _i81;
import 'package:praxis_client/src/protocol/dto/module_dto.dart' as _i82;
import 'package:praxis_client/src/protocol/dto/task_dto.dart' as _i83;
import 'package:praxis_client/src/protocol/dto/task_option_dto.dart' as _i84;
import 'package:praxis_client/src/protocol/dto/task_test_case_dto.dart' as _i85;
import 'package:praxis_client/src/protocol/dto/coin_transaction_dto.dart'
    as _i86;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i87;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i88;
export 'dto/access_profile_dto.dart';
export 'dto/achievement_dto.dart';
export 'dto/adaptive_learning_path_dto.dart';
export 'dto/adaptive_topic_mastery_dto.dart';
export 'dto/cms_media_dto.dart';
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
export 'dto/course_import_lesson_dto.dart';
export 'dto/course_import_module_dto.dart';
export 'dto/course_import_result_dto.dart';
export 'dto/course_import_task_dto.dart';
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
export 'requests/import_course_request.dart';
export 'requests/provision_external_video_session_request.dart';
export 'requests/reorder_lessons_request.dart';
export 'requests/reorder_modules_request.dart';
export 'requests/reorder_tasks_request.dart';
export 'requests/sync_course_to_external_provider_request.dart';
export 'requests/update_course_request.dart';
export 'requests/update_lesson_request.dart';
export 'requests/update_module_request.dart';
export 'requests/update_task_request.dart';
export 'requests/upload_cms_media_request.dart';
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
    if (t == _i6.CmsMediaDto) {
      return _i6.CmsMediaDto.fromJson(data) as T;
    }
    if (t == _i7.CmsTaskOptionInputDto) {
      return _i7.CmsTaskOptionInputDto.fromJson(data) as T;
    }
    if (t == _i8.CmsTaskTestCaseInputDto) {
      return _i8.CmsTaskTestCaseInputDto.fromJson(data) as T;
    }
    if (t == _i9.CoinTransactionDto) {
      return _i9.CoinTransactionDto.fromJson(data) as T;
    }
    if (t == _i10.CourseAnalyticsDashboardDto) {
      return _i10.CourseAnalyticsDashboardDto.fromJson(data) as T;
    }
    if (t == _i11.CourseAnalyticsLessonDto) {
      return _i11.CourseAnalyticsLessonDto.fromJson(data) as T;
    }
    if (t == _i12.CourseAnalyticsSummaryDto) {
      return _i12.CourseAnalyticsSummaryDto.fromJson(data) as T;
    }
    if (t == _i13.CourseAnalyticsTaskDto) {
      return _i13.CourseAnalyticsTaskDto.fromJson(data) as T;
    }
    if (t == _i14.CourseAnalyticsWrongAnswerDto) {
      return _i14.CourseAnalyticsWrongAnswerDto.fromJson(data) as T;
    }
    if (t == _i15.CourseDetailDto) {
      return _i15.CourseDetailDto.fromJson(data) as T;
    }
    if (t == _i16.CourseDto) {
      return _i16.CourseDto.fromJson(data) as T;
    }
    if (t == _i17.CourseImportLessonDto) {
      return _i17.CourseImportLessonDto.fromJson(data) as T;
    }
    if (t == _i18.CourseImportModuleDto) {
      return _i18.CourseImportModuleDto.fromJson(data) as T;
    }
    if (t == _i19.CourseImportResultDto) {
      return _i19.CourseImportResultDto.fromJson(data) as T;
    }
    if (t == _i20.CourseImportTaskDto) {
      return _i20.CourseImportTaskDto.fromJson(data) as T;
    }
    if (t == _i21.CourseRecommendationDto) {
      return _i21.CourseRecommendationDto.fromJson(data) as T;
    }
    if (t == _i22.CourseStructureDto) {
      return _i22.CourseStructureDto.fromJson(data) as T;
    }
    if (t == _i23.CourseStructureLessonDto) {
      return _i23.CourseStructureLessonDto.fromJson(data) as T;
    }
    if (t == _i24.CourseStructureModuleDto) {
      return _i24.CourseStructureModuleDto.fromJson(data) as T;
    }
    if (t == _i25.CourseStructureTaskDto) {
      return _i25.CourseStructureTaskDto.fromJson(data) as T;
    }
    if (t == _i26.ExternalCourseSyncDto) {
      return _i26.ExternalCourseSyncDto.fromJson(data) as T;
    }
    if (t == _i27.ExternalIntegrationProviderDto) {
      return _i27.ExternalIntegrationProviderDto.fromJson(data) as T;
    }
    if (t == _i28.ExternalVideoSessionDto) {
      return _i28.ExternalVideoSessionDto.fromJson(data) as T;
    }
    if (t == _i29.GovernanceUserDto) {
      return _i29.GovernanceUserDto.fromJson(data) as T;
    }
    if (t == _i30.LessonCompletionResultDto) {
      return _i30.LessonCompletionResultDto.fromJson(data) as T;
    }
    if (t == _i31.LessonContentBlockDto) {
      return _i31.LessonContentBlockDto.fromJson(data) as T;
    }
    if (t == _i32.LessonContentDocumentDto) {
      return _i32.LessonContentDocumentDto.fromJson(data) as T;
    }
    if (t == _i33.LessonDto) {
      return _i33.LessonDto.fromJson(data) as T;
    }
    if (t == _i34.ModuleDto) {
      return _i34.ModuleDto.fromJson(data) as T;
    }
    if (t == _i35.TaskAnswerResultDto) {
      return _i35.TaskAnswerResultDto.fromJson(data) as T;
    }
    if (t == _i36.TaskAnswerTestCaseResultDto) {
      return _i36.TaskAnswerTestCaseResultDto.fromJson(data) as T;
    }
    if (t == _i37.TaskDto) {
      return _i37.TaskDto.fromJson(data) as T;
    }
    if (t == _i38.TaskOptionDto) {
      return _i38.TaskOptionDto.fromJson(data) as T;
    }
    if (t == _i39.TaskTestCaseDto) {
      return _i39.TaskTestCaseDto.fromJson(data) as T;
    }
    if (t == _i40.UserStatisticsDto) {
      return _i40.UserStatisticsDto.fromJson(data) as T;
    }
    if (t == _i41.WalletBalanceDto) {
      return _i41.WalletBalanceDto.fromJson(data) as T;
    }
    if (t == _i42.AdaptiveLearningPathType) {
      return _i42.AdaptiveLearningPathType.fromJson(data) as T;
    }
    if (t == _i43.CoinTransactionType) {
      return _i43.CoinTransactionType.fromJson(data) as T;
    }
    if (t == _i44.ContentStatus) {
      return _i44.ContentStatus.fromJson(data) as T;
    }
    if (t == _i45.ExternalIntegrationAuthScheme) {
      return _i45.ExternalIntegrationAuthScheme.fromJson(data) as T;
    }
    if (t == _i46.ExternalIntegrationKind) {
      return _i46.ExternalIntegrationKind.fromJson(data) as T;
    }
    if (t == _i47.ExternalIntegrationProvider) {
      return _i47.ExternalIntegrationProvider.fromJson(data) as T;
    }
    if (t == _i48.LessonContentBlockType) {
      return _i48.LessonContentBlockType.fromJson(data) as T;
    }
    if (t == _i49.TaskType) {
      return _i49.TaskType.fromJson(data) as T;
    }
    if (t == _i50.UserRole) {
      return _i50.UserRole.fromJson(data) as T;
    }
    if (t == _i51.NotFoundException) {
      return _i51.NotFoundException.fromJson(data) as T;
    }
    if (t == _i52.ValidationException) {
      return _i52.ValidationException.fromJson(data) as T;
    }
    if (t == _i53.CompleteLessonSessionRequest) {
      return _i53.CompleteLessonSessionRequest.fromJson(data) as T;
    }
    if (t == _i54.CreateCoinTransactionRequest) {
      return _i54.CreateCoinTransactionRequest.fromJson(data) as T;
    }
    if (t == _i55.CreateCourseRequest) {
      return _i55.CreateCourseRequest.fromJson(data) as T;
    }
    if (t == _i56.CreateLessonRequest) {
      return _i56.CreateLessonRequest.fromJson(data) as T;
    }
    if (t == _i57.CreateModuleRequest) {
      return _i57.CreateModuleRequest.fromJson(data) as T;
    }
    if (t == _i58.CreateTaskRequest) {
      return _i58.CreateTaskRequest.fromJson(data) as T;
    }
    if (t == _i59.GenerateExplanationRequest) {
      return _i59.GenerateExplanationRequest.fromJson(data) as T;
    }
    if (t == _i60.GenerateHintRequest) {
      return _i60.GenerateHintRequest.fromJson(data) as T;
    }
    if (t == _i61.ImportCourseRequest) {
      return _i61.ImportCourseRequest.fromJson(data) as T;
    }
    if (t == _i62.ProvisionExternalVideoSessionRequest) {
      return _i62.ProvisionExternalVideoSessionRequest.fromJson(data) as T;
    }
    if (t == _i63.ReorderLessonsRequest) {
      return _i63.ReorderLessonsRequest.fromJson(data) as T;
    }
    if (t == _i64.ReorderModulesRequest) {
      return _i64.ReorderModulesRequest.fromJson(data) as T;
    }
    if (t == _i65.ReorderTasksRequest) {
      return _i65.ReorderTasksRequest.fromJson(data) as T;
    }
    if (t == _i66.SyncCourseToExternalProviderRequest) {
      return _i66.SyncCourseToExternalProviderRequest.fromJson(data) as T;
    }
    if (t == _i67.UpdateCourseRequest) {
      return _i67.UpdateCourseRequest.fromJson(data) as T;
    }
    if (t == _i68.UpdateLessonRequest) {
      return _i68.UpdateLessonRequest.fromJson(data) as T;
    }
    if (t == _i69.UpdateModuleRequest) {
      return _i69.UpdateModuleRequest.fromJson(data) as T;
    }
    if (t == _i70.UpdateTaskRequest) {
      return _i70.UpdateTaskRequest.fromJson(data) as T;
    }
    if (t == _i71.UploadCmsMediaRequest) {
      return _i71.UploadCmsMediaRequest.fromJson(data) as T;
    }
    if (t == _i72.UpsertTaskOptionsRequest) {
      return _i72.UpsertTaskOptionsRequest.fromJson(data) as T;
    }
    if (t == _i73.UpsertTaskTestCasesRequest) {
      return _i73.UpsertTaskTestCasesRequest.fromJson(data) as T;
    }
    if (t == _i74.AiResponse) {
      return _i74.AiResponse.fromJson(data) as T;
    }
    if (t == _i75.UserWallet) {
      return _i75.UserWallet.fromJson(data) as T;
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
    if (t == _i1.getType<_i6.CmsMediaDto?>()) {
      return (data != null ? _i6.CmsMediaDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CmsTaskOptionInputDto?>()) {
      return (data != null ? _i7.CmsTaskOptionInputDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.CmsTaskTestCaseInputDto?>()) {
      return (data != null ? _i8.CmsTaskTestCaseInputDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.CoinTransactionDto?>()) {
      return (data != null ? _i9.CoinTransactionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CourseAnalyticsDashboardDto?>()) {
      return (data != null
              ? _i10.CourseAnalyticsDashboardDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.CourseAnalyticsLessonDto?>()) {
      return (data != null
              ? _i11.CourseAnalyticsLessonDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i12.CourseAnalyticsSummaryDto?>()) {
      return (data != null
              ? _i12.CourseAnalyticsSummaryDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.CourseAnalyticsTaskDto?>()) {
      return (data != null ? _i13.CourseAnalyticsTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.CourseAnalyticsWrongAnswerDto?>()) {
      return (data != null
              ? _i14.CourseAnalyticsWrongAnswerDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.CourseDetailDto?>()) {
      return (data != null ? _i15.CourseDetailDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CourseDto?>()) {
      return (data != null ? _i16.CourseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CourseImportLessonDto?>()) {
      return (data != null ? _i17.CourseImportLessonDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.CourseImportModuleDto?>()) {
      return (data != null ? _i18.CourseImportModuleDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.CourseImportResultDto?>()) {
      return (data != null ? _i19.CourseImportResultDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.CourseImportTaskDto?>()) {
      return (data != null ? _i20.CourseImportTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.CourseRecommendationDto?>()) {
      return (data != null ? _i21.CourseRecommendationDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.CourseStructureDto?>()) {
      return (data != null ? _i22.CourseStructureDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.CourseStructureLessonDto?>()) {
      return (data != null
              ? _i23.CourseStructureLessonDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i24.CourseStructureModuleDto?>()) {
      return (data != null
              ? _i24.CourseStructureModuleDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i25.CourseStructureTaskDto?>()) {
      return (data != null ? _i25.CourseStructureTaskDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.ExternalCourseSyncDto?>()) {
      return (data != null ? _i26.ExternalCourseSyncDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.ExternalIntegrationProviderDto?>()) {
      return (data != null
              ? _i27.ExternalIntegrationProviderDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i28.ExternalVideoSessionDto?>()) {
      return (data != null ? _i28.ExternalVideoSessionDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.GovernanceUserDto?>()) {
      return (data != null ? _i29.GovernanceUserDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.LessonCompletionResultDto?>()) {
      return (data != null
              ? _i30.LessonCompletionResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i31.LessonContentBlockDto?>()) {
      return (data != null ? _i31.LessonContentBlockDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.LessonContentDocumentDto?>()) {
      return (data != null
              ? _i32.LessonContentDocumentDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i33.LessonDto?>()) {
      return (data != null ? _i33.LessonDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.ModuleDto?>()) {
      return (data != null ? _i34.ModuleDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.TaskAnswerResultDto?>()) {
      return (data != null ? _i35.TaskAnswerResultDto.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.TaskAnswerTestCaseResultDto?>()) {
      return (data != null
              ? _i36.TaskAnswerTestCaseResultDto.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i37.TaskDto?>()) {
      return (data != null ? _i37.TaskDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.TaskOptionDto?>()) {
      return (data != null ? _i38.TaskOptionDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.TaskTestCaseDto?>()) {
      return (data != null ? _i39.TaskTestCaseDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.UserStatisticsDto?>()) {
      return (data != null ? _i40.UserStatisticsDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.WalletBalanceDto?>()) {
      return (data != null ? _i41.WalletBalanceDto.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.AdaptiveLearningPathType?>()) {
      return (data != null
              ? _i42.AdaptiveLearningPathType.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i43.CoinTransactionType?>()) {
      return (data != null ? _i43.CoinTransactionType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.ContentStatus?>()) {
      return (data != null ? _i44.ContentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ExternalIntegrationAuthScheme?>()) {
      return (data != null
              ? _i45.ExternalIntegrationAuthScheme.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i46.ExternalIntegrationKind?>()) {
      return (data != null ? _i46.ExternalIntegrationKind.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.ExternalIntegrationProvider?>()) {
      return (data != null
              ? _i47.ExternalIntegrationProvider.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i48.LessonContentBlockType?>()) {
      return (data != null ? _i48.LessonContentBlockType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.TaskType?>()) {
      return (data != null ? _i49.TaskType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.UserRole?>()) {
      return (data != null ? _i50.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.NotFoundException?>()) {
      return (data != null ? _i51.NotFoundException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ValidationException?>()) {
      return (data != null ? _i52.ValidationException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.CompleteLessonSessionRequest?>()) {
      return (data != null
              ? _i53.CompleteLessonSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i54.CreateCoinTransactionRequest?>()) {
      return (data != null
              ? _i54.CreateCoinTransactionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i55.CreateCourseRequest?>()) {
      return (data != null ? _i55.CreateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.CreateLessonRequest?>()) {
      return (data != null ? _i56.CreateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.CreateModuleRequest?>()) {
      return (data != null ? _i57.CreateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.CreateTaskRequest?>()) {
      return (data != null ? _i58.CreateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.GenerateExplanationRequest?>()) {
      return (data != null
              ? _i59.GenerateExplanationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i60.GenerateHintRequest?>()) {
      return (data != null ? _i60.GenerateHintRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.ImportCourseRequest?>()) {
      return (data != null ? _i61.ImportCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.ProvisionExternalVideoSessionRequest?>()) {
      return (data != null
              ? _i62.ProvisionExternalVideoSessionRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i63.ReorderLessonsRequest?>()) {
      return (data != null ? _i63.ReorderLessonsRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.ReorderModulesRequest?>()) {
      return (data != null ? _i64.ReorderModulesRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.ReorderTasksRequest?>()) {
      return (data != null ? _i65.ReorderTasksRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.SyncCourseToExternalProviderRequest?>()) {
      return (data != null
              ? _i66.SyncCourseToExternalProviderRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i67.UpdateCourseRequest?>()) {
      return (data != null ? _i67.UpdateCourseRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.UpdateLessonRequest?>()) {
      return (data != null ? _i68.UpdateLessonRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.UpdateModuleRequest?>()) {
      return (data != null ? _i69.UpdateModuleRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.UpdateTaskRequest?>()) {
      return (data != null ? _i70.UpdateTaskRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.UploadCmsMediaRequest?>()) {
      return (data != null ? _i71.UploadCmsMediaRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.UpsertTaskOptionsRequest?>()) {
      return (data != null
              ? _i72.UpsertTaskOptionsRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i73.UpsertTaskTestCasesRequest?>()) {
      return (data != null
              ? _i73.UpsertTaskTestCasesRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i74.AiResponse?>()) {
      return (data != null ? _i74.AiResponse.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.UserWallet?>()) {
      return (data != null ? _i75.UserWallet.fromJson(data) : null) as T;
    }
    if (t == List<_i50.UserRole>) {
      return (data as List).map((e) => deserialize<_i50.UserRole>(e)).toList()
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
    if (t == List<_i11.CourseAnalyticsLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i11.CourseAnalyticsLessonDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i13.CourseAnalyticsTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i13.CourseAnalyticsTaskDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i14.CourseAnalyticsWrongAnswerDto>) {
      return (data as List)
              .map((e) => deserialize<_i14.CourseAnalyticsWrongAnswerDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i34.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i34.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i33.LessonDto>) {
      return (data as List).map((e) => deserialize<_i33.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i37.TaskDto>) {
      return (data as List).map((e) => deserialize<_i37.TaskDto>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i20.CourseImportTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i20.CourseImportTaskDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.CourseImportTaskDto>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.CourseImportTaskDto>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i17.CourseImportLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i17.CourseImportLessonDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.CourseImportLessonDto>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.CourseImportLessonDto>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i7.CmsTaskOptionInputDto>) {
      return (data as List)
              .map((e) => deserialize<_i7.CmsTaskOptionInputDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.CmsTaskOptionInputDto>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7.CmsTaskOptionInputDto>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8.CmsTaskTestCaseInputDto>) {
      return (data as List)
              .map((e) => deserialize<_i8.CmsTaskTestCaseInputDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.CmsTaskTestCaseInputDto>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.CmsTaskTestCaseInputDto>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i24.CourseStructureModuleDto>) {
      return (data as List)
              .map((e) => deserialize<_i24.CourseStructureModuleDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i25.CourseStructureTaskDto>) {
      return (data as List)
              .map((e) => deserialize<_i25.CourseStructureTaskDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.CourseStructureLessonDto>) {
      return (data as List)
              .map((e) => deserialize<_i23.CourseStructureLessonDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i3.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i3.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.LessonContentBlockDto>) {
      return (data as List)
              .map((e) => deserialize<_i31.LessonContentBlockDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i36.TaskAnswerTestCaseResultDto>) {
      return (data as List)
              .map((e) => deserialize<_i36.TaskAnswerTestCaseResultDto>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i36.TaskAnswerTestCaseResultDto>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i36.TaskAnswerTestCaseResultDto>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i38.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i38.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i39.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i18.CourseImportModuleDto>) {
      return (data as List)
              .map((e) => deserialize<_i18.CourseImportModuleDto>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<_i76.AchievementDto>) {
      return (data as List)
              .map((e) => deserialize<_i76.AchievementDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i77.GovernanceUserDto>) {
      return (data as List)
              .map((e) => deserialize<_i77.GovernanceUserDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.CourseDto>) {
      return (data as List).map((e) => deserialize<_i78.CourseDto>(e)).toList()
          as T;
    }
    if (t == List<_i79.CourseRecommendationDto>) {
      return (data as List)
              .map((e) => deserialize<_i79.CourseRecommendationDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i80.ExternalIntegrationProviderDto>) {
      return (data as List)
              .map((e) => deserialize<_i80.ExternalIntegrationProviderDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i81.LessonDto>) {
      return (data as List).map((e) => deserialize<_i81.LessonDto>(e)).toList()
          as T;
    }
    if (t == List<_i82.ModuleDto>) {
      return (data as List).map((e) => deserialize<_i82.ModuleDto>(e)).toList()
          as T;
    }
    if (t == List<_i83.TaskDto>) {
      return (data as List).map((e) => deserialize<_i83.TaskDto>(e)).toList()
          as T;
    }
    if (t == List<_i84.TaskOptionDto>) {
      return (data as List)
              .map((e) => deserialize<_i84.TaskOptionDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i85.TaskTestCaseDto>) {
      return (data as List)
              .map((e) => deserialize<_i85.TaskTestCaseDto>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.CoinTransactionDto>) {
      return (data as List)
              .map((e) => deserialize<_i86.CoinTransactionDto>(e))
              .toList()
          as T;
    }
    try {
      return _i87.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i88.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.AccessProfileDto => 'AccessProfileDto',
      _i3.AchievementDto => 'AchievementDto',
      _i4.AdaptiveLearningPathDto => 'AdaptiveLearningPathDto',
      _i5.AdaptiveTopicMasteryDto => 'AdaptiveTopicMasteryDto',
      _i6.CmsMediaDto => 'CmsMediaDto',
      _i7.CmsTaskOptionInputDto => 'CmsTaskOptionInputDto',
      _i8.CmsTaskTestCaseInputDto => 'CmsTaskTestCaseInputDto',
      _i9.CoinTransactionDto => 'CoinTransactionDto',
      _i10.CourseAnalyticsDashboardDto => 'CourseAnalyticsDashboardDto',
      _i11.CourseAnalyticsLessonDto => 'CourseAnalyticsLessonDto',
      _i12.CourseAnalyticsSummaryDto => 'CourseAnalyticsSummaryDto',
      _i13.CourseAnalyticsTaskDto => 'CourseAnalyticsTaskDto',
      _i14.CourseAnalyticsWrongAnswerDto => 'CourseAnalyticsWrongAnswerDto',
      _i15.CourseDetailDto => 'CourseDetailDto',
      _i16.CourseDto => 'CourseDto',
      _i17.CourseImportLessonDto => 'CourseImportLessonDto',
      _i18.CourseImportModuleDto => 'CourseImportModuleDto',
      _i19.CourseImportResultDto => 'CourseImportResultDto',
      _i20.CourseImportTaskDto => 'CourseImportTaskDto',
      _i21.CourseRecommendationDto => 'CourseRecommendationDto',
      _i22.CourseStructureDto => 'CourseStructureDto',
      _i23.CourseStructureLessonDto => 'CourseStructureLessonDto',
      _i24.CourseStructureModuleDto => 'CourseStructureModuleDto',
      _i25.CourseStructureTaskDto => 'CourseStructureTaskDto',
      _i26.ExternalCourseSyncDto => 'ExternalCourseSyncDto',
      _i27.ExternalIntegrationProviderDto => 'ExternalIntegrationProviderDto',
      _i28.ExternalVideoSessionDto => 'ExternalVideoSessionDto',
      _i29.GovernanceUserDto => 'GovernanceUserDto',
      _i30.LessonCompletionResultDto => 'LessonCompletionResultDto',
      _i31.LessonContentBlockDto => 'LessonContentBlockDto',
      _i32.LessonContentDocumentDto => 'LessonContentDocumentDto',
      _i33.LessonDto => 'LessonDto',
      _i34.ModuleDto => 'ModuleDto',
      _i35.TaskAnswerResultDto => 'TaskAnswerResultDto',
      _i36.TaskAnswerTestCaseResultDto => 'TaskAnswerTestCaseResultDto',
      _i37.TaskDto => 'TaskDto',
      _i38.TaskOptionDto => 'TaskOptionDto',
      _i39.TaskTestCaseDto => 'TaskTestCaseDto',
      _i40.UserStatisticsDto => 'UserStatisticsDto',
      _i41.WalletBalanceDto => 'WalletBalanceDto',
      _i42.AdaptiveLearningPathType => 'AdaptiveLearningPathType',
      _i43.CoinTransactionType => 'CoinTransactionType',
      _i44.ContentStatus => 'ContentStatus',
      _i45.ExternalIntegrationAuthScheme => 'ExternalIntegrationAuthScheme',
      _i46.ExternalIntegrationKind => 'ExternalIntegrationKind',
      _i47.ExternalIntegrationProvider => 'ExternalIntegrationProvider',
      _i48.LessonContentBlockType => 'LessonContentBlockType',
      _i49.TaskType => 'TaskType',
      _i50.UserRole => 'UserRole',
      _i51.NotFoundException => 'NotFoundException',
      _i52.ValidationException => 'ValidationException',
      _i53.CompleteLessonSessionRequest => 'CompleteLessonSessionRequest',
      _i54.CreateCoinTransactionRequest => 'CreateCoinTransactionRequest',
      _i55.CreateCourseRequest => 'CreateCourseRequest',
      _i56.CreateLessonRequest => 'CreateLessonRequest',
      _i57.CreateModuleRequest => 'CreateModuleRequest',
      _i58.CreateTaskRequest => 'CreateTaskRequest',
      _i59.GenerateExplanationRequest => 'GenerateExplanationRequest',
      _i60.GenerateHintRequest => 'GenerateHintRequest',
      _i61.ImportCourseRequest => 'ImportCourseRequest',
      _i62.ProvisionExternalVideoSessionRequest =>
        'ProvisionExternalVideoSessionRequest',
      _i63.ReorderLessonsRequest => 'ReorderLessonsRequest',
      _i64.ReorderModulesRequest => 'ReorderModulesRequest',
      _i65.ReorderTasksRequest => 'ReorderTasksRequest',
      _i66.SyncCourseToExternalProviderRequest =>
        'SyncCourseToExternalProviderRequest',
      _i67.UpdateCourseRequest => 'UpdateCourseRequest',
      _i68.UpdateLessonRequest => 'UpdateLessonRequest',
      _i69.UpdateModuleRequest => 'UpdateModuleRequest',
      _i70.UpdateTaskRequest => 'UpdateTaskRequest',
      _i71.UploadCmsMediaRequest => 'UploadCmsMediaRequest',
      _i72.UpsertTaskOptionsRequest => 'UpsertTaskOptionsRequest',
      _i73.UpsertTaskTestCasesRequest => 'UpsertTaskTestCasesRequest',
      _i74.AiResponse => 'AiResponse',
      _i75.UserWallet => 'UserWallet',
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
      case _i6.CmsMediaDto():
        return 'CmsMediaDto';
      case _i7.CmsTaskOptionInputDto():
        return 'CmsTaskOptionInputDto';
      case _i8.CmsTaskTestCaseInputDto():
        return 'CmsTaskTestCaseInputDto';
      case _i9.CoinTransactionDto():
        return 'CoinTransactionDto';
      case _i10.CourseAnalyticsDashboardDto():
        return 'CourseAnalyticsDashboardDto';
      case _i11.CourseAnalyticsLessonDto():
        return 'CourseAnalyticsLessonDto';
      case _i12.CourseAnalyticsSummaryDto():
        return 'CourseAnalyticsSummaryDto';
      case _i13.CourseAnalyticsTaskDto():
        return 'CourseAnalyticsTaskDto';
      case _i14.CourseAnalyticsWrongAnswerDto():
        return 'CourseAnalyticsWrongAnswerDto';
      case _i15.CourseDetailDto():
        return 'CourseDetailDto';
      case _i16.CourseDto():
        return 'CourseDto';
      case _i17.CourseImportLessonDto():
        return 'CourseImportLessonDto';
      case _i18.CourseImportModuleDto():
        return 'CourseImportModuleDto';
      case _i19.CourseImportResultDto():
        return 'CourseImportResultDto';
      case _i20.CourseImportTaskDto():
        return 'CourseImportTaskDto';
      case _i21.CourseRecommendationDto():
        return 'CourseRecommendationDto';
      case _i22.CourseStructureDto():
        return 'CourseStructureDto';
      case _i23.CourseStructureLessonDto():
        return 'CourseStructureLessonDto';
      case _i24.CourseStructureModuleDto():
        return 'CourseStructureModuleDto';
      case _i25.CourseStructureTaskDto():
        return 'CourseStructureTaskDto';
      case _i26.ExternalCourseSyncDto():
        return 'ExternalCourseSyncDto';
      case _i27.ExternalIntegrationProviderDto():
        return 'ExternalIntegrationProviderDto';
      case _i28.ExternalVideoSessionDto():
        return 'ExternalVideoSessionDto';
      case _i29.GovernanceUserDto():
        return 'GovernanceUserDto';
      case _i30.LessonCompletionResultDto():
        return 'LessonCompletionResultDto';
      case _i31.LessonContentBlockDto():
        return 'LessonContentBlockDto';
      case _i32.LessonContentDocumentDto():
        return 'LessonContentDocumentDto';
      case _i33.LessonDto():
        return 'LessonDto';
      case _i34.ModuleDto():
        return 'ModuleDto';
      case _i35.TaskAnswerResultDto():
        return 'TaskAnswerResultDto';
      case _i36.TaskAnswerTestCaseResultDto():
        return 'TaskAnswerTestCaseResultDto';
      case _i37.TaskDto():
        return 'TaskDto';
      case _i38.TaskOptionDto():
        return 'TaskOptionDto';
      case _i39.TaskTestCaseDto():
        return 'TaskTestCaseDto';
      case _i40.UserStatisticsDto():
        return 'UserStatisticsDto';
      case _i41.WalletBalanceDto():
        return 'WalletBalanceDto';
      case _i42.AdaptiveLearningPathType():
        return 'AdaptiveLearningPathType';
      case _i43.CoinTransactionType():
        return 'CoinTransactionType';
      case _i44.ContentStatus():
        return 'ContentStatus';
      case _i45.ExternalIntegrationAuthScheme():
        return 'ExternalIntegrationAuthScheme';
      case _i46.ExternalIntegrationKind():
        return 'ExternalIntegrationKind';
      case _i47.ExternalIntegrationProvider():
        return 'ExternalIntegrationProvider';
      case _i48.LessonContentBlockType():
        return 'LessonContentBlockType';
      case _i49.TaskType():
        return 'TaskType';
      case _i50.UserRole():
        return 'UserRole';
      case _i51.NotFoundException():
        return 'NotFoundException';
      case _i52.ValidationException():
        return 'ValidationException';
      case _i53.CompleteLessonSessionRequest():
        return 'CompleteLessonSessionRequest';
      case _i54.CreateCoinTransactionRequest():
        return 'CreateCoinTransactionRequest';
      case _i55.CreateCourseRequest():
        return 'CreateCourseRequest';
      case _i56.CreateLessonRequest():
        return 'CreateLessonRequest';
      case _i57.CreateModuleRequest():
        return 'CreateModuleRequest';
      case _i58.CreateTaskRequest():
        return 'CreateTaskRequest';
      case _i59.GenerateExplanationRequest():
        return 'GenerateExplanationRequest';
      case _i60.GenerateHintRequest():
        return 'GenerateHintRequest';
      case _i61.ImportCourseRequest():
        return 'ImportCourseRequest';
      case _i62.ProvisionExternalVideoSessionRequest():
        return 'ProvisionExternalVideoSessionRequest';
      case _i63.ReorderLessonsRequest():
        return 'ReorderLessonsRequest';
      case _i64.ReorderModulesRequest():
        return 'ReorderModulesRequest';
      case _i65.ReorderTasksRequest():
        return 'ReorderTasksRequest';
      case _i66.SyncCourseToExternalProviderRequest():
        return 'SyncCourseToExternalProviderRequest';
      case _i67.UpdateCourseRequest():
        return 'UpdateCourseRequest';
      case _i68.UpdateLessonRequest():
        return 'UpdateLessonRequest';
      case _i69.UpdateModuleRequest():
        return 'UpdateModuleRequest';
      case _i70.UpdateTaskRequest():
        return 'UpdateTaskRequest';
      case _i71.UploadCmsMediaRequest():
        return 'UploadCmsMediaRequest';
      case _i72.UpsertTaskOptionsRequest():
        return 'UpsertTaskOptionsRequest';
      case _i73.UpsertTaskTestCasesRequest():
        return 'UpsertTaskTestCasesRequest';
      case _i74.AiResponse():
        return 'AiResponse';
      case _i75.UserWallet():
        return 'UserWallet';
    }
    className = _i87.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i88.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CmsMediaDto') {
      return deserialize<_i6.CmsMediaDto>(data['data']);
    }
    if (dataClassName == 'CmsTaskOptionInputDto') {
      return deserialize<_i7.CmsTaskOptionInputDto>(data['data']);
    }
    if (dataClassName == 'CmsTaskTestCaseInputDto') {
      return deserialize<_i8.CmsTaskTestCaseInputDto>(data['data']);
    }
    if (dataClassName == 'CoinTransactionDto') {
      return deserialize<_i9.CoinTransactionDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsDashboardDto') {
      return deserialize<_i10.CourseAnalyticsDashboardDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsLessonDto') {
      return deserialize<_i11.CourseAnalyticsLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsSummaryDto') {
      return deserialize<_i12.CourseAnalyticsSummaryDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsTaskDto') {
      return deserialize<_i13.CourseAnalyticsTaskDto>(data['data']);
    }
    if (dataClassName == 'CourseAnalyticsWrongAnswerDto') {
      return deserialize<_i14.CourseAnalyticsWrongAnswerDto>(data['data']);
    }
    if (dataClassName == 'CourseDetailDto') {
      return deserialize<_i15.CourseDetailDto>(data['data']);
    }
    if (dataClassName == 'CourseDto') {
      return deserialize<_i16.CourseDto>(data['data']);
    }
    if (dataClassName == 'CourseImportLessonDto') {
      return deserialize<_i17.CourseImportLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseImportModuleDto') {
      return deserialize<_i18.CourseImportModuleDto>(data['data']);
    }
    if (dataClassName == 'CourseImportResultDto') {
      return deserialize<_i19.CourseImportResultDto>(data['data']);
    }
    if (dataClassName == 'CourseImportTaskDto') {
      return deserialize<_i20.CourseImportTaskDto>(data['data']);
    }
    if (dataClassName == 'CourseRecommendationDto') {
      return deserialize<_i21.CourseRecommendationDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureDto') {
      return deserialize<_i22.CourseStructureDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureLessonDto') {
      return deserialize<_i23.CourseStructureLessonDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureModuleDto') {
      return deserialize<_i24.CourseStructureModuleDto>(data['data']);
    }
    if (dataClassName == 'CourseStructureTaskDto') {
      return deserialize<_i25.CourseStructureTaskDto>(data['data']);
    }
    if (dataClassName == 'ExternalCourseSyncDto') {
      return deserialize<_i26.ExternalCourseSyncDto>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationProviderDto') {
      return deserialize<_i27.ExternalIntegrationProviderDto>(data['data']);
    }
    if (dataClassName == 'ExternalVideoSessionDto') {
      return deserialize<_i28.ExternalVideoSessionDto>(data['data']);
    }
    if (dataClassName == 'GovernanceUserDto') {
      return deserialize<_i29.GovernanceUserDto>(data['data']);
    }
    if (dataClassName == 'LessonCompletionResultDto') {
      return deserialize<_i30.LessonCompletionResultDto>(data['data']);
    }
    if (dataClassName == 'LessonContentBlockDto') {
      return deserialize<_i31.LessonContentBlockDto>(data['data']);
    }
    if (dataClassName == 'LessonContentDocumentDto') {
      return deserialize<_i32.LessonContentDocumentDto>(data['data']);
    }
    if (dataClassName == 'LessonDto') {
      return deserialize<_i33.LessonDto>(data['data']);
    }
    if (dataClassName == 'ModuleDto') {
      return deserialize<_i34.ModuleDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerResultDto') {
      return deserialize<_i35.TaskAnswerResultDto>(data['data']);
    }
    if (dataClassName == 'TaskAnswerTestCaseResultDto') {
      return deserialize<_i36.TaskAnswerTestCaseResultDto>(data['data']);
    }
    if (dataClassName == 'TaskDto') {
      return deserialize<_i37.TaskDto>(data['data']);
    }
    if (dataClassName == 'TaskOptionDto') {
      return deserialize<_i38.TaskOptionDto>(data['data']);
    }
    if (dataClassName == 'TaskTestCaseDto') {
      return deserialize<_i39.TaskTestCaseDto>(data['data']);
    }
    if (dataClassName == 'UserStatisticsDto') {
      return deserialize<_i40.UserStatisticsDto>(data['data']);
    }
    if (dataClassName == 'WalletBalanceDto') {
      return deserialize<_i41.WalletBalanceDto>(data['data']);
    }
    if (dataClassName == 'AdaptiveLearningPathType') {
      return deserialize<_i42.AdaptiveLearningPathType>(data['data']);
    }
    if (dataClassName == 'CoinTransactionType') {
      return deserialize<_i43.CoinTransactionType>(data['data']);
    }
    if (dataClassName == 'ContentStatus') {
      return deserialize<_i44.ContentStatus>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationAuthScheme') {
      return deserialize<_i45.ExternalIntegrationAuthScheme>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationKind') {
      return deserialize<_i46.ExternalIntegrationKind>(data['data']);
    }
    if (dataClassName == 'ExternalIntegrationProvider') {
      return deserialize<_i47.ExternalIntegrationProvider>(data['data']);
    }
    if (dataClassName == 'LessonContentBlockType') {
      return deserialize<_i48.LessonContentBlockType>(data['data']);
    }
    if (dataClassName == 'TaskType') {
      return deserialize<_i49.TaskType>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i50.UserRole>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_i51.NotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_i52.ValidationException>(data['data']);
    }
    if (dataClassName == 'CompleteLessonSessionRequest') {
      return deserialize<_i53.CompleteLessonSessionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCoinTransactionRequest') {
      return deserialize<_i54.CreateCoinTransactionRequest>(data['data']);
    }
    if (dataClassName == 'CreateCourseRequest') {
      return deserialize<_i55.CreateCourseRequest>(data['data']);
    }
    if (dataClassName == 'CreateLessonRequest') {
      return deserialize<_i56.CreateLessonRequest>(data['data']);
    }
    if (dataClassName == 'CreateModuleRequest') {
      return deserialize<_i57.CreateModuleRequest>(data['data']);
    }
    if (dataClassName == 'CreateTaskRequest') {
      return deserialize<_i58.CreateTaskRequest>(data['data']);
    }
    if (dataClassName == 'GenerateExplanationRequest') {
      return deserialize<_i59.GenerateExplanationRequest>(data['data']);
    }
    if (dataClassName == 'GenerateHintRequest') {
      return deserialize<_i60.GenerateHintRequest>(data['data']);
    }
    if (dataClassName == 'ImportCourseRequest') {
      return deserialize<_i61.ImportCourseRequest>(data['data']);
    }
    if (dataClassName == 'ProvisionExternalVideoSessionRequest') {
      return deserialize<_i62.ProvisionExternalVideoSessionRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'ReorderLessonsRequest') {
      return deserialize<_i63.ReorderLessonsRequest>(data['data']);
    }
    if (dataClassName == 'ReorderModulesRequest') {
      return deserialize<_i64.ReorderModulesRequest>(data['data']);
    }
    if (dataClassName == 'ReorderTasksRequest') {
      return deserialize<_i65.ReorderTasksRequest>(data['data']);
    }
    if (dataClassName == 'SyncCourseToExternalProviderRequest') {
      return deserialize<_i66.SyncCourseToExternalProviderRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'UpdateCourseRequest') {
      return deserialize<_i67.UpdateCourseRequest>(data['data']);
    }
    if (dataClassName == 'UpdateLessonRequest') {
      return deserialize<_i68.UpdateLessonRequest>(data['data']);
    }
    if (dataClassName == 'UpdateModuleRequest') {
      return deserialize<_i69.UpdateModuleRequest>(data['data']);
    }
    if (dataClassName == 'UpdateTaskRequest') {
      return deserialize<_i70.UpdateTaskRequest>(data['data']);
    }
    if (dataClassName == 'UploadCmsMediaRequest') {
      return deserialize<_i71.UploadCmsMediaRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskOptionsRequest') {
      return deserialize<_i72.UpsertTaskOptionsRequest>(data['data']);
    }
    if (dataClassName == 'UpsertTaskTestCasesRequest') {
      return deserialize<_i73.UpsertTaskTestCasesRequest>(data['data']);
    }
    if (dataClassName == 'AiResponse') {
      return deserialize<_i74.AiResponse>(data['data']);
    }
    if (dataClassName == 'UserWallet') {
      return deserialize<_i75.UserWallet>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i87.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i88.Protocol().deserializeByClassName(data);
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
      return _i87.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i88.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
