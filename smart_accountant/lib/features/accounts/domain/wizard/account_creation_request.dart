class AccountCreationRequest {
  final String entityType;

  final String name;

  final String module;

  const AccountCreationRequest({
    required this.entityType,

    required this.name,

    required this.module,
  });
}
