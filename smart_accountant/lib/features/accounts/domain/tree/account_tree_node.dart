import '../../../../core/database/app_database.dart';

class AccountTreeNode {
  final Account account;

  final List<AccountTreeNode> children;

  const AccountTreeNode({required this.account, required this.children});

  bool get isLeaf => children.isEmpty;

  int get childrenCount => children.length;
}
