import 'package:flutter/material.dart';
import 'package:pi_app/app_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pi_app/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        // Você pode adicionar mais providers aqui se necessário
      ],
      child: AppWidget(),
    ),
  );
}
