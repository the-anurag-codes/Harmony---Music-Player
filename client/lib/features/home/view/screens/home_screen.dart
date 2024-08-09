import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/screens/library_screen.dart';
import 'package:client/features/home/view/screens/songs_screen.dart';
import 'package:client/features/home/view/widgets/music_slab.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  final pages = const [SongsScreen(), LibraryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pages[selectedIndex],
          const Positioned(
            bottom: 0,
            child: MusicSlab(),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Image.asset(
                selectedIndex == 0
                    ? 'assets/images/home_filled.png'
                    : 'assets/images/home_unfilled.png',
                color: selectedIndex == 0
                    ? Pallete.whiteColor
                    : Pallete.inactiveBottomBarItemColor,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/library.png',
              color: selectedIndex == 1
                  ? Pallete.whiteColor
                  : Pallete.inactiveBottomBarItemColor,
            ),
            label: 'Library',
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
    );
  }
}
