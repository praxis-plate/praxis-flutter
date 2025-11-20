// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Codium';

  @override
  String get displaySignUp => 'Регистрация';

  @override
  String get labelPhoneNumber => 'Номер телефона:';

  @override
  String get next => 'Далее';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPassword => 'Пароль';

  @override
  String get errorPasswordsDoNotMatch => 'Пароли не совпадают';

  @override
  String get displayAlreadyHaveAnAccount => 'Уже есть аккаунт?';

  @override
  String get displaySignIn => 'Войти';

  @override
  String get displayEmailHint => 'example@yandex.ru';

  @override
  String get displayPasswordHint => '•••••••••';

  @override
  String get displayDontHaveAnAccount => 'Нет аккаунта?';

  @override
  String get navigationMainTitle => 'Обзор';

  @override
  String get navigationLearningTitle => 'Прохожу';

  @override
  String get navigationProfileTitle => 'Профиль';

  @override
  String get mainTitle => 'Обзор';

  @override
  String get balance => 'Balance';

  @override
  String get recommend => 'Рекомендации:';

  @override
  String get courses => 'Курсы:';

  @override
  String get searchCourse => 'Найти курс...';

  @override
  String get yourBalance => 'Мой баланс:';

  @override
  String get learningTitle => 'Прохожу';

  @override
  String get streak => 'Стрик';

  @override
  String get points => 'Очки';

  @override
  String get solved => 'Решено';

  @override
  String get active => 'Активные';

  @override
  String get passed => 'Пройденные';

  @override
  String get noData => 'Нет данных';

  @override
  String get profileTitle => 'Профиль';

  @override
  String get profileSetRussian => 'Русский';

  @override
  String get profileSetDarkMode => 'Тёмный режим';

  @override
  String get profileLogOut => 'Выйти';

  @override
  String get errorEmailEmpty => 'Поле email обязательно для заполнения';

  @override
  String get errorEmailInvalid => 'Неверный формат email';

  @override
  String get errorPasswordEmpty => 'Поле пароля обязательно для заполнения';

  @override
  String get errorPasswordInvalid => 'Минимум 8 символов, буквы и цифры';

  @override
  String get errorNetworkTimeout => 'Превышено время ожидания. Проверьте подключение к интернету.';

  @override
  String get errorNetworkNoInternet => 'Нет подключения к интернету. Проверьте настройки сети.';

  @override
  String get errorNetworkGeneral => 'Ошибка сети. Попробуйте еще раз.';

  @override
  String get errorFileNotFound => 'Файл не найден. Возможно, он был перемещен или удален.';

  @override
  String get errorFilePermissionDenied => 'Доступ запрещен. Предоставьте необходимые разрешения.';

  @override
  String get errorFileInsufficientStorage => 'Недостаточно места. Освободите место и попробуйте снова.';

  @override
  String get errorFileCorrupted => 'Файл поврежден. Попробуйте импортировать другой файл.';

  @override
  String get errorFileGeneral => 'Ошибка файла. Попробуйте еще раз.';

  @override
  String get errorDatabaseLocked => 'База данных занята. Попробуйте через момент.';

  @override
  String get errorDatabaseConstraint => 'Ошибка валидации данных. Проверьте введенные данные.';

  @override
  String get errorDatabaseMigration => 'Ошибка обновления базы данных. Перезапустите приложение.';

  @override
  String get errorDatabaseGeneral => 'Ошибка базы данных. Попробуйте еще раз.';

  @override
  String get errorValidationInvalid => 'Неверные данные. Проверьте введенную информацию.';

  @override
  String get errorApiUnauthorized => 'Ошибка аутентификации. Проверьте API ключи.';

  @override
  String get errorApiForbidden => 'Доступ запрещен. У вас нет прав для этого действия.';

  @override
  String get errorApiNotFound => 'Ресурс не найден. Данные могут больше не существовать.';

  @override
  String get errorApiGeneral => 'Ошибка API. Попробуйте еще раз.';

  @override
  String get errorRateLimitExceeded => 'Превышен лимит запросов. Подождите немного.';

  @override
  String get errorUnknown => 'Произошла неожиданная ошибка. Попробуйте еще раз.';
}
