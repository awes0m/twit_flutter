import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twit_flutter/features/explore/view/explore_view.dart';

import '../features/twit/widgets/tweet_list.dart';
import '../theme/theme.dart';
import 'asset_constants.dart';

class UIConstants {
  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(
        AssetsConstants.twitterLogo,
        color: Pallete.blueColor,
        height: 30,
      ),
      centerTitle: true,
    );
  }

  static List<Widget> bottomTabBarPages = [
    const TweetList(),
    const ExploreView(),
    const Text('Notification screen')
  ];
}
