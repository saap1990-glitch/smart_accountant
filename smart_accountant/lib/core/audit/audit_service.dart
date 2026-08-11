import 'audit_entry.dart';
import 'dart:async';

abstract class AuditService {
  Future<void> record(AuditEntry entry);
  Future<List<AuditEntry>> getAll();
  Stream<AuditEntry> watchAll();
}
