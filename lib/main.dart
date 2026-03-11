import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:parking_lot_app/providers/auth_provider.dart';
import 'package:parking_lot_app/providers/parking_provider.dart';
import 'package:parking_lot_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
