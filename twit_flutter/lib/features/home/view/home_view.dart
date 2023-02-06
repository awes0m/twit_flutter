import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/constants.dart';
import '../../../theme/theme.dart';
import '../../twit/view/create_twit_view.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;
  final appBar = UIConstants.appBar();

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }

  void onCreateTweet() {
    Navigator.push(context, CreateTweetScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
          onPressed: onCreateTweet, child: const Icon(Icons.add)),
      body: IndexedStack(
        index: _page,
        children: UIConstants.bottomTabBarPages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _page,
        onTap: onPageChanged,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
            _page == 0
                ? AssetsConstants.homeFilledIcon
                : AssetsConstants.homeOutlinedIcon,
            color: Pallete.whiteColor,
          )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
            AssetsConstants.searchIcon,
            color: Pallete.whiteColor,
          )),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
            _page == 2
                ? AssetsConstants.notifFilledIcon
                : AssetsConstants.notifOutlinedIcon,
            color: Pallete.whiteColor,
          )),
        ],
      ),
    );
  }
}
