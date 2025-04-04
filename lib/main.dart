import 'package:trainner_app/responsive/mobile_screen_layout.dart';
import 'package:trainner_app/responsive/responsive_layout_screen.dart';
import 'package:trainner_app/responsive/web_screen_layout.dart';
import 'package:trainner_app/screens/user/login_screen.dart';
import 'package:trainner_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDfxGZhfo7VqLRJASqlHnqHxrtiitJ6NbM",
            authDomain: "trainner-app-1b230.firebaseapp.com",
            projectId: "trainner-app-1b230",
            storageBucket: "trainner-app-1b230.firebasestorage.app",
            messagingSenderId: "1097912803730",
            appId: "1:1097912803730:web:6e953b11a56572e2ba614b"),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    debugPrint("Erro ao inicializar o Firebase: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Albert Trainner',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: const AuthChecker(),
      ),
    );
  }
}

class AuthChecker extends StatelessWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erro: ${snapshot.error}')),
          );
        }
        if (snapshot.hasData) {
          return const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
        }
        return const LoginScreen();
      },
    );
  }
}
