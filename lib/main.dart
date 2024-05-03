import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'provider/provider_theme.dart';
import 'screens/signin.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyDbh02AnaqkuoDJ8EPrRuS9sm8pJCT2R_s',
          appId: '1:343475136627:android:fa0c5108ffebb3ec9e2206',
          messagingSenderId: '343475136627',
          projectId: 'bucket-bfa5c'));

  runApp(
    ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeNotifier>(context).getTheme(),
        home: const SplashScreen());
  }
}
