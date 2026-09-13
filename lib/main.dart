import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_travel_concept/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_travel_concept/data/repositories/places_repository_impl.dart';
import 'package:flutter_travel_concept/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:flutter_travel_concept/presentation/cubits/places/places_cubit.dart';
import 'package:flutter_travel_concept/router/app_router.dart';
import 'package:flutter_travel_concept/util/const.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(repository: FavoritesRepositoryImpl()),
        ),
        BlocProvider<PlacesCubit>(
          create: (_) => PlacesCubit(repository: PlacesRepositoryImpl()),
        ),
      ],
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeNotifier,
        builder: (context, currentMode, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: Constants.appName,
            theme: Constants.lightTheme,
            darkTheme: Constants.darkTheme,
            themeMode: currentMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
