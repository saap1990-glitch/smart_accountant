import 'package:flutter_test/flutter_test.dart';

import 'package:smart_accountant/core/engine/accounting/transaction_context.dart';
import 'package:smart_accountant/core/errors/result.dart';

void main() {
  group('Accounting Core - TransactionContext', () {
    test('يقبل القيد المتوازن', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: 100000,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: 100000,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Success<void>>());
    });

    test('يرفض القيد غير المتوازن', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: 100000,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: 90000,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });

    test('يرفض القيد بدون بنود', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });

    test('يقبل القيد المركب المتوازن', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: 60000,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 40000,
            credit: 0,
          ),
          JournalItem(
            accountId: 3,
            debit: 0,
            credit: 100000,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Success<void>>());
    });

    test('يتعامل مع القيم السالبة في المدين', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: -100,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: 100,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });

    test('يتعامل مع القيم السالبة في الدائن', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: 100,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: -100,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });

    test('يرفض الحساب غير الصحيح', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 0,
            debit: 100,
            credit: 0,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: 100,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });

    test('يتحقق من السطر الذي يحتوي مديناً ودائناً معاً', () {
      final context = TransactionContext(
        type: TransactionType.journal,
        date: DateTime(2026, 1, 1),
        items: const [
          JournalItem(
            accountId: 1,
            debit: 100,
            credit: 50,
          ),
          JournalItem(
            accountId: 2,
            debit: 0,
            credit: 50,
          ),
        ],
      );

      final result = context.validate();

      expect(result, isA<Failure<void>>());
    });
  });
}
