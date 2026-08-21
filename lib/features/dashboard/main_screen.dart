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
import '../targets/targets_screen.dart';
import '../settings/settings_screen.dart';
import '../ai/ai_assistant_screen.dart';
import '../debts/debts_screen.dart';
import '../admin/admin_panel_screen.dart';
import '../../core/services/admin/owner_auth_service.dart';
import 'package:get_it/get_it.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool _isOwner = false;

  final List<Widget> _tabs = const [
    DashboardScreen(),
    OperationsMenu(),
    MasterDataMenu(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkOwner();
  }

  Future<void> _checkOwner() async {
    final ownerAuth = GetIt.I<OwnerAuthService>();
    final isOwner = await ownerAuth.isOwnerDevice();
    if (mounted) setState(() => _isOwner = isOwner);
  }

  void _showOwnerLogin() {
    final codeCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('دخول المالك'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('أدخل رمز المالك للوصول للوحة التحكم:'),
            const SizedBox(height: 12),
            TextField(controller: codeCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'رمز المالك', hintText: 'smart2026admin')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () async {
              final ownerAuth = GetIt.I<OwnerAuthService>();
              if (await ownerAuth.verifyOwner(codeCtrl.text)) {
                Navigator.pop(ctx);
                if (mounted) setState(() => _isOwner = true);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('رمز غير صحيح')));
              }
            },
            child: const Text('دخول'),
          ),
        ],
      ),
    );
  }

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
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                Icon(Icons.account_balance, size: 50, color: Colors.white),
                SizedBox(height: 8),
                Text('المحاسب الذكي', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Enterprise v1.0', style: TextStyle(color: Colors.white70, fontSize: 14)),
              ]),
            ),
            ListTile(
              leading: const Icon(Icons.auto_awesome, color: Colors.purple),
              title: const Text('المساعد الذكي'),
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AiAssistantScreen())); },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes, color: Colors.orange),
              title: const Text('الأهداف والتارجت'),
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const TargetsScreen())); },
            ),
            ListTile(
              leading: const Icon(Icons.money_off, color: Colors.red),
              title: const Text('الديون والتحصيل'),
              onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const DebtsScreen())); },
            ),
            const Divider(),
            // لوحة المالك - تظهر فقط بعد التحقق
            if (_isOwner)
              ListTile(
                leading: const Icon(Icons.admin_panel_settings, color: Colors.purple),
                title: const Text('لوحة تحكم المالك'),
                onTap: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminPanelScreen())); },
              )
            else
              ListTile(
                leading: const Icon(Icons.lock_outline, color: Colors.grey),
                title: const Text('دخول المالك'),
                onTap: () { Navigator.pop(context); _showOwnerLogin(); },
              ),
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
            _tile(context, 'سند قبض', Icons.arrow_downward, Colors.green, const ReceiptScreen()),
            _tile(context, 'سند صرف', Icons.arrow_upward, Colors.red, const PaymentScreen()),
            _tile(context, 'قيد يومية', Icons.book, Colors.blue, const JournalScreen()),
            _tile(context, 'تحويل بين الصناديق', Icons.swap_horiz, Colors.teal, const TransferCashScreen()),
            _tile(context, 'تحويل بين البنوك', Icons.account_balance, Colors.teal, const TransferBankScreen()),
            _tile(context, 'تحويل بين المحافظ', Icons.wallet, Colors.teal, const TransferWalletScreen()),
          ]),
          _section('المبيعات والمشتريات', [
            _tile(context, 'فاتورة بيع', Icons.point_of_sale, Colors.green, const SaleScreen()),
            _tile(context, 'فاتورة شراء', Icons.shopping_cart, Colors.orange, const PurchaseScreen()),
            _tile(context, 'مرتجع بيع', Icons.undo, Colors.red, const SaleReturnScreen()),
            _tile(context, 'مرتجع شراء', Icons.undo, Colors.red, const PurchaseReturnScreen()),
          ]),
          _section('العمليات المخزنية', [
            _tile(context, 'صرف مخزني', Icons.outbox, Colors.brown, const InventoryOutScreen()),
            _tile(context, 'توريد مخزني', Icons.inbox, Colors.brown, const InventoryInScreen()),
            _tile(context, 'تحويل مخزني', Icons.swap_vert, Colors.brown, const InventoryCountScreen()),
          ]),
        ],
      ),
    );
  }
  Widget _section(String title, List<Widget> children) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 4), child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal))),
      ...children,
    ]);
  }
  Widget _tile(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Card(margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), child: ListTile(leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 22)), title: Text(title), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen))));
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
          _tile(context, 'دليل الحسابات', Icons.account_tree, Colors.teal, const AccountsScreen()),
          _tile(context, 'العملاء', Icons.person, Colors.blue, const CustomersScreen()),
          _tile(context, 'الموردين', Icons.business, Colors.orange, const SuppliersScreen()),
          _tile(context, 'الأصناف', Icons.inventory, Colors.indigo, const ItemsScreen()),
          _tile(context, 'الوحدات', Icons.straighten, Colors.grey, const UnitsScreen()),
          _tile(context, 'المخازن', Icons.warehouse, Colors.brown, const WarehousesScreen()),
          _tile(context, 'البنوك', Icons.account_balance, Colors.blueGrey, const BanksScreen()),
          _tile(context, 'الصناديق', Icons.money, Colors.green, const CashBoxesScreen()),
          _tile(context, 'المحافظ', Icons.wallet, Colors.purple, const WalletsScreen()),
          _tile(context, 'شركات الصرافة', Icons.currency_exchange, Colors.amber, const ExchangeCompaniesScreen()),
          _tile(context, 'العملات', Icons.attach_money, Colors.teal, const CurrenciesScreen()),
        ],
      ),
    );
  }
  Widget _tile(BuildContext context, String title, IconData icon, Color color, Widget screen) {
    return Card(margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), child: ListTile(leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(icon, color: color, size: 22)), title: Text(title), trailing: const Icon(Icons.arrow_forward_ios, size: 16), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen))));
  }
}
