import 'package:drift/drift.dart';

import '../../database/app_database.dart';

class AccountLinkService {
  final AppDatabase db;

  AccountLinkService(this.db);

  Future<void> createLink({
    required String module,
    required String entityType,
    required int entityId,
    required int accountId,
  }) async {
    final exists =
        await (db.select(db.accountLinks)..where(
              (t) => Expression.and([
                t.module.equals(module),
                t.entityType.equals(entityType),
                t.entityId.equals(entityId),
              ]),
            ))
            .getSingleOrNull();

    if (exists != null) return;

    await db
        .into(db.accountLinks)
        .insert(
          AccountLinksCompanion.insert(
            module: module,
            entityType: entityType,
            entityId: entityId,
            accountId: accountId,
          ),
        );
  }

  Future<int?> getAccountId({
    required String module,
    required String entityType,
    required int entityId,
  }) async {
    final link =
        await (db.select(db.accountLinks)..where(
              (t) => Expression.and([
                t.module.equals(module),
                t.entityType.equals(entityType),
                t.entityId.equals(entityId),
              ]),
            ))
            .getSingleOrNull();

    return link?.accountId;
  }

  Future<void> deleteLink({
    required String module,
    required String entityType,
    required int entityId,
  }) async {
    await (db.delete(db.accountLinks)..where(
          (t) => Expression.and([
            t.module.equals(module),
            t.entityType.equals(entityType),
            t.entityId.equals(entityId),
          ]),
        ))
        .go();
  }
}
