import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:task/data/data.dart';
import 'package:task/data/repo/repository.dart';
import 'package:task/data/source/hive_task_source.dart';
import 'package:task/screen/home/home.dart';

const taskBoxName = "tasks";
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryvarientColor));

  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) =>
          Repository<TaskEntity>(HiveTaskDataSource(Hive.box(taskBoxName))),
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryvarientColor = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0);
const normalPriority = Color(0xffF09819);
const lowPriority = Color(0xff3BE1F1);
const highpriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final primaryTextColor = const Color(0xff1D2830);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          textTheme: GoogleFonts.poppinsTextTheme(
              TextTheme(headline6: TextStyle(fontWeight: FontWeight.bold))),
          inputDecorationTheme: InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              labelStyle: TextStyle(color: secondaryTextColor),
              border: InputBorder.none,
              iconColor: secondaryTextColor),
          colorScheme: ColorScheme.light(
              primary: primaryColor,
              primaryVariant: primaryvarientColor,
              background: Color(0xffF3F5F8),
              onSurface: primaryTextColor,
              onBackground: primaryTextColor,
              secondary: primaryColor,
              onSecondary: Colors.white,
              onPrimary: Colors.white)),
      home: Homescreen(),
    );
  }
}
