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
import 'package:ala_feen/core/utils/notifications/fcm.dart';
import 'package:ala_feen/core/utils/notifications/local.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ala_feen/core/localization/localization_manager.dart';
import 'package:easy_localization/easy_localization.dart';

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

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: LocalizationManager.supportedLocales,
      path: LocalizationManager.translationsPath,
      startLocale: LocalizationManager.defaultLocale,
      fallbackLocale: LocalizationManager.defaultLocale,
      child: const MyApp(),
    ),
  );
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
              // The selected language is saved by EasyLocalization and
              // drives RTL/LTR through the material localizations.
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              // Rebuild every screen when the language changes so strings
              // read outside the widget tree (AppStrings, .tr()) refresh.
              builder: (context, child) => KeyedSubtree(
                key: ValueKey(context.locale),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
