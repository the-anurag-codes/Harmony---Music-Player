import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/theme.dart';
import 'package:client/features/auth/view/screens/signup_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/screens/home_screen.dart';
import 'package:client/features/home/view/screens/upload_song_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  final container = ProviderContainer();
  await container.read(authViewModelProvider.notifier).initSharedPrefs();
  await container.read(authViewModelProvider.notifier).getData();
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider.notifier);
    return MaterialApp(
      title: 'Flutter MusicApp',
      theme: AppTheme.darkThemeMode,
      home: currentUser.state == null
          ? const SignUpScreen()
          : const UploadSongScreen(),
    );
  }
}
