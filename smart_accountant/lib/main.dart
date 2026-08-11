import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/service_locator.dart';
import 'core/seeds/account_seed_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();

  final seedService = sl<AccountSeedService>();
  await seedService.seedIfEmpty();

  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const SmartAccountantApp()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF00796B),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.account_balance, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text('المحاسب الذكي', style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text('Enterprise', style: TextStyle(fontSize: 18, color: Colors.white70)),
              SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
