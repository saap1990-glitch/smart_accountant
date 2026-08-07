import 'package:flutter/material.dart';
import '../../core/database/app_database.dart';

import '../../features/dashboard/dashboard_screen.dart';
import '../../features/accounts/chart_accounts_screen.dart';
import '../../features/cash/cash_boxes_screen.dart';
import '../../features/banks/banks_screen.dart';
import '../../features/wallets/wallets_screen.dart';
import '../../features/exchange/exchange_companies_screen.dart';
import '../../features/customers/customers_screen.dart';
import '../../features/suppliers/suppliers_screen.dart';
import '../../features/items/items_screen.dart';
import '../../features/warehouses/warehouses_screen.dart';
import '../../features/transactions/receipt_screen.dart';
import '../../features/transactions/payment_screen.dart';
import '../../features/transactions/sales_screen.dart';
import '../../features/transactions/purchases_screen.dart';
import '../../features/reports/reports_screen.dart';

class AppRoutes {

  static Map<String, WidgetBuilder> routes({
    required AppDatabase db,
  }) {
    return {

      '/': (_) => DashboardScreen(db: db),

      '/accounts': (_) => ChartAccountsScreen(db: db),

      '/cash': (_) => CashBoxesScreen(db: db),

      '/banks': (_) => BanksScreen(db: db),

      '/wallets': (_) => WalletsScreen(db: db),

      '/exchange': (_) =>
          ExchangeCompaniesScreen(db: db),

      '/customers': (_) =>
          CustomersScreen(db: db),

      '/suppliers': (_) =>
          SuppliersScreen(db: db),

      '/items': (_) =>
          ItemsScreen(db: db),

      '/warehouses': (_) =>
          WarehousesScreen(db: db),

      '/receipt': (_) =>
          const ReceiptScreen(),

      '/payment': (_) =>
          const PaymentScreen(),

      '/sales': (_) =>
          const SalesScreen(),

      '/purchases': (_) =>
          const PurchasesScreen(),

      '/reports': (_) =>
          const ReportsScreen(),
    };
  }
}
