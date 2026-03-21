import 'package:praxis/domain/enums/coin_transaction_type.dart' as domain;
import 'package:praxis_client/praxis_client.dart' as server;

class CoinTransactionTypeMapper {
  static server.CoinTransactionType toServerType(
    domain.CoinTransactionType domainType,
  ) {
    switch (domainType) {
      case domain.CoinTransactionType.coursePurchase:
        return server.CoinTransactionType.buy;
      case domain.CoinTransactionType.taskCompletion:
        return server.CoinTransactionType.topUp;
      case domain.CoinTransactionType.lessonCompletion:
        return server.CoinTransactionType.topUp;
      case domain.CoinTransactionType.initialGrant:
        return server.CoinTransactionType.topUp;
    }
  }

  static domain.CoinTransactionType toDomainType(
    server.CoinTransactionType serverType,
  ) {
    switch (serverType) {
      case server.CoinTransactionType.buy:
        return domain.CoinTransactionType.coursePurchase;
      case server.CoinTransactionType.topUp:
        return domain.CoinTransactionType.initialGrant;
      default:
        return domain.CoinTransactionType.initialGrant;
    }
  }
}
