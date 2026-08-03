import '../../../../core/database/app_database.dart';

import 'account_tree_node.dart';

class AccountTreeEngine {
  final AppDatabase db;

  AccountTreeEngine(this.db);

  Future<List<AccountTreeNode>> buildTree() async {
    final accounts = await db.select(db.accounts).get();

    final roots = accounts.where((a) => a.parentId == null).toList();

    return roots.map((root) => _buildNode(root, accounts)).toList();
  }

  AccountTreeNode _buildNode(Account account, List<Account> all) {
    final children = all.where((a) => a.parentId == account.id).toList();

    return AccountTreeNode(
      account: account,

      children: children.map((child) => _buildNode(child, all)).toList(),
    );
  }
}
