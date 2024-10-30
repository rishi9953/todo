import 'package:get/get.dart';
import 'package:todo_list/Screens/home.dart';
import 'package:todo_list/Routes/routes_name.dart';
import 'package:todo_list/Screens/splash_screen.dart';

List<GetPage> pages = [
  GetPage(name: Routesname.splash, page: () => const SplashScreen()),
  GetPage(name: Routesname.home, page: () => const HomeScreen()),
];
