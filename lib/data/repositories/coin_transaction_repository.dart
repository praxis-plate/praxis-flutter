import 'package:praxis/core/utils/result.dart';
import 'package:praxis/data/datasources/remote/coin_transaction_remote_datasource.dart';
import 'package:praxis/data/entities/coin_transaction_dto_extension.dart';
import 'package:praxis/data/mappers/coin_transaction_type_mapper.dart';
import 'package:praxis/domain/models/coin_transaction/coin_transaction_model.dart';
import 'package:praxis/domain/models/coin_transaction/create_coin_transaction_model.dart';
import 'package:praxis/domain/models/coin_transaction/wallet_balance.dart';
import 'package:praxis/domain/repositories/i_coin_transaction_repository.dart';

class CoinTransactionRepository implements ICoinTransactionRepository {
  final CoinTransactionRemoteDataSource _remoteDataSource;

  const CoinTransactionRepository(this._remoteDataSource);

  @override
  Future<Result<List<CoinTransactionModel>>> getTransactionHistory(
    String userId,
  ) async {
    final transactionDtos = await _remoteDataSource.getTransactionHistory();
    final models = transactionDtos.map((dto) => dto.toDomain()).toList();
    return Success(models);
  }

  @override
  Future<Result<void>> create(CreateCoinTransactionModel model) async {
    final serverType = CoinTransactionTypeMapper.toServerType(model.type);
    await _remoteDataSource.createTransaction(
      amount: model.amount,
      type: serverType,
      transactionKey: 'transaction_${DateTime.now().millisecondsSinceEpoch}',
      relatedEntityId: model.relatedEntityId != null
          ? int.parse(model.relatedEntityId!)
          : null,
    );
    return const Success(null);
  }

  Future<Result<WalletBalance>> getWalletBalance() async {
    final balanceDto = await _remoteDataSource.getWalletBalance();
    return Success(balanceDto.toDomain());
  }
}
