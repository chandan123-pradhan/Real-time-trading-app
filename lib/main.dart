import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_time_trading_app/feature/chart/presentation/bloc/ohlc_bloc.dart';
import 'package:real_time_trading_app/feature/chart/presentation/screen/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OhlcBloc(),
      child: MaterialApp(
        title: 'Mock OHLC Dashboard',
        theme: ThemeData.dark(),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
