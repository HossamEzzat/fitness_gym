import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/gym/data/datasources/member_local_data_source.dart';
import 'features/gym/data/models/member_model.dart';
import 'features/gym/data/repositories/member_repository_impl.dart';
import 'features/gym/presentation/bloc/member_bloc.dart';
import 'features/gym/presentation/bloc/member_event.dart';
import 'features/gym/domain/entities/member.dart';
import 'features/gym/presentation/pages/splash_screen.dart';
import 'core/theme/theme_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(MemberStatusAdapter());
  Hive.registerAdapter(MemberModelAdapter()); // Note: This will be generated
  late Box<MemberModel> memberBox;
  try {
    memberBox = await Hive.openBox<MemberModel>('members');
  } catch (e) {
    // Handle data corruption or schema mismatch by resetting the box
    await Hive.deleteBoxFromDisk('members');
    memberBox = await Hive.openBox<MemberModel>('members');
  }

  final localDataSource = MemberLocalDataSourceImpl(memberBox);
  final repository = MemberRepositoryImpl(localDataSource: localDataSource);

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final MemberRepositoryImpl repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MemberBloc(repository: repository)..add(LoadMembers()),
        ),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Fitness Gym',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const SplashScreen(),
            locale: const Locale('ar'),
          );
        },
      ),
    );
  }
}
