import 'package:codium/core/error/failure.dart';
import 'package:codium/core/exceptions/app_error.dart';
import 'package:codium/core/utils/result.dart';
import 'package:codium/data/entities/coin_transaction_entity_extension.dart';
import 'package:codium/domain/datasources/i_coin_transaction_local_datasource.dart';
import 'package:codium/domain/models/coin_transaction/coin_transaction_model.dart';
import 'package:codium/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:codium/domain/repositories/i_coin_transaction_repository.dart';

class CoinTransactionRepository implements ICoinTransactionRepository {
  final ICoinTransactionLocalDataSource _localDataSource;

  const CoinTransactionRepository(this._localDataSource);

  @override
  Future<Result<List<CoinTransactionModel>>> getTransactionHistory(
    String userId,
  ) async {
    try {
      final entities = await _localDataSource.getTransactionHistory(userId);
      final transactions = entities.map((e) => e.toDomain()).toList();
      return Success(transactions);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }

  @override
  Future<Result<void>> create(CreateCoinTransactionModel model) async {
    try {
      await _localDataSource.insertTransaction(model.toCompanion());
      return const Success(null);
    } on AppError catch (e) {
      return Failure(AppFailure.fromError(e));
    } catch (e) {
      return Failure(AppFailure.fromException(e as Exception));
    }
  }
}
