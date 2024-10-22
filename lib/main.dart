import 'package:flutter/material.dart';
import 'package:inventual/src/application.dart';
import 'package:inventual/src/utils/dependency_injection.dart';

Future<void> main() async {
  runApp(const MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Application();
  }
}
