import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twit_flutter/common/common.dart';
import 'package:twit_flutter/features/auth/controller/auth_controller.dart';
import 'package:twit_flutter/features/user_profile/controller/user_profile_controller.dart';
import 'package:twit_flutter/features/user_profile/widget/follow_count.dart';

import '../../../constants/constants.dart';
import '../../../models/twit_model.dart';
import '../../../models/user_model.dart';
import '../../../theme/theme.dart';
import '../../twit/controller/twit_controller.dart';
import '../../twit/widgets/tweet_card.dart';

class UserProfile extends ConsumerWidget {
  final UserModel user;
  const UserProfile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return currentUser == null
        ? const Loader()
        : NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  expandedHeight: 150,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                          child: user.bannerPic.isEmpty
                              ? Container(color: Pallete.blueColor)
                              : Image.network(user.bannerPic)),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                          alignment: Alignment.bottomRight,
                          margin: const EdgeInsets.all(20),
                          child: OutlinedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  side: const BorderSide(
                                      color: Pallete.whiteColor),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              child: Text(
                                currentUser.uid == user.uid
                                    ? 'Edit Profile'
                                    : 'Follow',
                                style:
                                    const TextStyle(color: Pallete.whiteColor),
                              )))
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(8),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    Text(user.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        )),
                    Text('@${user.name}',
                        style: const TextStyle(
                          fontSize: 17,
                          color: Pallete.greyColor,
                        )),
                    Text(user.bio,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Pallete.greyColor,
                        )),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        FollowCount(
                            count: user.following.length - 1,
                            text: 'Following'),
                        const SizedBox(width: 15),
                        FollowCount(
                            count: user.followers.length - 1, text: 'Followers')
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Divider(
                      color: Pallete.whiteColor,
                    )
                  ])),
                ),
              ];
            },
            body: ref.watch(getUserTweetsProvider(user.uid)).when(
                data: (tweets) {
                  return ref.watch(getLatestTweetProvider).when(
                      data: (data) {
                        final latestTweet = Tweet.fromMap(data.payload);
                        bool isTweetAlredyPresent = false;
                        for (final tweetModel in tweets) {
                          if (tweetModel.id == latestTweet.id) {
                            isTweetAlredyPresent = true;
                            break;
                          }
                        }
                        if (!isTweetAlredyPresent) {
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.create',
                          )) {
                            tweets.insert(0, Tweet.fromMap(data.payload));
                          } else if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.tweetsCollection}.documents.*.update',
                          )) {
                            // get id of original tweet
                            final startingPoint =
                                data.events[0].lastIndexOf('documents.');
                            final endPoint =
                                data.events[0].lastIndexOf('.update');
                            final tweetId = data.events[0]
                                .substring(startingPoint + 10, endPoint);

                            var tweet = tweets
                                .where((element) => element.id == tweetId)
                                .first;

                            final tweetIndex = tweets.indexOf(tweet);
                            tweets.removeWhere(
                                (element) => element.id == tweetId);

                            tweet = Tweet.fromMap(data.payload);
                            tweets.insert(tweetIndex, tweet);
                          }
                        }

                        return Expanded(
                          child: ListView.builder(
                              itemCount: tweets.length,
                              itemBuilder: (BuildContext context, int index) {
                                final tweet = tweets[index];
                                return TweetCard(
                                  tweet: tweet,
                                );
                              }),
                        );
                      },
                      error: (error, st) => ErrorText(error: error.toString()),
                      loading: () {
                        return Expanded(
                          child: ListView.builder(
                            itemCount: tweets.length,
                            itemBuilder: (BuildContext context, int index) {
                              final tweet = tweets[index];
                              return TweetCard(tweet: tweet);
                            },
                          ),
                        );
                      });
                },
                error: (error, stacktrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader()),
          );
  }
}
