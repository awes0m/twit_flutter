import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twit_flutter/constants/asset_constants.dart';
import 'package:twit_flutter/core/enums/tweet_type_enum.dart';
import 'package:twit_flutter/features/auth/controller/auth_controller.dart';
import 'package:twit_flutter/features/twit/widgets/carousel_image.dart';
import 'package:twit_flutter/features/twit/widgets/hastags_text.dart';
import 'package:twit_flutter/features/twit/widgets/twit_icon_button.dart';
import 'package:twit_flutter/theme/pallete.dart';

import '../../../common/common.dart';
import '../../../models/twit_model.dart';

class TweetCard extends ConsumerWidget {
  final Tweet tweet;
  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(tweet.uid)).when(
        data: (user) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 35,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //retweeted
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 19),
                              ),
                            ),
                            Text(
                              "@${user.name} . ${timeago.format(tweet.tweetedAt, locale: 'en_short')}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Pallete.greyColor),
                            ),
                          ],
                        ),
                        //replied To
                        HashtagText(text: tweet.text),
                        if (tweet.tweetType == TweetType.image)
                          CarouselImage(imageLinks: tweet.imageLinks),
                        if (tweet.link.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          AnyLinkPreview(
                            displayDirection: UIDirection.uiDirectionHorizontal,
                            link: 'https://${tweet.link}',
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, right: 20),
                            child: Row(
                              children: [
                                TweetIconButton(
                                    pathName: AssetsConstants.viewsIcon,
                                    text: (tweet.commentIds.length +
                                            tweet.reShareCount +
                                            tweet.likes.length)
                                        .toString(),
                                    onTap: () {}),
                                TweetIconButton(
                                    pathName: AssetsConstants.commentIcon,
                                    text: tweet.commentIds.length.toString(),
                                    onTap: () {}),
                                TweetIconButton(
                                    pathName: AssetsConstants.retweetIcon,
                                    text: tweet.reShareCount.toString(),
                                    onTap: () {}),
                                TweetIconButton(
                                    pathName: AssetsConstants.likeOutlinedIcon,
                                    text: tweet.likes.length.toString(),
                                    onTap: () {}),
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share_outlined,
                                      size: 25,
                                      color: Pallete.greyColor,
                                    ))
                              ],
                            ),
                          ),
                          const Divider(
                            color: Pallete.greyColor,
                          )
                        ]
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        },
        error: (error, st) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
