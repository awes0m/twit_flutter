import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twit_flutter/core/core.dart';
import 'package:twit_flutter/features/twit/controller/twit_controller.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../models/twit_model.dart';
import '../../../theme/theme.dart';
import '../widgets/tweet_card.dart';

class TwitterReplyScreen extends ConsumerStatefulWidget {
  static route(Tweet tweet) => MaterialPageRoute(
        builder: (context) => TwitterReplyScreen(tweet: tweet),
      );
  final Tweet tweet;
  const TwitterReplyScreen({
    super.key,
    required this.tweet,
  });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TwitterReplyScreenState();
}

class _TwitterReplyScreenState extends ConsumerState<TwitterReplyScreen> {
  List<File> tweetImages = [];
  void onPickImages() async {
    tweetImages = (await pickimages()).cast<File>();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tweet')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TweetCard(tweet: widget.tweet),
          ref.watch(getRepliesToProvider(widget.tweet)).when(
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
                        if (!isTweetAlredyPresent &&
                            latestTweet.repliedTo == widget.tweet.id) {
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
                error: (error, st) => ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (tweetImages.isNotEmpty)
                  CarouselSlider(
                      items: tweetImages.map((file) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.file(
                              file,
                              fit: BoxFit.contain,
                            ));
                      }).toList(),
                      options: CarouselOptions(
                        height: 200,
                        enableInfiniteScroll: false,
                      )),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Pallete.greyColor,
                        width: 0.3,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: onPickImages,
                          child: SvgPicture.asset(AssetsConstants.galleryIcon,
                              width: 20),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 36,
                        child: TextField(
                          decoration: const InputDecoration(
                              hintText: 'Tweet your reply'),
                          onSubmitted: (value) {
                            ref
                                .read(tweetControllerProvider.notifier)
                                .shareTweet(
                                    images: tweetImages,
                                    text: value,
                                    context: context,
                                    repliedTo: widget.tweet.id);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
