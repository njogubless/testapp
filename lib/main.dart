import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:testapp/firebase_options.dart';
import 'package:testapp/screens/loading_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Wonder Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyanAccent),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, authSnapshot) {
          if (authSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingScreen();
          } else if (authSnapshot.hasData) {
            return TestApp();
          } else if (authSnapshot.hasError) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${authSnapshot.error}'),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.of(context).pushNamed('/login');
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            );
          } else {
            return SignInScreen(providers: [EmailAuthProvider()]);
          }
        },
      ),
    );
  }
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Firebase Storage")),
      body: FutureBuilder(
        future: FirebaseStorage.instance
            .ref("profile_images/8xJtSrCr6fWWa024zWs1Ztd2MYd2.png")
            .getDownloadURL(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                constraints: BoxConstraints.tightFor(width: 36, height: 36),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Errors: ${snapshot.error}"));
          }

          if (snapshot.data == null) {
            return Center(child: Text("No results found"));
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(snapshot.data!),
              Material(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 3,
                child: Image.network(
                  snapshot.data!,
                  height: 300,
                  width: 300,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
