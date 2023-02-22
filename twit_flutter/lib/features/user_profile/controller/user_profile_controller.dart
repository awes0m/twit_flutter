import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twit_flutter/features/auth/controller/auth_controller.dart';

import '../../../apis/tweet_api.dart';
import '../../../models/twit_model.dart';

final userProfileControllerProvider = StateNotifierProvider((ref) {
  return UserProfileController(
    tweetAPI: ref.watch(tweetAPIProvider),
  );
});

final getUserTweetsProvider = FutureProviderFamily((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserTweets(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  UserProfileController({
    required TweetAPI tweetAPI,
  })  : _tweetAPI = tweetAPI,
        super(false);

  Future<List<Tweet>> getUserTweets(String uid) async {
    final tweets = await _tweetAPI.getUserTweets(uid);
    return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  }
}
