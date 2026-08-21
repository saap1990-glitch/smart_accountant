class AuditEntry {

  const AuditEntry({
    required this.id,
    required this.action,
    required this.entityType,
    required this.timestamp,
    this.entityId,
    this.description,
    this.performedBy,
  });
  final String id;
  final String action;
  final String entityType;
  final String? entityId;
  final DateTime timestamp;
  final String? description;
  final String? performedBy;
}
