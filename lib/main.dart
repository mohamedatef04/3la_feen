// ignore_for_file: depend_on_referenced_packages
import 'package:ala_feen/core/cubits/cubit/theme_toggle_cubit.dart';
import 'package:ala_feen/core/routes/app_routes.dart';
import 'package:ala_feen/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/di/injection_container.dart' as di;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  await Supabase.initialize(
    url: 'https://rtxpmgwxndzuaxjajyni.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0eHBtZ3d4bmR6dWF4amFqeW5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY4NDk2NTcsImV4cCI6MjA4MjQyNTY1N30.w_mp6Vjti1K2XEV_ROsYa_cqx5Lo1MSe7FXLnZrgJYM',
  );
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
