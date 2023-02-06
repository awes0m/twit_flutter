import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twit_flutter/common/common.dart';
import 'package:twit_flutter/features/twit/controller/twit_controller.dart';
import 'package:twit_flutter/models/twit_model.dart';

import '../../../constants/constants.dart';
import 'tweet_card.dart';

class TweetList extends ConsumerWidget {
  const TweetList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getTweetsProvider).when(
        data: (tweets) {
          return ref.watch(getLatestTweetProvider).when(
              data: (data) {
                if (data.events.contains(
                    'databases.*.collections.${AppwriteConstants.tweetsColletion}.documents.*.create')) {
                  tweets.insert(0, Tweet.fromMap(data.payload));
                }

                return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(
                        tweet: tweet,
                      );
                    });
              },
              error: (error, st) => ErrorText(error: error.toString()),
              loading: () {
                return ListView.builder(
                    itemCount: tweets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tweet = tweets[index];
                      return TweetCard(
                        tweet: tweet,
                      );
                    });
              });
        },
        error: (error, st) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
