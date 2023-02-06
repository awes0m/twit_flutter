import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twit_flutter/apis/storage_api.dart';
import 'package:twit_flutter/apis/tweet_api.dart';
import 'package:twit_flutter/core/core.dart';
import 'package:twit_flutter/core/enums/tweet_type_enum.dart';
import 'package:twit_flutter/features/auth/controller/auth_controller.dart';

import '../../../models/twit_model.dart';

final tweetControllerProvider =
    StateNotifierProvider.autoDispose<TweetController, bool>((ref) {
  return TweetController(
      ref: ref,
      tweetAPI: ref.watch(tweetAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});

final getTweetsProvider = FutureProvider.autoDispose((ref) async {
  final tweetController = ref.watch(tweetControllerProvider.notifier);
  return tweetController.getTweets();
});

final getLatestTweetProvider =
    StreamProvider.autoDispose<RealtimeMessage>((ref) {
  final tweetAPI = ref.watch(tweetAPIProvider);
  return tweetAPI.getLatestTweet();
});

class TweetController extends StateNotifier<bool> {
  final TweetAPI _tweetAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;
  TweetController(
      {required TweetAPI tweetAPI,
      required StorageAPI storageAPI,
      required Ref ref})
      : _tweetAPI = tweetAPI,
        _storageAPI = storageAPI,
        _ref = ref,
        super(false);

  Future<List<Tweet>> getTweets() async {
    final tweetList = await _tweetAPI.getTweets();
    return tweetList.map((tweet) => Tweet.fromMap(tweet.data)).toList();
  }

  Future<void> _shareImageTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value;
    final imageLinks = await _storageAPI.uploadimage(images);
    Tweet tweet = Tweet(
      text: text,
      hashtags: hashtags,
      link: link,
      imageLinks: imageLinks,
      uid: user!.uid,
      tweetType: TweetType.image,
      tweetedAt: DateTime.now(),
      likes: const [],
      commentIds: const [],
      id: '',
      reShareCount: 0,
    );
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  Future<void> _shareTextTweet({
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHashtagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value;
    Tweet tweet = Tweet(
        text: text,
        hashtags: hashtags,
        link: link,
        imageLinks: const [],
        uid: user!.uid,
        tweetType: TweetType.text,
        tweetedAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: '',
        reShareCount: 0);
    final res = await _tweetAPI.shareTweet(tweet);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) => null);
  }

  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHashtagsFromText(String text) {
    List<String> hashtags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtags.add(word);
      }
    }
    return hashtags;
  }

  void shareTweet({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please enter Text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageTweet(images: images, text: text, context: context);
    } else {
      _shareTextTweet(text: text, context: context);
    }
  }
}
