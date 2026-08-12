import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import '../operations/receipt/receipt_screen.dart';
import '../operations/payment/payment_screen.dart';
import '../operations/journal/journal_screen.dart';
import '../operations/sale/sale_screen.dart';
import '../operations/purchase/purchase_screen.dart';
import '../operations/sale_return/sale_return_screen.dart';
import '../operations/purchase_return/purchase_return_screen.dart';
import '../operations/transfer_cash/transfer_cash_screen.dart';
import '../operations/transfer_bank/transfer_bank_screen.dart';
import '../operations/transfer_wallet/transfer_wallet_screen.dart';
import '../operations/inventory_count/inventory_count_screen.dart';
import '../operations/inventory_out/inventory_out_screen.dart';
import '../operations/inventory_in/inventory_in_screen.dart';
import '../customers/customers_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../items/items_screen.dart';
import '../units/units_screen.dart';
import '../warehouses/warehouses_screen.dart';
import '../banks/banks_screen.dart';
import '../cash_boxes/cash_boxes_screen.dart';
import '../wallets/wallets_screen.dart';
import '../exchange_companies/exchange_companies_screen.dart';
import '../currencies/currencies_screen.dart';
import '../accounts/accounts_screen.dart';
import '../reports/reports_screen.dart';
import '../settings/settings_screen.dart';
import '../ai/ai_assistant_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _tabs = const [
    DashboardScreen(),
    OperationsMenu(),
    MasterDataMenu(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'العمليات'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: 'البيانات'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'تقارير'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'إعدادات'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('المحاسب الذكي', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: const Text('المساعد الذكي'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AiAssistantScreen()))),
          ],
        ),
      ),
    );
  }
}

class OperationsMenu extends StatelessWidget {
  const OperationsMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('العمليات')),
      body: ListView(
        children: [
          _section('العمليات المالية', [
            _tile(context, 'سند قبض', const ReceiptScreen()),
            _tile(context, 'سند صرف', const PaymentScreen()),
            _tile(context, 'قيد يومية', const JournalScreen()),
            _tile(context, 'تحويل بين الصناديق', const TransferCashScreen()),
            _tile(context, 'تحويل بين البنوك', const TransferBankScreen()),
            _tile(context, 'تحويل بين المحافظ', const TransferWalletScreen()),
          ]),
          _section('المبيعات والمشتريات', [
            _tile(context, 'فاتورة بيع', const SaleScreen()),
            _tile(context, 'فاتورة شراء', const PurchaseScreen()),
            _tile(context, 'مرتجع بيع', const SaleReturnScreen()),
            _tile(context, 'مرتجع شراء', const PurchaseReturnScreen()),
          ]),
          _section('العمليات المخزنية', [
            _tile(context, 'صرف مخزني', const InventoryOutScreen()),
            _tile(context, 'توريد مخزني', const InventoryInScreen()),
            _tile(context, 'جرد المخزون', const InventoryCountScreen()),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.all(8.0), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal))),
        ...children,
        const Divider(),
      ],
    );
  }

  Widget _tile(BuildContext context, String title, Widget screen) {
    return ListTile(title: Text(title), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)));
  }
}

class MasterDataMenu extends StatelessWidget {
  const MasterDataMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('البيانات الأساسية')),
      body: ListView(
        children: [
          _tile(context, 'العملاء', const CustomersScreen()),
          _tile(context, 'الموردين', const SuppliersScreen()),
          _tile(context, 'الأصناف', const ItemsScreen()),
          _tile(context, 'الوحدات', const UnitsScreen()),
          _tile(context, 'المخازن', const WarehousesScreen()),
          _tile(context, 'البنوك', const BanksScreen()),
          _tile(context, 'الصناديق', const CashBoxesScreen()),
          _tile(context, 'المحافظ', const WalletsScreen()),
          _tile(context, 'شركات الصرافة', const ExchangeCompaniesScreen()),
          _tile(context, 'العملات', const CurrenciesScreen()),
            _tile(context, 'دليل الحسابات', const AccountsScreen()),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context, String title, Widget screen) {
    return ListTile(title: Text(title), trailing: const Icon(Icons.arrow_forward_ios), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)));
  }
}
