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

abstract class UserWallet implements _i1.SerializableModel {
  UserWallet._({
    this.id,
    required this.authUserId,
    required this.balance,
    required this.available,
    required this.held,
    required this.currency,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserWallet({
    int? id,
    required _i1.UuidValue authUserId,
    required int balance,
    required int available,
    required int held,
    required String currency,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserWalletImpl;

  factory UserWallet.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserWallet(
      id: jsonSerialization['id'] as int?,
      authUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['authUserId'],
      ),
      balance: jsonSerialization['balance'] as int,
      available: jsonSerialization['available'] as int,
      held: jsonSerialization['held'] as int,
      currency: jsonSerialization['currency'] as String,
      version: jsonSerialization['version'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue authUserId;

  int balance;

  int available;

  int held;

  String currency;

  int version;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [UserWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserWallet copyWith({
    int? id,
    _i1.UuidValue? authUserId,
    int? balance,
    int? available,
    int? held,
    String? currency,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserWallet',
      if (id != null) 'id': id,
      'authUserId': authUserId.toJson(),
      'balance': balance,
      'available': available,
      'held': held,
      'currency': currency,
      'version': version,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserWalletImpl extends UserWallet {
  _UserWalletImpl({
    int? id,
    required _i1.UuidValue authUserId,
    required int balance,
    required int available,
    required int held,
    required String currency,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         authUserId: authUserId,
         balance: balance,
         available: available,
         held: held,
         currency: currency,
         version: version,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserWallet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserWallet copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? authUserId,
    int? balance,
    int? available,
    int? held,
    String? currency,
    int? version,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserWallet(
      id: id is int? ? id : this.id,
      authUserId: authUserId ?? this.authUserId,
      balance: balance ?? this.balance,
      available: available ?? this.available,
      held: held ?? this.held,
      currency: currency ?? this.currency,
      version: version ?? this.version,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
