import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/common.dart';
import '../../../constants/constants.dart';
import '../../../core/core.dart';
import '../../../theme/pallete.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/twit_controller.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateTweetScreen(),
      );
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final TextEditingController tweetTextController = TextEditingController();
  List<File> images = [];

  @override
  void dispose() {
    tweetTextController.dispose();
    super.dispose();
  }

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
        images: images, text: tweetTextController.text, context: context, repliedTo: '');
    Navigator.of(context).pop();
  }

  void onPickImages() async {
    images = await pickimages();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          iconSize: 30,
        ),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet,
            label: 'Tweet',
            textColor: Pallete.whiteColor,
            backGroundColor: Pallete.blueColor,
          )
        ],
      ),
      body: isLoading || currentUser == null
          ? const Loader()
          : SafeArea(
              child: SingleChildScrollView(
                  child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(currentUser.profilePic),
                      radius: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: tweetTextController,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                        decoration: const InputDecoration(
                          hintText: "What's happening?",
                          hintStyle: TextStyle(
                            color: Pallete.greyColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
                if (images.isNotEmpty)
                  CarouselSlider(
                      items: images.map((file) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.file(file));
                      }).toList(),
                      options: CarouselOptions(
                        height: 400,
                        enableInfiniteScroll: false,
                      ))
              ],
            ))),
      bottomNavigationBar: Container(
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
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: GestureDetector(
                onTap: onPickImages,
                child: SvgPicture.asset(AssetsConstants.galleryIcon),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.gifIcon),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0).copyWith(
                left: 15,
                right: 15,
              ),
              child: SvgPicture.asset(AssetsConstants.emojiIcon),
            ),
          ],
        ),
      ),
    );
  }
}
