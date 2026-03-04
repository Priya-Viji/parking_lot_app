import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking_lot_app/providers/auth_provider.dart';
import 'package:parking_lot_app/providers/parking_provider.dart';
import 'package:parking_lot_app/screens/splash_screen.dart';
import 'package:parking_lot_app/services/parking_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run this ONCE to create slots 
  final parkingService = ParkingService();
  await parkingService.initializeSlots(20); // change 20 to any N you want

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ParkingProvider()),
      ],
      child: MaterialApp(
        title: 'Parking Lot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
