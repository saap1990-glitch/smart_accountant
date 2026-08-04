import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دفتر المحاسب الذكي'),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        children: const [
          _DashboardCard(
            title: 'الحسابات',
            icon: Icons.account_balance,
          ),
          _DashboardCard(
            title: 'الصندوق',
            icon: Icons.money,
          ),
          _DashboardCard(
            title: 'المبيعات',
            icon: Icons.shopping_cart,
          ),
          _DashboardCard(
            title: 'التقارير',
            icon: Icons.analytics,
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const _DashboardCard({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 45),
            const SizedBox(height: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
