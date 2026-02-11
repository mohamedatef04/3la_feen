// ignore_for_file: depend_on_referenced_packages
import 'package:ala_feen/core/cubits/cubit/theme_toggle_cubit.dart';
import 'package:ala_feen/core/routes/app_routes.dart';
import 'package:ala_feen/firebase_options.dart';
import 'package:ala_feen/core/services/chat_notification_service.dart';
import 'package:ala_feen/core/utils/marker_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection_container.dart' as di;
import 'package:ala_feen/core/utils/notifcations.dart/fcm.dart';
import 'package:ala_feen/core/utils/notifcations.dart/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await dotenv.load(fileName: ".env");

  // Initialize Notifications & Channel
  final localNotifications = LocalNotifications();
  await localNotifications.init();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize global chat notification service
  await ChatNotificationService().init();

  // Initialize custom map markers
  await MarkerUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => BlocProvider(
        create: (context) => ThemeToggleCubit(),
        child: BlocBuilder<ThemeToggleCubit, ThemeData>(
          builder: (context, state) {
            return MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              theme: state,
              themeMode: ThemeMode.system,
              locale: const Locale('ar'),
              supportedLocales: const [
                Locale('ar'),
                Locale('en'),
              ],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          },
        ),
      ),
    );
  }
}
