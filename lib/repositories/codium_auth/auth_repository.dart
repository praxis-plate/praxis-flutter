import 'package:codium/core/exceptions/exceptions.dart';
import 'package:codium/repositories/codium_auth/abstract_auth_repository.dart';
import 'package:codium/repositories/codium_courses/models/models.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:talker_flutter/talker_flutter.dart';

final class AuthRepository implements IAuthRepository {
  final SupabaseClient supabaseClient;

  AuthRepository({
    required this.supabaseClient,
  });

  @override
  Future<User> signUp(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      GetIt.I<Talker>().log(response.user!.toJson());

      response.user!.toJson();

      return User(
        id: response.user!.id,
        email: response.user!.email!,
        name: response.user!.userMetadata?['name'] ?? '',
        imagePath: response.user!.userMetadata?['imagePath'] ?? '',
      );
    } on AuthException catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      GetIt.I<Talker>().log(response.user!.toJson());

      return User(
        id: response.user!.id,
        email: response.user!.email!,
        name: response.user!.userMetadata?['name'] ?? '',
        imagePath: response.user!.userMetadata?['imagePath'] ?? '',
      );
    } on AuthException catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await supabaseClient.auth.signOut();
    } on AuthException catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.message);
    } catch (e) {
      GetIt.I<Talker>().error(e.toString());
      throw ServerException(e.toString());
    }
  }
}
